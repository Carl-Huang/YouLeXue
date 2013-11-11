//
//  VDProcessingView.m
//  CustomiseAlertViewForIos7
//
//  Created by vedon on 21/10/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//
#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#import "VDProcessingView.h"

@implementation VDProcessingView
@synthesize progressView;
@synthesize progressLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initProcessingView];
    }
    return self;
}


-(void)initProcessingView
{
    progressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar] autorelease];
    CGRect rect = progressView.frame;
    rect.origin.x = 55;
    rect.origin.y = 10;
    progressView.frame = rect;
    progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:progressView];
    progressLabel = [[[UILabel alloc] initWithFrame:CGRectMake(200, 0, 50, 30)] autorelease];
    progressLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    progressLabel.backgroundColor = [UIColor clearColor];//comment it to look label's position
    if ([self CurrentVersionIsIOS7]) {
        progressLabel.textColor = [UIColor blackColor];
    }else
    {
      progressLabel.textColor = [UIColor whiteColor];  
    }
    
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.adjustsFontSizeToFitWidth = YES;
    [progressLabel setHidden:YES];
    [self addSubview:progressLabel];
}


- (void)setProgress:(float)progress
{
    self.progressView.progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%2.0f%%", progress * 100];
}

- (float)getProgress
{
	return self.progressView.progress;
}

- (void)stepProgress:(float)progress
{
    self.progressView.progress += progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%2.0f%%", self.progressView.progress * 100];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(BOOL)CurrentVersionIsIOS7
{
    return NLSystemVersionGreaterOrEqualThan(7.0);
}
@end
