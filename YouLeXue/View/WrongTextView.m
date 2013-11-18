//
//  WrongTextView.m
//  YouLeXue
//
//  Created by vedon on 18/11/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import "WrongTextView.h"

@implementation WrongTextView
@synthesize textWebView;

- (id)initWithFrame:(CGRect)frame withStrL:(NSString*)descriptionStr
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        self.textWebView = [[UIWebView alloc]initWithFrame:rect];
        [self.textWebView loadHTMLString:descriptionStr baseURL:nil];
        [self addSubview:self.textWebView];
        self.textWebView = nil;
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
