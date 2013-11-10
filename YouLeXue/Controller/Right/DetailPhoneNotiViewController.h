//
//  DetailPhoneNotiViewController.h
//  YouLeXue
//
//  Created by vedon on 10/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FetchUserMessageInfo;
@interface DetailPhoneNotiViewController : UIViewController
@property (strong ,nonatomic)FetchUserMessageInfo *info;
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)deleteAction:(id)sender;
@end
