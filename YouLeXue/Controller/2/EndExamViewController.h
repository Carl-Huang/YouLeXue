//
//  EndExamViewController.h
//  YouLeXue
//
//  Created by vedon on 16/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndExamViewController : UIViewController
@property (strong ,nonatomic) NSString * timeStamp;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneQuestionCount;

@end
