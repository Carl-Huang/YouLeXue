//
//  CaseView.m
//  YouLeXue
//
//  Created by vedon on 23/11/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import "CaseView.h"

@implementation CaseView
@synthesize contentView;

- (id)initWithFrame:(CGRect)frame withDescriptionStr:(NSString *)str time:(NSString * )time
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = frame;
        rect.origin.y =30;
        rect.size.height = frame.size.height - 30;
        rect.origin.x = 0;
        
        CGRect labelRect = frame;
        labelRect.size.height = 30;
        labelRect.origin.y=-30;
        labelRect.origin.x= 0;
        UILabel * textLabel = [[UILabel alloc]initWithFrame:labelRect];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        textLabel.font = [UIFont systemFontOfSize:18];
        textLabel.text = [NSString stringWithFormat:@"  时间：%@",time];
        textLabel.textColor = [UIColor colorWithRed:66.0/255.0 green:183.0/255.0 blue:201.0/255.0 alpha:1.0];
        

        contentView = [[UIWebView alloc]initWithFrame:rect];
        [contentView loadHTMLString:str baseURL:nil];
        [self addSubview:contentView];
        [contentView addSubview:textLabel];
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
