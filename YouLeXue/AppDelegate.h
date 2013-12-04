//
//  AppDelegate.h
//  YouLeXue
//
//  Created by vedon on 13-11-5.
//  Copyright (c) 2013年 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDRightMenuViewController.h"
#import "YDLeftMenuViewController.h"
#import "YDSlideMenuContainerViewController.h"
#import "UserLoginInfo.h"
@class AKTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,YDSlideMenuContainerViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AKTabBarController * akTabBarController;
@property (strong, nonatomic) UINavigationController * navigationController;
@property (strong, nonatomic) YDSlideMenuContainerViewController *containerViewController;
@property(strong,nonatomic)YDLeftMenuViewController* leftMenuViewController;
@property(strong,nonatomic)YDRightMenuViewController* rightMenuViewController;
@property (strong ,nonatomic) UserLoginInfo * userInfo;
@property (strong ,nonatomic) NSString * Server_URL;
-(void)toggleLeftMenu;
-(void)toggleRightMenu;

+(NSString *)getServerURL;
+(NSString *)getServerAddress;
@end
