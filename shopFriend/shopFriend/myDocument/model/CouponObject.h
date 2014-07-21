//
//  CouponObject.h
//  shopFriend
//
//  Created by Beautilut on 14-4-29.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#define sfCouponID @"Coupon_ID"
#define sfCouponName @"CouponModel_Name"
#define sfCouponInfo @"CouponModel_Info"
#define sfCouponBeginTime @"CouponModel_BeginTime"
#define sfCouponEndTime @"CouponModel_EndTime"
#define sfCouponUseInfo @"CouponModel_useInfo"
#define sfCouponUsed @"Coupon_used"
#define sfUserID @"user_ID"
#define sfCouponPassword @"Coupon_Password"
#define sfCouponImageURL @"CouponModel_Image"
@interface CouponObject : NSObject
@property(nonatomic,retain) NSString*couponID;
@property(nonatomic,retain) NSString*couponName;
@property(nonatomic,retain) NSString*couponInfo;
@property(nonatomic,retain) NSString*couponBeginTime;
@property(nonatomic,retain) NSString*couponEndTime;
@property(nonatomic,retain) NSString*couponUseInfo;
@property(nonatomic,retain) NSNumber*couponUsed;
@property(nonatomic,retain) NSString*couponImageURL;
@property(nonatomic,retain) NSString*couponPassword;
//
+(BOOL)saveNewCoupon:(CouponObject*)aCoupon;
+(BOOL)useCoupon:(NSString*)couponID;
//获取全部优惠券
+(NSMutableArray*)fetchAllCouponsWithUser;
//获取可用优惠券
+(NSMutableArray*)fetchUseAbleCouponsWithUser;
//
-(void)CouponSetImage:(NSString*)url withDB:(FMDatabase*)db withCouponID:(NSString*)couponID;
-(NSDictionary*)toDictionary;
+(CouponObject*)CouponFromDictionary:(NSDictionary*)aDic;
+(BOOL)couponExist:(CouponObject*)coupon;
+(void)couponUpdate:(CouponObject*)coupon;
@end
