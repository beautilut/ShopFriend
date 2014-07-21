//
//  ShopCell.h
//  shopFriend
//
//  Created by Beautilut on 14-1-5.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCell : UITableViewCell
{
    IBOutlet UIImageView*shopImage;//商铺图标
    IBOutlet UILabel*shopName;//商铺名称
    IBOutlet UILabel*shopIndustry;//商铺行业
    IBOutlet UILabel*shopDistance;//商铺距离
    //拓展
    UILabel*expand;//商铺等级拓展
    UILabel*expand1;//商铺人均拓展
}
@property(nonatomic,retain) IBOutlet  UIImageView*shopImage;
@property(nonatomic,retain) IBOutlet  UILabel*shopName;
@property(nonatomic,retain) IBOutlet  UILabel*shopIndustry;
@property(nonatomic,retain) IBOutlet  UILabel*shopDistance;
-(void)setCellInfo:(NSDictionary*)dic;
-(void)setCellShopImage:(UIImage*)image;
@end
