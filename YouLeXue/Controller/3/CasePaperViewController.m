//
//  CasePaperViewController.m
//  YouLeXue
//
//  Created by vedon on 23/11/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import "CasePaperViewController.h"
#import "UIViewController+TabbarConfigure.h"
#import "ExamplePaperInfo.h"
@interface CasePaperViewController ()<UIScrollViewDelegate>
{
    NSInteger questionViewHeight;
    
    //滚动scrollview相关变量
    BOOL isEndScrolling;
    
    NSInteger criticalPage;
    NSInteger prePage;
    NSInteger nextPage;
    NSInteger shouldDeletedPageL;
    NSInteger shouldDeletedPageR;
    
    NSInteger preOffsetX;
    NSInteger previousPage;
    PanDirection panDirectioin;
    PanDirection prePanDirection;
    NSMutableArray * currentDisplayItems; //保存着相对criticalPage，前一个数据，和后一个数据
    NSInteger currentPage;

}
@end

@implementation CasePaperViewController
@synthesize caseDataSource;
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

    
    //contentView

    [self.contentScrollView setContentSize:CGSizeMake([caseDataSource count]*320+10, self.contentScrollView.frame.size.height)];
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate = self;
    self.contentScrollView.scrollEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;

    criticalPage = 2;
    panDirectioin = PanDirectionNone;
    prePanDirection= PanDirectionNone;
    preOffsetX = 0.0;
    isEndScrolling = YES;
    previousPage = 1;
    currentPage = 0;

//    [self refreshScrollViewWithDirection:panDirectioin];

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
