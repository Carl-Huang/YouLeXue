//
//  WrongPaperViewController.m
//  YouLeXue
//
//  Created by vedon on 13/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//
//#define LogoutFunctionName

typedef NS_ENUM(NSInteger, PanDirection)
{
    PanDirectionNone = 0,
    PanDirectionLeft = 1,
    PanDirectionRight = 2,
};

#define SingleSelectionType     2  //单选题
#define MultiSelectionFromATD   3  //A To D 多选题
#define OpinionSelectionType    4  //判断题
#define MultiSelectionFromATF   5  //A To F 多选题
#define MultiSelectionFromATE   6  //A To E 多选题


#import "WrongPaperViewController.h"
#import "UIViewController+TabbarConfigure.h"

#import "PersistentDataManager.h"
#import "ExamPaperInfoTimeStamp.h"
#import <objc/runtime.h>
#import "WrongTextView.h"
@interface WrongPaperViewController ()<UIScrollViewDelegate>
{

    //滚动scrollview相关变量
    BOOL isEndScrolling;
     

    PanDirection panDirectioin;
   
    NSInteger currentPage;
    NSMutableArray * questionStrArray;    //所有试题的描述
    
    
    //QuestionView height
    NSInteger questionViewHeight;

}
@property (assign ,nonatomic) NSInteger criticalPage;
@end

@implementation WrongPaperViewController
@synthesize questionDataSource;
@synthesize  titleStr,criticalPage;
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
    self.title = titleStr;
    [self setBackItem:@selector(back) withImage:@"Bottom_Icon_Back"];
    [self setForwardItem:@selector(endExamAction) withImage:@"Exercise_Model_Button_Submit"];
    if (IS_SCREEN_4_INCH) {
        questionViewHeight = 408;
        CGRect rect= self.quesScrollView.frame;
        rect.size.height +=88;
        self.quesScrollView.frame = rect;
    }else
    {
        questionViewHeight = 320;
    }
    

    //content View
    [self.quesScrollView setContentSize:CGSizeMake([questionDataSource count]*320+10, self.quesScrollView.frame.size.height)];
    self.quesScrollView.pagingEnabled = YES;
    self.quesScrollView.delegate = self;
    self.quesScrollView.scrollEnabled = YES;
    self.quesScrollView.showsHorizontalScrollIndicator = NO;

    questionStrArray = [NSMutableArray array];
    for (ExamPaperInfoTimeStamp * info in self.questionDataSource) {
        NSString * descriptionStr = nil;
        descriptionStr = [NSString stringWithFormat:@"%@%@%@",[info valueForKey:@"title"],[info valueForKey:@"tmnr"],[info valueForKey:@"DAJS"]];
        [questionStrArray addObject:descriptionStr];
    }
    for (int i =0; i<[questionStrArray count];i++) {
        NSString *str =  [questionStrArray objectAtIndex:i];
        WrongTextView * textView = [[WrongTextView alloc]initWithFrame:CGRectMake(320 *i, 0, 320, questionViewHeight) withStrL:[self removeHerfLinkInStr:str]];
        [self.quesScrollView addSubview:textView];
        textView = nil;
    }
    panDirectioin = PanDirectionNone;



}


-(NSString *)removeHerfLinkInStr:(NSString *)str
{
    NSError * error =nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a href=\"[^\"]+\">([^<]+)</a>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString * tempStr = [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@"$1"];
    return tempStr;
}

-(void)back
{
    NSLog(@"%s",__func__);
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setQuesScrollView:nil];
    [self setPreQueBtn:nil];
    [self setNextQuesBtn:nil];
    [super viewDidUnload];
}

#pragma  mark - UIScrollView Delegate



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    currentPage = page;
//    [self.quesScrollView scrollRectToVisible:CGRectMake(currentPage *320, 0, 320, self.quesScrollView.frame.size.height) animated:YES];

}



- (IBAction)preQuestionAction:(id)sender {
    if (currentPage > 0) {
        currentPage --;
        [self.quesScrollView scrollRectToVisible:CGRectMake(currentPage *self.quesScrollView.frame.size.width, 0, 320, self.quesScrollView.frame.size.height) animated:YES];
    }
}

- (IBAction)nextQuestionAction:(id)sender {
    if (currentPage <[questionStrArray count]) {
        currentPage ++;
        [self.quesScrollView scrollRectToVisible:CGRectMake(currentPage *self.quesScrollView.frame.size.width, 0, 320, self.quesScrollView.frame.size.height) animated:YES];
    }
}



-(void)endExamAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

