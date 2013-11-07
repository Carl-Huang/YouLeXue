//  YDBaseViewController.m
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "YDBaseViewController.h"
#import "AppDelegate.h"
@interface YDBaseViewController ()

@end

@implementation YDBaseViewController

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //左边
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [leftBtn addTarget:self action:@selector(toggleLeftMenu:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"Unfold_Left_Button"] forState:UIControlStateNormal];

    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    
    //右边
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn addTarget:self action:@selector(toggleRightMenu:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"Unfold_Right_Button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
}

-(void)toggleLeftMenu:(id)sender
{
 
    [[self appDelegate] toggleLeftMenu];
}
-(void)toggleRightMenu:(id)sender
{
    [[self appDelegate] toggleRightMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
