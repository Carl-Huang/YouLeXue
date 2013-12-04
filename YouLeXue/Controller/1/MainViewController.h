//
//  MainViewController.h
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UIView *afterLoginView;
@property (weak, nonatomic) IBOutlet UILabel *countTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *NotLoignLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgeView;
- (IBAction)phoneCallAction:(id)sender;

@end
