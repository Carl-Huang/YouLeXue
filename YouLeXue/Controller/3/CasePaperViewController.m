//
//  CasePaperViewController.m
//  YouLeXue
//
//  Created by vedon on 23/11/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import "CasePaperViewController.h"
#import "UIViewController+TabbarConfigure.h"
@interface CasePaperViewController ()
{
    NSInteger questionViewHeight;
}
@end

@implementation CasePaperViewController

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
    if (IS_SCREEN_4_INCH) {
        questionViewHeight = 408;
        CGRect rect= self.contentScrollView.frame;
        rect.size.height +=88;
        self.contentScrollView.frame = rect;
    }else
    {
        questionViewHeight = 320;
    }

    // Do any additional setup after loading the view from its nib.
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextQues:(id)sender {
}

- (IBAction)preQues:(id)sender {
}
- (void)viewDidUnload {
    [self setContentScrollView:nil];
    [self setCanDoOrNotBtn:nil];
    [super viewDidUnload];
}
- (IBAction)showAnswer:(id)sender {
}

- (IBAction)saveQues:(id)sender {
}
@end
