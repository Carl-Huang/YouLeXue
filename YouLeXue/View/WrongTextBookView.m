//
//  WrongTextBookView.m
//  YouLeXue
//
//  Created by vedon on 16/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import "WrongTextBookView.h"

@implementation WrongTextBookView
@synthesize webView;
- (id)initWithFrame:(CGRect)frame WithHtml:(NSString *)html
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSString * descriptionStr = nil;
        NSError * error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a href=\"[^\"]+\">([^<]+)</a>" options:NSRegularExpressionCaseInsensitive error:&error];
        descriptionStr = [regex stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"$1"];
        if (error) {
            NSLog(@"%@",[error description]);
        }
        [webView loadHTMLString:descriptionStr baseURL:nil];
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
