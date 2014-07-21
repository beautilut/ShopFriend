//
//  AppDelegate.m
//  shopFriend
//
//  Created by Beautilut on 14-1-5.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//
// Log levels: off, error, warn, info, verbose

#import "AppDelegate.h"
#import "NSObject_URLHeader.h"
#import "UserEnterViewController.h"
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSLog(@"Initiating remoteNoticationssAreActive");
    if(!application.enabledRemoteNotificationTypes){
        NSLog(@"Initiating remoteNoticationssAreActive1");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    }
    UIApplication* myapp = [UIApplication sharedApplication];
    myapp.idleTimerDisabled = YES;

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (![[SFXMPPManager sharedInstance] connect]) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //UserEnterViewController*userEnterView=[mainStoryboard instantiateViewControllerWithIdentifier:@"userEnter"];
            UINavigationController*navi=[mainStoryboard instantiateViewControllerWithIdentifier:@"userEnter"];
            [self.window.rootViewController  presentViewController:navi animated:NO completion:Nil];
            //[self.window.rootViewController pushViewController:userEnterView animated:YES];
		});

    }else{
        [[InfoManager sharedInfo] getUserInfo];
    }
    locationManager=[[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=5.0f;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocation:) name:@"startLocation" object:nil];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (![[SFXMPPManager sharedInstance] connect]) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //UserEnterViewController*userEnterView=[mainStoryboard instantiateViewControllerWithIdentifier:@"userEnter"];
            UINavigationController*navi=[mainStoryboard instantiateViewControllerWithIdentifier:@"userEnter"];
            [self.window.rootViewController  presentViewController:navi animated:NO completion:Nil];
            //[self.window.rootViewController pushViewController:userEnterView animated:YES];
		});
        
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//通知
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *str = [NSString
                     stringWithFormat:@"Device Token=%@",deviceToken];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", error];
}
#pragma mark -location manager-
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getLocation" object:locations];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"err");
}
-(void)startLocation:(id)sender
{
    [locationManager startUpdatingLocation];
}
@end
