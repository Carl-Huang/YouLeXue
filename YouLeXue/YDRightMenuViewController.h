//
//  YDRightMenuViewController.h
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDRightMenuViewController : UIViewController
- (IBAction)userCenterAction:(id)sender;
- (IBAction)upgrateVersionAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *rightTable;

@end
