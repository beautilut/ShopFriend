//
//  InfoManager.m
//  shopFriend
//
//  Created by Beautilut on 14-3-13.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "InfoManager.h"
static InfoManager* sharedManager;
@implementation InfoManager
@synthesize host;
+(InfoManager*)sharedInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager=[[InfoManager alloc] init];
        sharedManager.host=[[HostModel alloc] init];
    });
    return sharedManager;
}
-(void)getUserInfo
{
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    BOOL worked = [HostModel haveSaveHostByID:hostID];
    if (worked) {
        host=[HostModel fetchHostInfo];
    }else
    {
        ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:GetUserInfo]];
        [request setPostValue:hostID forKey:@"userID"];
        [request setCompletionBlock:^{
            SBJsonParser*paser=[[SBJsonParser alloc] init];
            NSDictionary*rootDic=[paser objectWithString:request.responseString];
            NSDictionary*webDic=[[rootDic objectForKey:@"data"] objectAtIndex:0];
            host=[self webDicIntoDiskDic:webDic];
            [HostModel saveNewHost:host];
            [self getUserShopFriendInfo];
        }];
        [request setFailedBlock:^{
            
        }];
        [request startAsynchronous];
    }
}
-(void)getUserShopFriendInfo
{
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:getShopFriendList]];
    [request setPostValue:hostID forKey:@"userID"];
    [request setCompletionBlock:^{
        SBJsonParser*paser=[[SBJsonParser alloc] init];
        NSDictionary*rootDic=[paser objectWithString:request.responseString];
        NSArray*shopArray=[rootDic objectForKey:@"shop"];
        for (int i=0; i<[shopArray count]; i++) {
            NSDictionary*dic=[shopArray objectAtIndex:i];
            ShopObject*newShop=[[ShopObject alloc] init];
            [newShop setShopID:[dic objectForKey:@"shop_ID"]];
            [newShop setShopName:[dic objectForKey:@"shop_name"]];
            [ShopObject saveNewShop:newShop];
            [ShopObject updateShopFlag:newShop.shopID withFlag:[NSNumber numberWithInt:1]];
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}
-(void)updateInfo
{
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:GetUserInfo]];
    [request setPostValue:hostID forKey:@"userID"];
    [request setCompletionBlock:^{
        SBJsonParser*paser=[[SBJsonParser alloc] init];
        NSDictionary*rootDic=[paser objectWithString:request.responseString];
        NSArray*couponList=[rootDic objectForKey:@"data"];
        for (int i=0; i<[couponList count]; i++) {
            NSDictionary*dic=[couponList objectAtIndex:i];
            CouponObject*aCoupon=[CouponObject CouponFromDictionary:dic];
            [CouponObject couponExist:aCoupon];
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}
-(void)getCoupon
{
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:getCouponURL]];
    [request setPostValue:hostID forKey:@"userID"];
    [request setCompletionBlock:^{
        SBJsonParser*paser=[[SBJsonParser alloc] init];
        NSDictionary*rootDic=[paser objectWithString:request.responseString];
        NSArray*couponList=[rootDic objectForKey:@"coupon"];
        for (NSDictionary*dic  in couponList) {
            CouponObject*coupon=[self webDicIntoCouponObject:dic];
            if ([CouponObject couponExist:coupon]) {
                [CouponObject saveNewCoupon:coupon];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CouponGet" object:nil];
    }];
    [request setFailedBlock:^{
        
    }]; 
    [request startAsynchronous];
}
-(CouponObject*)webDicIntoCouponObject:(NSDictionary*)dic
{
    CouponObject*aCoupon=[[CouponObject alloc] init];
    NSDictionary*model=[dic objectForKey:@"CouponModel"];
    [aCoupon setCouponID:[dic objectForKey:@"Coupon_ID"]];
    [aCoupon setCouponName:[model objectForKey:@"CouponModel_Name"]];
    [aCoupon setCouponInfo:[model objectForKey:@"CouponModel_Info"]];
    if ([model objectForKey:@"CouponModel_BeginTime"]!=[NSNull null]) {
        [aCoupon setCouponBeginTime:[model objectForKey:@"CouponModel_BeginTime"]];
    }
    [aCoupon setCouponEndTime:[model objectForKey:@"CouponModel_EndTime"]];
    [aCoupon setCouponUseInfo:[model objectForKey:@"CouponModel_useInfo"]];
    [aCoupon setCouponUsed:[NSNumber numberWithInt:[[dic objectForKey:@"Coupon_used"] integerValue]]];
    [aCoupon setCouponImageURL:[model objectForKey:@"CouponModel_Image"]];
    [aCoupon setCouponPassword:[dic objectForKey:@"Coupon_Password"]];
    return aCoupon;
}
-(HostModel*)webDicIntoDiskDic:(NSDictionary*)dic
{
    HostModel*newhost=[[HostModel alloc] init];
    [newhost setHostID:[dic objectForKey:@"user_ID"]];
    [newhost setHostName:[dic objectForKey:@"user_name"]];
    [newhost setHostPhone:[dic objectForKey:@"user_phone"]];
    [newhost setHostMail:[dic objectForKey:@"user_email"]];
    [newhost setHostSex:[dic objectForKey:@"user_sex"]];
    [newhost setHostBirthday:[dic objectForKey:@"user_birthday"]];
    return newhost;
}
#pragma mark userImage
-(void)saveUserImage:(UIImage *)image
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    /*写入图片*/
    //帮文件起个名
    NSString*hostID=[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    NSString*name=[NSString stringWithFormat:@"userImage%@.png",hostID];
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:name];
    //将图片写到Documents文件中
    [UIImagePNGRepresentation(image)writeToFile: uniquePath    atomically:YES];
    
}
-(UIImage*)getUserImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    /*写入图片*/
    //帮文件起个名
    NSString*hostID=[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    NSString*name=[NSString stringWithFormat:@"userImage%@.png",hostID];
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:name];
    NSData *data=[NSData dataWithContentsOfFile:uniquePath];
    //直接把该图片读出来
    UIImage*image=[UIImage imageWithData:data];
    return image;
}
#pragma mark checkPhone
-(BOOL)checkPhone:(NSString *)string
{
    if ([string length]==0) {
        return NO;
    }
    NSString*regex=@"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate*pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch=[pred evaluateWithObject:string];
    return isMatch;
}
@end
