//
//  MainViewController.m
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"优乐学";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self animation];
    [self.afterLoginView setHidden:YES];
    // Do any additional setup after loading the view from its nib.
}

-(void)animation
{
    
    CABasicAnimation *translate1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    translate1.duration = 0.4;
    translate1.autoreverses = YES;
    translate1.repeatCount  = MAXFLOAT;
    translate1.removedOnCompletion = NO;
    translate1.fromValue   = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
    translate1.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(30, 0, 0)];
    [self.leftImage.layer addAnimation:translate1 forKey:@"shakeAnimation"];
    
    
    CABasicAnimation *translate2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    translate2.duration = 0.4;
    translate2.autoreverses = YES;
    translate2.repeatCount  = MAXFLOAT;
    translate2.removedOnCompletion = NO;
    translate2.fromValue   = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
    translate2.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-30, 0, 0)];
    [self.rightImage.layer addAnimation:translate2 forKey:@"shakeAnimation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tabImageName
{
	return @"Bottom_Icon_Home_Down";
}


- (void)viewDidUnload {
    [self setLeftImage:nil];
    [self setRightImage:nil];
    [self setAfterLoginView:nil];
    [super viewDidUnload];
}
@end
