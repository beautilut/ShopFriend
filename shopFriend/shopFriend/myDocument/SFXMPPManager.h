//
//  SFXMPPManager.h
//  shopFriend
//
//  Created by Beautilut on 14-2-25.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "XMPPFramework.h"
#import "NSObject_URLHeader.h"
@class XMPPMessage,XMPPRoster,XMPPRosterCoreDataStorage;
@interface SFXMPPManager : NSObject <UIApplicationDelegate>
{
    XMPPStream*xmppStream;
    XMPPReconnect*xmppReconnect;
    NSString*password;
    BOOL isOpen;
    
    BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
    BOOL isXmppConnected;
}
@property(nonatomic,readonly) XMPPStream*xmppStream;
-(BOOL)connect;
-(void)disconnect;


+(SFXMPPManager*)sharedInstance;

#pragma mark - 配置XML流 -
-(void)setUpStream;
-(void)teardownStream;

#pragma mark - 收发信息 -
- (void)goOnline;
- (void)goOffline;

- (void)sendMessage:(XMPPMessage *)aMessage;
//- (void)addSomeBody:(NSString *)userId;

#pragma mark ---------文件传输-----------
//-(void)sendFile:(NSData*)aData toJID:(XMPPJID*)aJID;
@end
