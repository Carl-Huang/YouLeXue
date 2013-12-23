//
//  WrongRuleViewController.h
//  YouLeXue
//
//  Created by vedon on 5/12/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WrongRuleViewController : UIViewController
- (IBAction)sureAction:(id)sender;
- (IBAction)cancelActioin:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *contentTable;

@end
