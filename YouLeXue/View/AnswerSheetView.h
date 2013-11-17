//
//  AnswerSheetView.h
//  YouLeXue
//
//  Created by vedon on 17/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^AnswerSheetBlock) (NSInteger index);
@interface AnswerSheetView : UIView
@property (assign ,nonatomic) NSInteger answerCount;
@property (strong ,nonatomic) NSArray * alreadyAnswerTitle;
@property (strong ,nonatomic) NSArray * titleDataSourece;
@property (strong ,nonatomic) AnswerSheetBlock block;
@property (strong ,nonatomic) NSMutableArray * canDrawBackgroundItem;
@end
