//
//  YDLeftMenuViewController.h
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDLeftMenuViewController : UIViewController
- (IBAction)leftHistoryBtnAction:(id)sender;
- (IBAction)leftCleanHistoryAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *leftTable;

@end
