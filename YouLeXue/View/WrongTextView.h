//
//  WrongTextView.h
//  YouLeXue
//
//  Created by vedon on 18/11/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WrongTextView : UIView
@property (strong ,nonatomic)  UIWebView * textWebView ;
- (id)initWithFrame:(CGRect)frame withStrL:(NSString*)descriptionStr;
@end
