//
//  UIViewController+TabbarConfigure.m
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "UIViewController+TabbarConfigure.h"

@implementation UIViewController (TabbarConfigure)
- (void) setBackItem:(SEL)action withImage:(NSString *)imageName
{
    UIImage * backImg = [UIImage imageNamed:imageName];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, backImg.size.width, backImg.size.height)];
    [backBtn setImage:backImg forState:UIControlStateNormal];
    if (action == nil)
    {
        [backBtn addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [backBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)pushBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
