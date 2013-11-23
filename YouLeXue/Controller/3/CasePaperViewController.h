//
//  CasePaperViewController.h
//  YouLeXue
//
//  Created by vedon on 23/11/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//
typedef NS_ENUM(NSInteger, PanDirection)
{
    PanDirectionNone = 0,
    PanDirectionLeft = 1,
    PanDirectionRight = 2,
};
#import <UIKit/UIKit.h>

@interface CasePaperViewController : UIViewController
- (IBAction)nextQues:(id)sender;
- (IBAction)preQues:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIButton *canDoOrNotBtn;


@property (strong ,nonatomic) NSArray * caseDataSource;
- (IBAction)showAnswer:(id)sender;
- (IBAction)saveQues:(id)sender;
@end
