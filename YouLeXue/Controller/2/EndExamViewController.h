//
//  EndExamViewController.h
//  YouLeXue
//
//  Created by vedon on 16/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerSheetView.h"
@interface EndExamViewController : UIViewController
@property (strong ,nonatomic) NSString * timeStamp;
@property (strong ,nonatomic) NSArray * dataSourece;
@property (strong ,nonatomic) NSDictionary * answerDic;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneQuestionCount;
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (strong, nonatomic) AnswerSheetView *answerSheetView;
@end
