//
//  EndExamScoreViewController.m
//  YouLeXue
//
//  Created by vedon on 19/11/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import "EndExamScoreViewController.h"

@interface EndExamScoreViewController ()

@end

@implementation EndExamScoreViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserImage:nil];
    [self setDescriptionLabel:nil];
    [self setScoreLabel:nil];
    [self setPaperInfoTable:nil];
    [super viewDidUnload];
}
- (IBAction)viewPaperAnswer:(id)sender {
}

- (IBAction)ExamAgain:(id)sender {
}

- (IBAction)shareExam:(id)sender {
}
@end
