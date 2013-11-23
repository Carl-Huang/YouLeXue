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
#import "QuestionView.h"
#import "CaseView.h"

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
    
    //所有案例的表述
    NSMutableArray * caseQuestionArray;
    
    //答案解释
    NSMutableArray * answerArray;

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
    answerArray         = [NSMutableArray array];
    currentDisplayItems = [NSMutableArray array];
    caseQuestionArray   = [NSMutableArray array];
    for (ExamplePaperInfo * info in caseDataSource) {
        @autoreleasepool {
            NSString * descripitionStr = [NSString stringWithFormat:@"%@%@",[info valueForKey:@"Title"],[info valueForKey:@"ArticleContent"]];
            [caseQuestionArray addObject:descripitionStr];
            
            NSString * answerStr = [NSString stringWithFormat:@"%@",[info valueForKey:@"KS_daan"]];
            [answerArray addObject:answerStr];
        }
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

    [self refreshScrollViewWithDirection:panDirectioin];

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
    if (currentPage <[caseQuestionArray count]) {
        currentPage ++;
        [self.contentScrollView scrollRectToVisible:CGRectMake(currentPage *self.contentScrollView.frame.size.width, 0, 320, self.contentScrollView.frame.size.height) animated:YES];
        if (currentPage>2) {
            [self refreshScrollViewWithDirection:PanDirectionRight];
        }
        
    }
}

- (IBAction)preQues:(id)sender {
    if (currentPage > 0) {
        currentPage --;
        [self.contentScrollView scrollRectToVisible:CGRectMake(currentPage *self.contentScrollView.frame.size.width, 0, 320, self.contentScrollView.frame.size.height) animated:YES];
        if (currentPage>2) {
            [self refreshScrollViewWithDirection:PanDirectionLeft];
        }
    }

}

- (IBAction)showAnswer:(id)sender {
    //显示答案

    NSLog(@"%d",currentPage);
    CGRect rect = CGRectMake(320*currentPage, 0, 320, questionViewHeight);
    NSArray * subViews = [self.contentScrollView subviews];
    for (UIView * view in subViews) {
        if ([view isKindOfClass:[CaseView class]]) {
            if (CGRectEqualToRect(rect, view.frame)) {
                //显示答案
                CaseView * questionView = (CaseView *)view;
                NSString * str = [answerArray objectAtIndex:currentPage];
                
                NSURL * url = [NSURL URLWithString:@"http://www.55280.com/UploadFiles/2013/2/2013090923361629055.jpg"];
                NSString* basePath = [[NSBundle mainBundle] bundlePath];
                [questionView.contentView loadHTMLString:str baseURL:[NSURL fileURLWithPath:basePath]];
            }
        }
    }

}

-(NSString *)getImageUrl:(NSString *)searchStr
{
    NSError * error;
    NSRegularExpression * regex = [[NSRegularExpression alloc]initWithPattern:@"/\\S*\\d.jpg" options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
    NSArray * compomentArray =[regex matchesInString:searchStr options:NSMatchingReportProgress range:NSMakeRange(0, [searchStr length])];
    for (NSTextCheckingResult * checktStr in compomentArray) {
        NSRange range = [checktStr rangeAtIndex:0];
        NSLog(@"%@",[searchStr substringWithRange:range]);
    }
    return searchStr;
}
- (IBAction)saveQues:(id)sender {
    //收藏本题
}


-(void)removeTheOppositeQuestionViewWithDirection:(PanDirection)direction
{
#ifdef LogoutFunctionName
    NSLog(@"%s",__func__);
#endif
    
    NSArray *subViews = [self.contentScrollView subviews];
    if ([caseDataSource count]>5) {
        if ([subViews count]) {
            if (direction == PanDirectionLeft) {
                //清除最后一个obj
                CGRect tempRect = CGRectMake(shouldDeletedPageR *320, 0, 320, 250);
                for (UIView * view in subViews) {
                    if ([view isKindOfClass:[QuestionView class]]&&CGRectEqualToRect(view.frame, tempRect) ) {
                        [view removeFromSuperview];
                        NSLog(@"removeFromSuperview");
                    }
                }
            }else if(direction == PanDirectionRight)
            {
                //清除第一个obj
                CGRect tempRect = CGRectMake(shouldDeletedPageL *320, 0, 320, 250);
                for (UIView * view in subViews) {
                    if ([view isKindOfClass:[QuestionView class]]&&CGRectEqualToRect(view.frame, tempRect) ) {
                        [view removeFromSuperview];
                        NSLog(@"removeFromSuperview");
                    }
                }
                
            }
        }
    }
    
}
- (void)getDisplayImagesWithCurpage:(int)page direction:(PanDirection)direction{
#ifdef LogoutFunctionName
    NSLog(@"%s",__func__);
#endif
    if ([caseQuestionArray count]<=5) {
            for (NSString * str in caseQuestionArray) {
                [currentDisplayItems addObject:str];
            }

    }else
    {
        if (page < [caseQuestionArray count]-2) {
            shouldDeletedPageL = page -2;
            prePage = page -1;
            nextPage = page +1;
            shouldDeletedPageR = page +2;
            
            if (direction == PanDirectionLeft) {
                [currentDisplayItems removeLastObject];
                NSMutableArray * tempArray = [NSMutableArray array];
                [tempArray addObject:[caseQuestionArray objectAtIndex:shouldDeletedPageL]];
                [tempArray addObjectsFromArray:currentDisplayItems];
                [currentDisplayItems removeAllObjects];
                [currentDisplayItems  addObjectsFromArray:tempArray];
                
            }else if(direction == PanDirectionRight)
            {
                [currentDisplayItems removeObjectAtIndex:0];
                [currentDisplayItems addObject:[caseQuestionArray objectAtIndex:shouldDeletedPageR]];
            }else
            {
                if ([caseQuestionArray count]>=5) {
                    [currentDisplayItems addObject:[caseQuestionArray objectAtIndex:shouldDeletedPageL]];
                    [currentDisplayItems addObject:[caseQuestionArray objectAtIndex:prePage]];
                    [currentDisplayItems addObject:[caseQuestionArray objectAtIndex:criticalPage]];
                    [currentDisplayItems addObject:[caseQuestionArray objectAtIndex:nextPage]];
                    [currentDisplayItems addObject:[caseQuestionArray objectAtIndex:shouldDeletedPageR]];
                    
                }
            }
        }
    }
    
}
- (void)refreshScrollViewWithDirection:(PanDirection)direction {
    prePanDirection = direction;
    [self removeTheOppositeQuestionViewWithDirection:direction];
    [self getDisplayImagesWithCurpage:criticalPage direction:direction];
    if ([caseQuestionArray count]<=5) {
        for (int i = 0; i < [caseQuestionArray count]; i++) {
            
            NSString * tempStr = [currentDisplayItems objectAtIndex:i];
            [self addCaseView:tempStr withIndex:i];
        }
    }else
    {
        if (criticalPage < [caseQuestionArray count]-2) {
            if (direction == PanDirectionLeft) {
                NSString * tempStr = [currentDisplayItems objectAtIndex:0];
                [self addCaseView:tempStr withIndex:shouldDeletedPageL];
            }else if (direction == PanDirectionRight)
            {
                NSString * tempStr = [currentDisplayItems objectAtIndex:4];
                [self addCaseView:tempStr withIndex:shouldDeletedPageR];
            }else
            {
                for (int i = 0; i < 5; i++) {
                    
                    NSString * tempStr = [currentDisplayItems objectAtIndex:i];
                    [self addCaseView:tempStr withIndex:i];
                }
            }
        }

    }
        
}

-(void)addCaseView:(NSString *)descrption withIndex:(NSInteger)index
{
    NSString * time = [[caseDataSource objectAtIndex:index]valueForKey:@"AddDate"];
    NSDateFormatter * format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [format dateFromString:time];
    
    NSDateFormatter * simpleFormat= [[NSDateFormatter alloc]init];
    [simpleFormat setDateFormat:@"yyyy-MM-dd"];
    NSString * timeStr = [simpleFormat stringFromDate:date];
    
    
    CaseView * quesView = [[CaseView alloc]initWithFrame:CGRectMake(320*index, 0, 320, questionViewHeight) withDescriptionStr:descrption time:timeStr];
    
    [self.contentScrollView addSubview:quesView];
    quesView = nil;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    //    NSLog(@"当前页:%d",page);
    currentPage = page;
    if (page >2) {
        criticalPage = page;
        if (isEndScrolling) {
            NSLog(@"ciritcalPage:%d   nextPage: %d",criticalPage,nextPage);
            if(criticalPage ==nextPage) {
                isEndScrolling = NO;
                panDirectioin = PanDirectionRight;
                [self refreshScrollViewWithDirection:panDirectioin];
            }
            if(criticalPage ==prePage) {
                NSLog(@"上一页");
                isEndScrolling = NO;
                panDirectioin = PanDirectionLeft;
                [self refreshScrollViewWithDirection:panDirectioin];
            }
            
        }
    }
}
- (void)viewDidUnload {
    [self setContentScrollView:nil];
    [self setCanDoOrNotBtn:nil];
    [super viewDidUnload];
}
@end

