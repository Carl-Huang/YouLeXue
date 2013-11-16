//
//  WrongTextBookView.h
//  YouLeXue
//
//  Created by vedon on 16/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WrongTextBookView : UIView
@property (strong , nonatomic)UIWebView * webView;
- (id)initWithFrame:(CGRect)frame WithHtml:(NSString *)html;
@end
