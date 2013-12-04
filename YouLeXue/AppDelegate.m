//
//  AppDelegate.m
//  YouLeXue
//
//  Created by vedon on 13-11-5.
//  Copyright (c) 2013年 vedon. All rights reserved.
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
#import "PersistentDataManager.h"
#import "VDAlertView.h"
#import <ShareSDK/ShareSDK.h>
#import "Constant.h"

@implementation AppDelegate
@synthesize akTabBarController;
@synthesize userInfo;
@synthesize Server_URL;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //服务器地址
    Server_URL = [AppDelegate getServerURL];
    
    
    //shareSDK
    [ShareSDK registerApp:@"d116da0a16e"];   
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"3201194191"
                               appSecret:@"0334252914651e8f76bad63337b3b78f"
                             redirectUri:@"http://appgo.cn"];
//
//    //添加腾讯微博应用
//    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
//                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
//                                redirectUri:@"http://www.sharesdk.cn"];
//    
//    //添加QQ空间应用
//    [ShareSDK connectQZoneWithAppKey:@"100371282"
//                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"];
//    
//    //添加网易微博应用
//    [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy"
//                              appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
//                            redirectUri:@"http://www.shareSDK.cn"];
//    
//    //添加搜狐微博应用
//    [ShareSDK connectSohuWeiboWithConsumerKey:@"SAfmTG1blxZY3HztESWx"
//                               consumerSecret:@"yfTZf)!rVwh*3dqQuVJVsUL37!F)!yS9S!Orcsij"
//                                  redirectUri:@"http://www.sharesdk.cn"];
//    
//    //添加豆瓣应用
//    [ShareSDK connectDoubanWithAppKey:@"07d08fbfc1210e931771af3f43632bb9"
//                            appSecret:@"e32896161e72be91"
//                          redirectUri:@"http://dev.kumoway.com/braininference/infos.php"];
//    
//    //添加人人网应用
//    [ShareSDK connectRenRenWithAppKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
//                            appSecret:@"f29df781abdd4f49beca5a2194676ca4"];
//    
//    //添加开心网应用
//    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
//                            appSecret:@"da32179d859c016169f66d90b6db2a23"
//                          redirectUri:@"http://www.sharesdk.cn/"];
//    
//    //添加Instapaper应用
//    [ShareSDK connectInstapaperWithAppKey:@"4rDJORmcOcSAZL1YpqGHRI605xUvrLbOhkJ07yO0wWrYrc61FA"
//                                appSecret:@"GNr1GespOQbrm8nvd7rlUsyRQsIo3boIbMguAl9gfpdL0aKZWe"];
//    
//    //添加有道云笔记应用
//    [ShareSDK connectYouDaoNoteWithConsumerKey:@"dcde25dca105bcc36884ed4534dab940"
//                                consumerSecret:@"d98217b4020e7f1874263795f44838fe"
//                                   redirectUri:@"http://www.sharesdk.cn/"];
//    
//    //添加Facebook应用
//    [ShareSDK connectFacebookWithAppKey:@"107704292745179"
//                              appSecret:@"38053202e1a5fe26c80c753071f0b573"];
//    
//    //添加Twitter应用
//    [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
//                             consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
//                                redirectUri:@"http://www.sharesdk.cn"];
//    
//    //添加搜狐随身看应用
//    [ShareSDK connectSohuKanWithAppKey:@"e16680a815134504b746c86e08a19db0"
//                             appSecret:@"b8eec53707c3976efc91614dd16ef81c"
//                           redirectUri:@"http://sharesdk.cn"];
//    
//    //添加Pocket应用
//    [ShareSDK connectPocketWithConsumerKey:@"11496-de7c8c5eb25b2c9fcdc2b627"
//                               redirectUri:@"pocketapp1234"];
//    
//    //添加印象笔记应用
//    [ShareSDK connectEvernoteWithType:SSEverNoteTypeSandbox
//                          consumerKey:@"sharesdk-7807"
//                       consumerSecret:@"d05bf86993836004"];
//    
//    //添加LinkedIn应用
//    [ShareSDK connectLinkedInWithApiKey:@"ejo5ibkye3vo"
//                              secretKey:@"cC7B2jpxITqPLZ5M"
//                            redirectUri:@"http://sharesdk.cn"];

    
    //读取数据库数据
    NSArray *array = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"UserLoginInfoTable" withObjClass:[UserLoginInfo class]];
    //因为用户始终有一个，所以只读取第零个元素
    if ([array count]) {
        self.userInfo = [array objectAtIndex:0];
    }else
    {
        self.userInfo  = nil;
    }
    
    
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self customUI];
    // Override point for customization after application launch.
    akTabBarController = [[AKTabBarController alloc] initWithTabBarHeight:49.0];
    MainViewController * firstViewController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    
    TestUserGroupViewController *secondViewController = [[TestUserGroupViewController alloc]initWithNibName:@"TestUserGroupViewController" bundle:nil];
    
    CaseAnalysisViewController * thirdViewController = [[CaseAnalysisViewController alloc]initWithNibName:@"CaseAnalysisViewController" bundle:nil];
    
    WrongBookViewController * fourthViewController = [[WrongBookViewController alloc]initWithNibName:@"WrongBookViewController" bundle:nil];

    SettingViewController * fifthViewController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    akTabBarController.viewControllers = [NSMutableArray arrayWithObjects:firstViewController,secondViewController,thirdViewController,fourthViewController,fifthViewController,nil];
    akTabBarController.tabWidth = 320.0/5;
    [akTabBarController setBackgroundImageName:@"Bottom_Bar01"];
    [akTabBarController setSelectedBackgroundImageName:@"Bottom_Bar"];
    [akTabBarController setSelectedTabColors:@[[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]]];
    [akTabBarController setTabColors:@[[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]]];
    [akTabBarController setSelectedIconColors:@[[UIColor colorWithRed:69/255.0 green:182/255.0 blue:204/255.0 alpha:1.0],[UIColor colorWithRed:69/255.0 green:182/255.0 blue:204/255.0 alpha:1.0],[UIColor colorWithRed:69/255.0 green:182/255.0 blue:204/255.0 alpha:1.0],[UIColor colorWithRed:69/255.0 green:182/255.0 blue:204/255.0 alpha:1.0],[UIColor colorWithRed:69/255.0 green:182/255.0 blue:204/255.0 alpha:1.0]]];
    [akTabBarController setTabEdgeColor:[UIColor clearColor]];
    [akTabBarController setTopEdgeColor:[UIColor clearColor]];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:akTabBarController];

    self.leftMenuViewController = [[YDLeftMenuViewController alloc] init];
    self.rightMenuViewController = [[YDRightMenuViewController alloc] init];

    self.containerViewController = [YDSlideMenuContainerViewController
                      containerWithCenterViewController:[self navigationController]
                      leftMenuViewController:self.leftMenuViewController
                      rightMenuViewController:self.rightMenuViewController];
    self.window.rootViewController = self.containerViewController;
    
        
    self.containerViewController.delegate=self;
    
    UIImageView * delayImage = nil;
    if (IS_SCREEN_4_INCH) {
        delayImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Default-568h"]];
        [delayImage setFrame:CGRectMake(0, 0, 320, 568)];
    }else
    {
        delayImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Default@2x"]];
        [delayImage setFrame:CGRectMake(0, 0, 320, 480)];
    }

    [UIView animateWithDuration:3 animations:^{
        [delayImage setAlpha:0.0];
        [delayImage removeFromSuperview];
    }];

    [self.window makeKeyAndVisible];
    [self.window addSubview:delayImage];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
     [[NSUserDefaults standardUserDefaults] setFloat:[UIScreen mainScreen].brightness forKey:@"APP_BRIGHTNESS"];
    NSLog(@"APP_BRIGHTNESS:%f",[UIScreen mainScreen].brightness);
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [UIScreen mainScreen].brightness = [[NSUserDefaults standardUserDefaults] floatForKey:@"APP_BRIGHTNESS"];
    NSLog(@"APP_BRIGHTNESS:%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"APP_BRIGHTNESS"]);
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

+(NSString *)getServerURL
{
    NSString * serverUrl = nil;
    serverUrl = [[NSUserDefaults standardUserDefaults]stringForKey:ServerURLKey];
    if ([serverUrl length]) {
        serverUrl = [NSString stringWithFormat:@"%@/jsonapi/",serverUrl];
    }else
    {
        return @"http://www.55280.com/jsonapi/";
    }
    
    return serverUrl;
}

+(NSString *)getServerAddress
{
    NSString * serverUrl = nil;
    serverUrl = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:ServerURLKey]];
    return serverUrl;
}
@end
