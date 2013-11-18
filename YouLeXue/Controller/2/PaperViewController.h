//
//  PaperViewController.h
//  YouLeXue
//
//  Created by vedon on 13/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExamInfo;
@interface PaperViewController : UIViewController
@property (strong ,nonatomic) NSArray * questionDataSource;
@property (strong ,nonatomic) ExamInfo * examInfo;
@property (strong ,nonatomic) NSString * titleStr;
@property (assign ,nonatomic) BOOL isExciseOrnot;


@property (weak, nonatomic) IBOutlet UIButton *preQueBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextQuesBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *quesScrollView;
@property (weak, nonatomic) IBOutlet UIButton *wrongTextBookBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *popUpTable;
- (IBAction)preQuestionAction:(id)sender;
- (IBAction)nextQuestionAction:(id)sender;
- (IBAction)wrongTextBookAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *exciseBtn;
@property (weak, nonatomic) IBOutlet UIButton *showAnswerBtn;

- (IBAction)showAnswerAction:(id)sender;

@end
