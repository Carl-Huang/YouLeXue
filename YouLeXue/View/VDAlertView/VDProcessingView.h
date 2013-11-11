//
//  VDProcessingView.h
//  CustomiseAlertViewForIos7
//
//  Created by vedon on 21/10/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDProcessingView : UIView
@property (nonatomic, retain) UIProgressView* progressView;
@property (nonatomic, retain) UILabel* progressLabel;
- (void)stepProgress:(float)progress;
- (void)setProgress:(float)progress;
- (float)getProgress;
@end
