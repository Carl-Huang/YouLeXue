//
//  CaseView.h
//  YouLeXue
//
//  Created by vedon on 23/11/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseView : UIView

@property (strong ,nonatomic) UIWebView * contentView;
- (id)initWithFrame:(CGRect)frame withDescriptionStr:(NSString *)str time:(NSString * )time;
@end
