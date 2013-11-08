//
//  AppDelegate.m
//  YouLeXue
//
//  Created by Carl on 13-11-5.
//  Copyright (c) 2013年 Carl. All rights reserved.
//

#import "AppDelegate.h"

#import "YDMenuItem.h"
#import "ViewController.h"
#import "AKTabBarController.h"
#import "MainViewController.h"
#import "TestUserGroupViewController.h"
#import "CaseAnalysisViewController.h"
#import "WrongBookViewController.h"
#import "SettingViewController.h"


@implementation AppDelegate
@synthesize akTabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self customUI];
    // Override point for customization after application launch.
    akTabBarController = [[AKTabBarController alloc] initWithTabBarHeight:49.0];
    MainViewController * firstViewController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
//    UINavigationController * nav_a = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    
    TestUserGroupViewController *secondViewController = [[TestUserGroupViewController alloc]initWithNibName:@"TestUserGroupViewController" bundle:nil];
//     UINavigationController * nav_b = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    
    CaseAnalysisViewController * thirdViewController = [[CaseAnalysisViewController alloc]initWithNibName:@"CaseAnalysisViewController" bundle:nil];
//     UINavigationController * nav_c = [[UINavigationController alloc] initWithRootViewController:thirdViewController];
    
    WrongBookViewController * fourthViewController = [[WrongBookViewController alloc]initWithNibName:@"WrongBookViewController" bundle:nil];
//     UINavigationController * nav_d = [[UINavigationController alloc] initWithRootViewController:fourthViewController];
    
    SettingViewController * fifthViewController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
//    UINavigationController * nav_e = [[UINavigationController alloc] initWithRootViewController:fifthViewController];
    
//    akTabBarController.viewControllers = [NSMutableArray arrayWithObjects:nav_a,nav_b,nav_c,nav_d,nav_e,nil];
    akTabBarController.viewControllers = [NSMutableArray arrayWithObjects:firstViewController,secondViewController,thirdViewController,fourthViewController,fifthViewController,nil];
    [akTabBarController setBackgroundImageName:@"Bottom_Bar01"];
    [akTabBarController setSelectedTabColors:@[[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]]];
    [akTabBarController setTabColors:@[[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]]];
    [akTabBarController setTabEdgeColor:[UIColor clearColor]];
    [akTabBarController  setTabIconPreRendered:NO];
    [akTabBarController setTabInnerStrokeColor:[UIColor clearColor]];
    [akTabBarController setIconColors:@[[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]]];
    [akTabBarController setIconGlossyIsHidden:YES];
    
//    [akTabBarController setIconShadowColor:[UIColor clearColor]];
    [akTabBarController setTabInnerStrokeColor:[UIColor clearColor]];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:akTabBarController];

    self.leftMenuViewController = [[YDLeftMenuViewController alloc] init];

    
    self.rightMenuViewController = [[YDRightMenuViewController alloc] init];


    self.containerViewController = [YDSlideMenuContainerViewController
                      containerWithCenterViewController:[self navigationController]
                      leftMenuViewController:self.leftMenuViewController
                      rightMenuViewController:self.rightMenuViewController];
    self.window.rootViewController = self.containerViewController;
    self.containerViewController.delegate=self;
    [self.window makeKeyAndVisible];
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)toggleLeftMenu
{
    if (self.containerViewController.menuState == YDSLideMenuStateLeftMenuOpen)
    {
        [self.containerViewController setMenuState:YDSLideMenuStateClosed];
    }
    else
    {
        [self.containerViewController setMenuState:YDSLideMenuStateLeftMenuOpen];
    }
    
}
-(void)toggleRightMenu
{
    if (self.containerViewController.menuState == YDSLideMenuStateRightMenuOpen)
    {
        [self.containerViewController setMenuState:YDSLideMenuStateClosed];
    }
    else
    {
        [self.containerViewController setMenuState:YDSLideMenuStateRightMenuOpen];
    }
}
-(void)menuWillHide
{
    //called by the YDSlideMenuContainerViewController if the menu goes off screen
    //you can perform additional actions
}

- (void)customUI
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Top_Bar"] forBarMetrics:UIBarMetricsDefault];
}

@end
