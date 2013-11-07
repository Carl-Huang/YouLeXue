//
//  loginCell.h
//  YouLeXue
//
//  Created by vedon on 7/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userTextFieldImage;
@property (weak, nonatomic) IBOutlet UIImageView *userPasswordImage;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end
