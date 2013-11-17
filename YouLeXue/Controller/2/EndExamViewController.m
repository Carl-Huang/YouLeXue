//
//  EndExamViewController.m
//  YouLeXue
//
//  Created by vedon on 16/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "EndExamViewController.h"
#import "UIViewController+TabbarConfigure.h"
@interface EndExamViewController ()

@end

@implementation EndExamViewController
@synthesize timeStamp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackItem:@selector(back) withImage:@"Bottom_Icon_Back"];
    [self setForwardItem:@selector(endExamAction) withImage:@"Exercise_Model_Button_Submit"];
    self.timeLabel.text = self.timeStamp;
    // Do any additional setup after loading the view from its nib.
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)endExamAction
{
    //交卷
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTimeLabel:nil];
    [self setDoneQuestionCount:nil];
    [super viewDidUnload];
}
@end
