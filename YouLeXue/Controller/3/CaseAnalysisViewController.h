//
//  TestUserGroupViewController.h
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseAnalysisViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *firstTable;
@property (weak, nonatomic) IBOutlet UITableView *secondTable;
@property (weak, nonatomic) IBOutlet UITableView *thirdTable;
@property (weak, nonatomic) IBOutlet UITableView *fourthTable;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollview;
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollview;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;

- (IBAction)firstBtnAction:(id)sender;
- (IBAction)secondBtnAction:(id)sender;
- (IBAction)thirdBtnAction:(id)sender;
- (IBAction)fourthBtnAction:(id)sender;

@end
