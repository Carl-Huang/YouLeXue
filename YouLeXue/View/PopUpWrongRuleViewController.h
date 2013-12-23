//
//  PopUpWrongRuleViewController.h
//  YouLeXue
//
//  Created by vedon on 5/12/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^DidSelectedItemBlock) (NSInteger time);
@interface PopUpWrongRuleViewController : UIViewController
- (IBAction)sureAction:(id)sender;
- (IBAction)cancelActioin:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (strong, nonatomic) DidSelectedItemBlock block;
@end
