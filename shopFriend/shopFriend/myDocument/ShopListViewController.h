//
//  ShopListViewController.h
//  shopFriend
//
//  Created by Beautilut on 14-1-5.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopTabBar.h"
@interface ShopListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ShopTabBarDelegate>
{
    //ui
    UITableView*shopListTable;
}
@property(nonatomic,retain) UITableView*shopListTable;
-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;
@end
