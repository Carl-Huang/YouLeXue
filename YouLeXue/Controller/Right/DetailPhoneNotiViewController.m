//
//  DetailPhoneNotiViewController.m
//  YouLeXue
//
//  Created by vedon on 10/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "DetailPhoneNotiViewController.h"
#import "FetchUserMessageInfo.h"
@interface DetailPhoneNotiViewController ()

@end

@implementation DetailPhoneNotiViewController
@synthesize info;
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
    self.titleLabel.text = [info valueForKey:@"Title"];
    self.timeLabel.text = [info valueForKey:@"Sendtime"];
    self.contentTextView.text = [info valueForKey:@"Content"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setContentTextView:nil];
    [self setTitleLabel:nil];
    [self setTimeLabel:nil];
    [super viewDidUnload];
}
- (IBAction)deleteAction:(id)sender {
}
@end
