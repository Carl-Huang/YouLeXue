//
//  UserInfoCell.h
//  YouLeXue
//
//  Created by vedon on 7/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userDescription;
@property (weak, nonatomic) IBOutlet UILabel *userDetailDescription;
@property (weak, nonatomic) IBOutlet UIButton *phoneAlert;
@property (weak, nonatomic) IBOutlet UIButton *adviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *userInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *reloadQuesBankBtn;
@property (weak, nonatomic) IBOutlet UIButton *updatePaper;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end
