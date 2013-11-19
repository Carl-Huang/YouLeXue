//
//  EndExamScoreViewController.h
//  YouLeXue
//
//  Created by vedon on 19/11/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndExamScoreViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UITableView *PaperInfoTable;
- (IBAction)viewPaperAnswer:(id)sender;
- (IBAction)ExamAgain:(id)sender;
- (IBAction)shareExam:(id)sender;

@end
