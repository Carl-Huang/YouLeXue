//
//  AnswerSheetView.h
//  YouLeXue
//
//  Created by vedon on 17/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerSheetView : UIView
@property (assign ,nonatomic) NSInteger answerCount;
@property (strong ,nonatomic) NSArray * alreadyAnswerTitle;
@property (strong ,nonatomic) NSArray * titleDataSourece;

@end
