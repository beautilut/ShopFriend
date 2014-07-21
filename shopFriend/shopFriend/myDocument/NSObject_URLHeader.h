//
//  NSObject_URLHeader.h
//  shopFriend
//
//  Created by Beautilut on 14-1-27.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//
#define ORIGINAL_MAX_WIDTH 640.0f

#define kXMPPmyJID @"kXMPPmyJID"
#define kXMPPmyPassword @"kXMPPmyPassword"
#define userImageKey [NSString stringWithFormat:@"userHeaderImage%@",[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]]

#define webInvitationGet @"http://www.beautilut.com/shopFriend/other/getInvitation.php"//1
#define GetTalkInfo @"http://www.beautilut.com/shopFriend/XMPPMethod/InfoGet.php"//1
#define userEnter @"http://www.beautilut.com/shopFriend/userMethod/userEnter.php"//1
#define userRegister @"http://www.beautilut.com/shopFriend/userMethod/userRegister.php"//1
#define userImageChange @"http://www.beautilut.com/shopFriend/userMethod/userImageChange.php"//1
#define userInfoChange @"http://www.beautilut.com/shopFriend/userMethod/userInfoChange.php"//1
#define GetShopList @"http://www.beautilut.com/shopFriend/shopMethod/shopListShow.php"//1
#define GetShopInfo @"http://www.beautilut.com/shopFriend/shopMethod/shopInfo.php"//1
#define GetShopActivity @"http://www.beautilut.com/shopFriend/shopMethod/getShopActivity.php"//1
#define GetShopWindowImage @"http://www.beautilut.com/shopFriend/shopMethod/shopWindowImage.php"//1
#define GetUserInfo @"http://www.beautilut.com/shopFriend/userMethod/userInfo.php"//1
#define TalkImage @"http://www.beautilut.com/shopFriend/XMPPMethod/TalkImage.php"//1
#define SHOP_LOGO_URL(_SHOP_) [NSString stringWithFormat:@"http://www.beautilut.com/shopFriendDatabase/shopDatabase/%@/shopLogo.jpg",_SHOP_]//1
#define menuGetURL @"http://www.beautilut.com/shopFriend/menuMethods/menuGet.php"//1

#define SHOP_MENU_PICK(_PICK_) [NSString stringWithFormat:@"http://www.beautilut.com/shopFriendDatabase/shopDatabase/%@",_PICK_]//1

#define GET_USER_HEADIMAGE(_USER_) [NSString stringWithFormat:@"http://www.beautilut.com/shopFriendDatabase/userDatabase/%@/userImage.jpg",_USER_]//1

#define GET_CHAT_IMAGE(_PHOTO_) [NSString stringWithFormat:@"http://www.beautilut.com/res/%@",_PHOTO_]//1
//
#define addNewShopAttention @"http://www.beautilut.com/shopFriend/relationMethods/addFriend.php"//1
#define shopFlagUpdate @"http://www.beautilut.com/shopFriend/relationMethods/updateFlag.php"//1
#define invitation @"http://www.beautilut.com/shopFriend/other/invitation.php" //1
#define shopFriendFeedBack @"http://www.beautilut.com/shopFriend/other/feedBack.php"//ok
#define getShopFriendList @"http://www.beautilut.com/shopFriend/relationMethods/getShopFriendList.php"//1
//report
#define reportURL @"http://www.beautilut.com/shopFriend/other/report.php"//1
//coupon
//#define couponReportURL @"http://www.beautilut.com/shopFriend/other/couponReport.php"//check
#define getCouponURL @"http://www.beautilut.com/shopFriend/couponMethods/getCoupon.php"//1
#define GetCouponShopList @"http://www.beautilut.com/shopFriend/couponMethods/getCouponShopList.php"//1