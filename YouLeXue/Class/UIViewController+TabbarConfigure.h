//
//  UIViewController+TabbarConfigure.h
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TabbarConfigure)
- (void) setBackItem:(SEL)action withImage:(NSString *)imageName;
- (void) setForwardItem:(SEL)action withImage:(NSString *)imageName;
@end
