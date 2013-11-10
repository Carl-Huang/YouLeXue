//
//  AppDelegate.h
//  YouLeXue
//
//  Created by Carl on 13-11-5.
//  Copyright (c) 2013年 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDRightMenuViewController.h"
#import "YDLeftMenuViewController.h"
#import "YDSlideMenuContainerViewController.h"
@class UserLoginInfo;
@class AKTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,YDSlideMenuContainerViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AKTabBarController * akTabBarController;
@property (strong, nonatomic) UINavigationController * navigationController;
@property (strong, nonatomic) YDSlideMenuContainerViewController *containerViewController;
@property(strong,nonatomic)YDLeftMenuViewController* leftMenuViewController;
@property(strong,nonatomic)YDRightMenuViewController* rightMenuViewController;
@property (strong ,nonatomic) UserLoginInfo * userInfo;

-(void)toggleLeftMenu;
-(void)toggleRightMenu;
@end
