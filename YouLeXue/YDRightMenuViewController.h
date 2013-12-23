//
//  YDRightMenuViewController.h
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserLoginInfo;
@interface YDRightMenuViewController : UIViewController<UITextFieldDelegate>
- (IBAction)userCenterAction:(id)sender;
- (IBAction)upgrateVersionAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *rightTable;
@property (weak, nonatomic) IBOutlet UIView *afterLoginView;
@property (weak, nonatomic) IBOutlet UIView *beforeLoginView;

//beforeLoginView  outlet
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userNameImage;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImage;
- (IBAction)loginAction:(id)sender;


//afterLoginView    outlet
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *phoneAlertBtnAction;

@property (weak, nonatomic) IBOutlet UILabel *userNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *userDesclabel;
@property (weak, nonatomic) IBOutlet UILabel *userDetailDescLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (strong ,nonatomic) __block UserLoginInfo * userInfo;

- (IBAction)phoneAlertBtnAction:(id)sender;
- (IBAction)adviceBtnAction:(id)sender;
- (IBAction)reloadQuesBankAction:(id)sender;
- (IBAction)userInfoAction:(id)sender;
- (IBAction)updatePaperAction:(id)sender;
- (IBAction)logoutAction:(id)sender;
- (IBAction)registerAction:(id)sender;
@end
