//
//  SFXMPPManager.m
//  shopFriend
//
//  Created by Beautilut on 14-2-25.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "SFXMPPManager.h"

@implementation SFXMPPManager

static SFXMPPManager * sharedManager;
+(SFXMPPManager*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager=[[SFXMPPManager alloc]init];
        //[DDLog addLogger:[DDTTYLogger sharedInstance]];
        
//        [[NSUserDefaults standardUserDefaults]setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID] forKey:kXMPPmyJID];
//        [[NSUserDefaults standardUserDefaults]setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_PASSWORD] forKey:kXMPPmyPassword];
        //[[NSUserDefaults standardUserDefaults]synchronize];
        
        [sharedManager setUpStream];
        
    });
    
    // Setup the XMPP stream
    
    
    
    return sharedManager;
}
-(void)dealloc
{
    [self teardownStream];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma  mark ------收发消息-------
- (void)sendMessage:(XMPPMessage *)aMessage
{
    [xmppStream sendElement:aMessage];
    NSString *body = [[aMessage elementForName:@"body"] stringValue];
    // NSString *meesageStyle=[[aMessage attributeForName:@"type"] stringValue];
    NSString *meesageTo = [[aMessage to]bare];
    NSArray *strs=[meesageTo componentsSeparatedByString:@"@"];
    
    //创建message对象
    MessageModel *msg=[[MessageModel alloc]init];
    [msg setMessageDate:[NSDate date]];
    [msg setMessageFrom:[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]];
    
    [msg setMessageTo:strs[0]];
    
    if (strs !=nil) {
        if ((![UserObject haveSaveUserById:strs[0]])&&(![ShopObject haveSaveShopXmpp:strs[0]])) {
            [self fetchInfo:strs[0]];
        }
    }
    //判断多媒体消息
    
    NSDictionary *messageDic=[body JSONValue];
    NSLog(@"发送消息中:%@",[messageDic objectForKey:@"text"]);
    
    [msg setMessageType:[messageDic objectForKey:@"messageType"]];
    
    if (msg.messageType.intValue==bSFMessageTypePlain) {
        [msg setMessageContent:[messageDic objectForKey:@"text"]];
    }else
        [msg setMessageContent:[messageDic objectForKey:@"file"]];
    
    
    //[msg setMessageContent:body];
    [MessageModel save:msg];
    //发送全局通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifaction object:msg ];
    //    [msg release];
}

#pragma mark --------配置XML流---------
-(void)setUpStream
{
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    xmppStream=[[XMPPStream alloc] init];
#if !TARGET_IPHONE_SIMULATOR
	{
        xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
    xmppReconnect=[[XMPPReconnect alloc] init];
    [xmppReconnect activate:xmppStream];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppStream setHostName:kXMPPHost];
    [xmppStream setHostPort:5222];
    allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
    if (![self connect]) {
//        [[[UIAlertView alloc]initWithTitle:@"服务器连接失败" message:@"~" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil]show];
    };
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	
	[xmppReconnect         deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
}

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[xmppStream sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[xmppStream sendElement:presence];
}
#pragma mark Connect/disconnect
- (BOOL)connect
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}
    
	NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    NSString*myJID=[NSString stringWithFormat:@"%@@shopfriend/IOS",userID];
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	//[xmppStream setMyJID:[XMPPJID jidWithUser:myJID domain:@"shopfriend" resource:@"IOS"]];
	password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		//DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIApplicationDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//	// Use this method to release shared resources, save user data, invalidate timers, and store
//	// enough application state information to restore your application to its current state in case
//	// it is terminated later.
//	//
//	// If your application supports background execution,
//	// called instead of applicationWillTerminate: when the user quits.
//	
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//    
//#if TARGET_IPHONE_SIMULATOR
//	DDLogError(@"The iPhone simulator does not process background network traffic. "
//			   @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
//#endif
//    
//	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
//	{
//		[application setKeepAliveTimeout:600 handler:^{
//			
//			DDLogVerbose(@"KeepAliveHandler");
//			
//			// Do other keep alive stuff here.
//		}];
//	}
//}

//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);    
//}
//- (NSManagedObjectContext *)managedObjectContext_roster
//{
//	//return [xmppRosterStorage mainThreadManagedObjectContext];
//}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![xmppStream authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
    //[xmppRoster fetchRoster];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [iq elementID]);
	
    NSLog(@"收到iq:%@",iq);
    
    
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSString *body = [[message elementForName:@"body"] stringValue];
    NSString *displayName = [[message from]bare];
    if ([body isEqualToString:@"{}"]) {
        return;
    }
    if (body==nil) {
        return;
    }
    //!!
//    [[[UIAlertView alloc]initWithTitle:@"收到新消息" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    
    
    //创建message对象
    MessageModel *msg=[MessageModel messageWithType:bSFMessageTypePlain];
    NSArray *strs=[displayName componentsSeparatedByString:@"@"];
    [msg setMessageDate:[NSDate date]];
    [msg setMessageFrom:strs[0]];
    [msg setMessageContent:body];
    [msg setMessageTo:[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]];
    [msg setMessageType:[NSNumber numberWithInt:bSFMessageTypePlain]];
    
    
     if (strs !=nil) {
         if ((![UserObject haveSaveUserById:strs[0]])&&(![ShopObject haveSaveShopXmpp:strs[0]])) {
            [self fetchInfo:strs[0]];
        }
     }
    
    
    NSDictionary *messageDic=[body JSONValue];
    if ([[messageDic objectForKey:@"messageType"] integerValue]==4) {
        [[InfoManager sharedInfo] getCoupon];
    }
    [msg setMessageType:[messageDic objectForKey:@"messageType"]];
    switch (msg.messageType.intValue) {
        case bSFMessageTypePlain:
            [msg setMessageContent:[messageDic objectForKey:@"text"]];
            break;
        case bSFMessageTypeImage:
            [msg setMessageContent:[messageDic objectForKey:@"file"]];
        case bSFMessageTypeCoupon:
            [msg setMessageContent:[messageDic objectForKey:@"text"]];
        default:
            break;
    }
    
    
    [MessageModel save:msg];
    
    
    
    
    
    if([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
    {
        // We are not active, so use a local notification instead
//        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//        localNotification.alertAction = @"Ok";
//        localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",@"微信消息:",@"123"];
//        
//        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
	
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}
//
-(void)fetchInfo:(NSString*)userId
{
//    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"加载中" message:@"刷新好友列表中，请稍候" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
//    [av show];
    
    //此API使用方式请查看www.hcios.com:8080/user/findUser.html
    NSString*string=[userId substringFromIndex:userId.length-4];
    NSURL*url=[NSURL URLWithString:GetTalkInfo];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
    if ([string isEqualToString:@"shop"]) {
        [request setPostValue:[userId substringToIndex:userId.length-4] forKey:@"postID"];
        [request setPostValue:@"shop" forKey:@"kind"];
        [request setCompletionBlock:^{
            SBJsonParser*parser=[[SBJsonParser alloc] init];
            NSDictionary*dic=[parser objectWithString:request.responseString];
            if ([[dic objectForKey:@"back"] integerValue]==1) {
                NSDictionary*shopDic=[[dic objectForKey:@"data"] objectAtIndex:0];
                ShopObject*newShop=[[ShopObject alloc] init];
                [newShop setShopID:[shopDic objectForKey:@"shop_ID"]];
                [newShop setShopName:[shopDic objectForKey:@"shop_name"]];
                [ShopObject saveNewShop:newShop];
                
            }
        }];
        [request setFailedBlock:^{
            
        }];
        [request startAsynchronous];
    }else
    {
        [request setPostValue:userId forKey:@"postID"];
        [request setPostValue:@"user" forKey:@"kind"];
        [request setCompletionBlock:^{
            SBJsonParser*parser=[[SBJsonParser alloc] init];
            NSDictionary*dic=[parser objectWithString:request.responseString];
            if ([[dic objectForKey:@"back"] integerValue]==1) {
                NSDictionary*userDic=[[dic objectForKey:@"data"] objectAtIndex:0];
                UserObject*newUser=[[UserObject alloc] init];
                [newUser setUserId:[userDic objectForKey:@"user_ID"]];
                [newUser setUserNickname:[userDic objectForKey:@"user_name"]];
                [UserObject saveNewUser:newUser];
            }
        }];
        [request setFailedBlock:^{
            
        }];
        [request startAsynchronous];
    }
}

@end
