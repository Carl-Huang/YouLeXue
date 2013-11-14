//
//  PaperViewController.m
//  YouLeXue
//
//  Created by vedon on 13/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

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


#import "PaperViewController.h"
#import "UIViewController+TabbarConfigure.h"
#import "ExamPaperInfo.h"
#import "ExamInfo.h"
#import "QuestionView.h"
@interface PaperViewController ()<UIScrollViewDelegate>
{
    NSArray * questTypes;
    
    //标志是否显示popTableview
    BOOL isShouldShowTable;
    CGRect originTableRect;
    
    //考试时间
    CGFloat examTime;
    
    //
    BOOL isEndScrolling;
    NSInteger currPage;                     //默认为第一页
    NSInteger prePage;
    NSInteger nextPage;
    NSInteger shouldDeletedPageL;
    NSInteger shouldDeletedPageR;
    NSInteger preOffsetX;
    PanDirection panDirectioin;
    NSMutableArray * currentDisplayItems; //保存着相对currPage，前一个数据，和后一个数据
    NSInteger totalPage;
    NSMutableArray * questionStrArray;    //所有试题的描述
}

@end

@implementation PaperViewController
@synthesize questionDataSource;
@synthesize  titleStr;
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
    [self setBackItem:nil withImage:@"Bottom_Icon_Back"];
    
    
    //获取试卷分类
    NSMutableSet * set = [NSMutableSet set];
    [questionDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ExamPaperInfo * info = obj;
        [set addObject:[info valueForKey:@"Tmtype"]];
    }];
    questTypes = [set allObjects];
    set = nil;

    //
    isShouldShowTable = NO;
    originTableRect = self.popUpTable.frame;
    self.popUpTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //倒计时
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(descreaseTime) userInfo:nil repeats:YES];
    examTime = [[self.examInfo valueForKey:@"kssj"]floatValue]*60;
    
    
    //content View
    [self.quesScrollView setContentSize:CGSizeMake([questionDataSource count]*320+10, self.quesScrollView.frame.size.height)];
    self.quesScrollView.pagingEnabled = YES;
    self.quesScrollView.delegate = self;
    self.quesScrollView.scrollEnabled = YES;
    self.quesScrollView.showsHorizontalScrollIndicator = NO;

    questionStrArray = [NSMutableArray array];
    for (int i = 0;i< [questionDataSource count];i++) {
        NSString * tempTitle = nil;
        NSString * descriptionStr = nil;
        ExamPaperInfo *tempPaperInfo = [questionDataSource objectAtIndex:i];
        if ([[tempPaperInfo valueForKey:@"IsRnd"]integerValue]==0) {
            NSInteger type = [[tempPaperInfo valueForKey:@"num"]integerValue];
            switch (type) {
                case 1:
                    tempTitle = @"第一大题";
                    break;
                case 2:
                    tempTitle = @"第二大题";
                    break;
                case 3:
                    tempTitle = @"第三大题";
                    break;
                case 4:
                    tempTitle = @"第四大题";
                    break;
                case 5:
                    tempTitle = @"第五大题";
                    break;
                case 6:
                    tempTitle = @"第六大题";
                    break;
                default:
                    break;
            }
            descriptionStr = [NSString stringWithFormat:@"%@%@%@",tempTitle,[tempPaperInfo valueForKey:@"tmnr"],[tempPaperInfo valueForKey:@"beizhu"]];
        }else
        {
             descriptionStr = [NSString stringWithFormat:@"%@%@%@",[tempPaperInfo valueForKey:@"num"],[tempPaperInfo valueForKey:@"title"],[tempPaperInfo valueForKey:@"tmnr"]];
        }
        [questionStrArray addObject:descriptionStr];
    }
    currentDisplayItems = [NSMutableArray array];
    totalPage = [questionDataSource count];
    currPage = 2;
    panDirectioin = PanDirectionNone;
    isEndScrolling = YES;
//    QuestionView * quesView = [[QuestionView alloc]initWithFrame:CGRectMake(0, 0, 320, 250)];
//   
//    [quesView.quesTextView loadHTMLString:[questionStrArray objectAtIndex:0] baseURL:nil];
//    [self.quesScrollView addSubview:quesView];
    [self refreshScrollViewWithDirection:panDirectioin];
    [self.view bringSubviewToFront:self.popUpTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPopUpTable:nil];
    [self setTimeLabel:nil];
    [self setWrongTextBookBtn:nil];
    [self setQuesScrollView:nil];
    [self setPreQueBtn:nil];
    [self setNextQuesBtn:nil];
    [super viewDidUnload];
}

-(void)descreaseTime
{
    [self translateTimeToStr:examTime --];
}

-(void)translateTimeToStr:(NSInteger)time
{
    int minute = floor(time / 60.0);
    int second = time % 60;
//    NSLog(@"%d,%d",minute,second);
    self.timeLabel.text = [NSString stringWithFormat:@"剩余:%d分%d秒",minute,second];
    
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [questTypes count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.popUpTable dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *array = [cell.contentView subviews];
    [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"User_Edit_Button_Confirm@2x"]];
    [imageView setFrame:CGRectMake(0, 0, 88, 45)];
    [cell.contentView addSubview:imageView];
    imageView = nil;
    
    
    if (indexPath.row == 0) {
        UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 60, 41)];
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.text = @"大题切换";
        [cell.contentView addSubview:textLabel];
        textLabel = nil;
    }else
    {
        NSNumber *type = [questTypes objectAtIndex:indexPath.row-1];
        [self configureCell:cell withType:[type integerValue]];
    }
    UIImageView * leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Case_Button_Change@2x"]];
    [leftImage setFrame:CGRectMake(5, 10, 20, 20)];
    [cell.contentView addSubview:leftImage];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        isShouldShowTable = !isShouldShowTable;
        [self configurePopupTable];
    }
}

-(void)configureCell:(UITableViewCell *)cell withType:(NSInteger)type
{
    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0,60, 41)];
    textLabel.font = [UIFont systemFontOfSize:13];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    switch (type) {
        case SingleSelectionType:
            textLabel.text = @"单选题";
            break;
        case OpinionSelectionType:
            textLabel.text = @"判断题";
            break;
        default:
             textLabel.text = @"多选题";
            break;
    }
    [cell.contentView addSubview:textLabel];
    textLabel = nil;
}

-(void)configurePopupTable
{
    if (isShouldShowTable) {
        CGRect rect = self.popUpTable.frame;
        rect.size.height = [questTypes count]*41+rect.size.height;
        
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect tempRect = rect;
            tempRect.size.height +=20;
            
            [self.popUpTable setFrame:tempRect];
            [UIView commitAnimations];
        } completion:^(BOOL finished) {
            self.popUpTable.frame = rect;
            
        }];
    }else
    {
        self.popUpTable.frame = originTableRect;
    }
}

#pragma  mark - UIScrollView Delegate


- (void)getDisplayImagesWithCurpage:(int)page direction:(PanDirection)direction{
    NSLog(@"%s",__func__);

    shouldDeletedPageL = page -2;
    prePage = page -1;
    nextPage = page +1;
    shouldDeletedPageR = page +2;
    
    if (direction == PanDirectionLeft) {
        [currentDisplayItems addObject:[questionStrArray objectAtIndex:prePage]];
        [currentDisplayItems removeObjectAtIndex:4];
    }else if(direction == PanDirectionRight)
    {
        [currentDisplayItems addObject:[questionStrArray objectAtIndex:nextPage]];
        [currentDisplayItems removeObjectAtIndex:0];
    }else
    {
        [currentDisplayItems addObject:[questionStrArray objectAtIndex:shouldDeletedPageL]];
        [currentDisplayItems addObject:[questionStrArray objectAtIndex:prePage]];
        [currentDisplayItems addObject:[questionStrArray objectAtIndex:currPage]];
        [currentDisplayItems addObject:[questionStrArray objectAtIndex:nextPage]];
        [currentDisplayItems addObject:[questionStrArray objectAtIndex:shouldDeletedPageR]];
    }
}


- (void)refreshScrollViewWithDirection:(PanDirection)direction {
    NSLog(@"%s",__func__);

    [self getDisplayImagesWithCurpage:currPage direction:direction];
    [self removeTheOppositeQuestionViewWithDirection:direction];
    if (direction == PanDirectionLeft) {
        NSString * tempStr = [currentDisplayItems objectAtIndex:0];
        QuestionView * quesView = [[QuestionView alloc]initWithFrame:CGRectMake(320*prePage, 0, 320, 250)];
        [quesView.quesTextView loadHTMLString:tempStr baseURL:nil];
        [self.quesScrollView addSubview:quesView];
    }else if (direction == PanDirectionRight)
    {
        NSString * tempStr = [currentDisplayItems objectAtIndex:2];
        QuestionView * quesView = [[QuestionView alloc]initWithFrame:CGRectMake(320*nextPage, 0, 320, 250)];
        [quesView.quesTextView loadHTMLString:tempStr baseURL:nil];
        [self.quesScrollView addSubview:quesView];
    }else
    {
//        for (int i = 0; i < 5; i++) {
//            NSString * tempStr = [currentDisplayItems objectAtIndex:i];
//            QuestionView * quesView = [[QuestionView alloc]initWithFrame:CGRectMake(320*i, 0, 320, 250)];
//            [quesView.quesTextView loadHTMLString:tempStr baseURL:nil];
//            [self.quesScrollView addSubview:quesView];
//        }
        
        //够屌丝，一次加载全部
        for (int i = 0; i < [questionStrArray count]; i++) {
            NSString * tempStr = [questionStrArray objectAtIndex:i];
            QuestionView * quesView = [[QuestionView alloc]initWithFrame:CGRectMake(320*i, 0, 320, 250)];
            NSError * error = nil;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a href=\"[^\"]+\">([^<]+)</a>" options:NSRegularExpressionCaseInsensitive error:&error];
            NSString *modifiedString = [regex stringByReplacingMatchesInString:tempStr options:0 range:NSMakeRange(0, [tempStr length]) withTemplate:@"$1"];
            [quesView.quesTextView loadHTMLString:modifiedString baseURL:nil];
            [self.quesScrollView addSubview:quesView];
        }

    }
}

-(void)removeTheOppositeQuestionViewWithDirection:(PanDirection)direction
{
    NSLog(@"%s",__func__);
    NSArray *subViews = [self.quesScrollView subviews];
    if ([subViews count]) {
        if (direction == PanDirectionLeft) {
            //清除最后一个obj
            CGRect tempRect = CGRectMake(shouldDeletedPageR *320, 0, 320, 250);
            for (UIView * view in subViews) {
                if ([view isKindOfClass:[QuestionView class]]&&CGRectEqualToRect(view.frame, tempRect) ) {
                    [view removeFromSuperview];
                }
            }
        }else if(direction == PanDirectionRight)
        {
            //清除第一个obj
            CGRect tempRect = CGRectMake(shouldDeletedPageL *320, 0, 320, 250);
            for (UIView * view in subViews) {
                if ([view isKindOfClass:[QuestionView class]]&&CGRectEqualToRect(view.frame, tempRect) ) {
                    
                    [view removeFromSuperview];
                }
            }
            
        }
    }
  
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat offsetX = scrollView.contentOffset.x;
    
    
//    NSLog(@"%f",offsetX);
//    if (offsetX > 50) {
//        CGFloat pageWidth = scrollView.frame.size.width;
//        float fractionalPage = scrollView.contentOffset.x / pageWidth;
//        NSInteger page = lround(fractionalPage)+1;
//        currPage = page;
//        if (isEndScrolling) {
//            if(currPage == nextPage) {
//                isEndScrolling = NO;
//                panDirectioin = PanDirectionRight;
//                [self refreshScrollViewWithDirection:panDirectioin];
//            }
//            if(currPage == prePage) {
//                isEndScrolling = NO;
//                panDirectioin = PanDirectionLeft;
//                [self refreshScrollViewWithDirection:panDirectioin];
//            }
//        }
//    }
    
    
//    CGFloat pageWidth = scrollView.frame.size.width;
//    float fractionalPage = scrollView.contentOffset.x / pageWidth;
//    NSInteger page = lround(fractionalPage)+1;
//    currPage = page;
//    NSInteger  offset = (currPage-1)*self.quesScrollView.frame.size.width;
//    if (offsetX >offset&&isEndScrolling) {
//        NSLog(@"下一页");
//        isEndScrolling = NO;
//        preOffsetX = offsetX;
//        panDirectioin = PanDirectionRight;
//        [self refreshScrollViewWithDirection:panDirectioin];
//    }else if (offsetX < preOffsetX&&isEndScrolling){
//        NSLog(@"上一页");
//        isEndScrolling = NO;
//        preOffsetX = offsetX;
//        panDirectioin = PanDirectionLeft;
//        [self refreshScrollViewWithDirection:panDirectioin];
//    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    isEndScrolling = YES;
}
@end
