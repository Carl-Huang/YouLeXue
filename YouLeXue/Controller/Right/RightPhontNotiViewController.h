//
//  RightPhontNotiViewController.h
//  YouLeXue
//
//  Created by vedon on 10/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightPhontNotiViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backItem;
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *phoneNotiTable;

@end
