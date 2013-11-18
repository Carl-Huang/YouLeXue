//
//  WrongPaperViewController.h
//  YouLeXue
//
//  Created by vedon on 13/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExamInfo;
@interface WrongPaperViewController : UIViewController
@property (strong ,nonatomic) NSArray * questionDataSource;
@property (strong ,nonatomic) ExamInfo * examInfo;

@property (strong ,nonatomic) NSString * titleStr;
@property (weak, nonatomic) IBOutlet UIButton *preQueBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextQuesBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *quesScrollView;
@property (assign, nonatomic) NSInteger didSelectedindex;
- (IBAction)preQuestionAction:(id)sender;
- (IBAction)nextQuestionAction:(id)sender;



@end
