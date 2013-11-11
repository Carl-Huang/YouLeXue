//
//  UserInfoViewController.h
//  YouLeXue
//
//  Created by vedon on 10/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YDRightMenuViewController;
@interface UserInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *userInfoTable;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *alertUserInfo;
@property (weak, nonatomic) IBOutlet UIImageView *logoutAction;
@property (weak, nonatomic) IBOutlet UIImageView *myService;
@property (weak, nonatomic) IBOutlet UIView *btnBackGround;
@property (assign ,nonatomic) BOOL isShouldShowLoginView;
@property (weak ,nonatomic) YDRightMenuViewController * proxy;
- (IBAction)backAction:(id)sender;

@end
