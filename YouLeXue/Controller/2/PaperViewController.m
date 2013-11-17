//
//  PaperViewController.m
//  YouLeXue
//
//  Created by vedon on 13/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
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


#import "PaperViewController.h"
#import "UIViewController+TabbarConfigure.h"
#import "ExamPaperInfo.h"
#import "ExamInfo.h"
#import "QuestionView.h"
#import "PersistentDataManager.h"
#import "ExamPaperInfoTimeStamp.h"
#import <objc/runtime.h>
#import "EndExamViewController.h"
@interface PaperViewController ()<UIScrollViewDelegate>
{
    NSArray * questTypes;
    
    //标志是否显示popTableview
    BOOL isShouldShowTable;
    CGRect originTableRect;
    
    //考试时间
    CGFloat examOriginTime;
    CGFloat examTime;
    NSTimer *countTimer;
    
    //滚动scrollview相关变量
    BOOL isEndScrolling;
     
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
    NSMutableArray * questionStrArray;    //所有试题的描述
    
    
    //QuestionView height
    NSInteger questionViewHeight;
    
    //保存每一个问题的答案
    NSMutableDictionary * answerDictionary;
    
    //初始化questionview 开始page
    NSInteger printOnPage;
    
    //错题本
    NSMutableArray * wrongExamPaperInfoArray;
}
@property (assign ,nonatomic) NSInteger criticalPage;
@end

@implementation PaperViewController
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
    
    //获取试卷分类
    NSMutableSet * set = [NSMutableSet set];
    [questionDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ExamPaperInfo * info = obj;
        NSString * tmtType = [NSString stringWithFormat:@"%@",[info valueForKey:@"Tmtype"]];
        NSDictionary * dic = @{@"Tmtype":tmtType,@"StartIndex":[NSString stringWithFormat:@"%d",idx]};
        BOOL isCanAddobj = YES;
        if ([set count]) {
            for (NSDictionary *dic in set) {
                if ([[dic valueForKey:@"Tmtype" ] isEqualToString:[info valueForKey:@"Tmtype"]]) {
                    isCanAddobj = NO;
                }
            }
            if (isCanAddobj) {
                [set addObject:dic];
            }
        }else
        {
            [set addObject:dic];
        }
    }];
    questTypes = [set allObjects];
    set = nil;

    //
    isShouldShowTable = NO;
    originTableRect = self.popUpTable.frame;
    self.popUpTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //倒计时
    countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(descreaseTime) userInfo:nil repeats:YES];
    examTime = [[self.examInfo valueForKey:@"kssj"]floatValue]*60;
    examOriginTime = examTime;
    
    //content View
    [self.quesScrollView setContentSize:CGSizeMake([questionDataSource count]*320+10, self.quesScrollView.frame.size.height)];
    self.quesScrollView.pagingEnabled = YES;
    self.quesScrollView.delegate = self;
    self.quesScrollView.scrollEnabled = YES;
    self.quesScrollView.showsHorizontalScrollIndicator = NO;

    questionStrArray = [NSMutableArray array];
    answerDictionary = [NSMutableDictionary dictionary];
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
            NSError * error;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a href=\"[^\"]+\">([^<]+)</a>" options:NSRegularExpressionCaseInsensitive error:&error];
            descriptionStr = [regex stringByReplacingMatchesInString:descriptionStr options:0 range:NSMakeRange(0, [descriptionStr length]) withTemplate:@"$1"];
            [answerDictionary setObject:@"" forKey:[tempPaperInfo valueForKey:@"num"]];
        }
        [questionStrArray addObject:descriptionStr];
        
    }
    currentDisplayItems = [NSMutableArray array];
    
    [self addObserver:self forKeyPath:@"criticalPage" options:NSKeyValueObservingOptionNew context:NULL];
    criticalPage = 2;
    panDirectioin = PanDirectionNone;
    prePanDirection= PanDirectionNone;
    preOffsetX = 0.0;
    isEndScrolling = YES;
    previousPage = 1;
    currentPage = 0;
    printOnPage = 0;
    [self refreshScrollViewWithDirection:panDirectioin];
    [self.view bringSubviewToFront:self.popUpTable];
    
    //初始化错题本
    wrongExamPaperInfoArray = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([countTimer isValid]) {
        [countTimer fire];
    }else
    {
        countTimer =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(descreaseTime) userInfo:nil repeats:YES];
    }

}

-(void)back
{
    NSLog(@"%s",__func__);
    [[PersistentDataManager sharePersistenDataManager]createWrongTextBook:wrongExamPaperInfoArray];
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"criticalPage"]) {
        ;
    }
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

#pragma mark - A,B,C,D Select Block
-(ButtonConfigrationBlock)buttonBlock
{
    ButtonConfigrationBlock block = ^(NSString *str,NSInteger itemIndex)
    {
        if (![self isExamTitle:itemIndex]&&str) {
            [answerDictionary setObject:str forKey:[NSString stringWithFormat:@"%d",itemIndex]];
            NSLog(@"%@",answerDictionary);
        }
        NSLog(@"%d",itemIndex);
    };
    return block;
}

-(BOOL)isExamTitle:(NSInteger )index
{
    ExamPaperInfo *tempPaperInfo = [questionDataSource objectAtIndex:index];
    if ([[tempPaperInfo valueForKey:@"IsRnd"]integerValue]==0) {
        return  YES;
    }
    return  NO;
}

-(PaperType)paperType:(NSInteger)index
{
    ExamPaperInfo *tempPaperInfo = [questionDataSource objectAtIndex:index];
    NSInteger tType= [[tempPaperInfo valueForKey:@"Tmtype"]integerValue];
    
    /*
     2:代表单选题
     3：A-D 多选
     4：判断题
     5：A-F 多选
     6：A-E 多选
     
     */
    switch (tType) {
        case 2:
            return PaperTypeChoose;
            break;
        case 3:
            return PaperTypeMutiChooseAD;
            break;

        case 4:
            return PaperTypeOpinion;
            break;

        case 5:
            return PaperTypeMutiChooseAF;
            break;

        case 6:
            return PaperTypeMutiChooseAE;
            break;

        default:
            break;
    }
    return  NO;

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
        NSNumber *type = [[questTypes objectAtIndex:indexPath.row-1]objectForKey:@"Tmtype"];
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
    }else
    {
        
        //跳到相应的题目分类
         NSString *tempStartIndexStr = [[questTypes objectAtIndex:indexPath.row-1]objectForKey:@"StartIndex"];
         NSArray *subViews = [self.quesScrollView subviews];
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //重新加载新的题目
        NSInteger startIndex = [tempStartIndexStr integerValue];
        printOnPage = startIndex;
        currentPage = startIndex;
        criticalPage = startIndex+2;
        [currentDisplayItems removeAllObjects];
        [self refreshScrollViewWithDirection:PanDirectionNone];
        [self.quesScrollView scrollRectToVisible:CGRectMake(320 *currentPage, 0, 320, self.quesScrollView.frame.size.height) animated:YES];
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
#ifdef LogoutFunctionName
    NSLog(@"%s",__func__);
#endif

    if (shouldDeletedPageR < [questionDataSource count]-1) {
        shouldDeletedPageL = page -2;
        prePage = page -1;
        nextPage = page +1;
        shouldDeletedPageR = page +2;
        
        if (direction == PanDirectionLeft) {
            [currentDisplayItems removeLastObject];
            NSMutableArray * tempArray = [NSMutableArray array];
            [tempArray addObject:[questionStrArray objectAtIndex:shouldDeletedPageL]];
            [tempArray addObjectsFromArray:currentDisplayItems];
            [currentDisplayItems removeAllObjects];
            [currentDisplayItems  addObjectsFromArray:tempArray];
            
        }else if(direction == PanDirectionRight)
        {
            [currentDisplayItems removeObjectAtIndex:0];
            [currentDisplayItems addObject:[questionStrArray objectAtIndex:shouldDeletedPageR]];
        }else
        {
            
            [currentDisplayItems addObject:[questionStrArray objectAtIndex:shouldDeletedPageL]];
            [currentDisplayItems addObject:[questionStrArray objectAtIndex:prePage]];
            [currentDisplayItems addObject:[questionStrArray objectAtIndex:criticalPage]];
            [currentDisplayItems addObject:[questionStrArray objectAtIndex:nextPage]];
            [currentDisplayItems addObject:[questionStrArray objectAtIndex:shouldDeletedPageR]];
        }
    }
    
}


- (void)refreshScrollViewWithDirection:(PanDirection)direction {
#ifdef LogoutFunctionName
    NSLog(@"%s",__func__);
#endif

    prePanDirection = direction;
    [self removeTheOppositeQuestionViewWithDirection:direction];
    [self getDisplayImagesWithCurpage:criticalPage direction:direction];
    if (criticalPage < [questionDataSource count]-2) {
        if (direction == PanDirectionLeft) {
            NSString * tempStr = [currentDisplayItems objectAtIndex:0];
            QuestionView * quesView = [[QuestionView alloc]initWithFrame:CGRectMake(320*shouldDeletedPageL, 0, 320, questionViewHeight) ItemIndex:shouldDeletedPageL PaperType:[self paperType:shouldDeletedPageL] isTitle:[self isExamTitle:shouldDeletedPageL]];
            
            //判断是否已经选择了，有就设置相应的选项
            NSString *tempAlphabet =[answerDictionary objectForKey:[NSString stringWithFormat:@"%d",shouldDeletedPageL]];
            if ([tempAlphabet length]) {
                [quesView setSelectButonStatus:tempAlphabet];
            }
            [quesView setBlock:[self buttonBlock]];
            [quesView.quesTextView loadHTMLString:tempStr baseURL:nil];
            [self.quesScrollView addSubview:quesView];
        }else if (direction == PanDirectionRight)
        {
            NSString * tempStr = [currentDisplayItems objectAtIndex:4];
            QuestionView * quesView = [[QuestionView alloc]initWithFrame:CGRectMake(320*shouldDeletedPageR, 0, 320, questionViewHeight) ItemIndex:shouldDeletedPageR PaperType:[self paperType:shouldDeletedPageR] isTitle:[self isExamTitle:shouldDeletedPageR]];
            
            //判断是否已经选择了，有就设置相应的选项
            NSString *tempAlphabet =[answerDictionary objectForKey:[NSString stringWithFormat:@"%d",shouldDeletedPageR]];
            if ([tempAlphabet length]) {
                [quesView setSelectButonStatus:tempAlphabet];
            }
            [quesView setBlock:[self buttonBlock]];
            [quesView.quesTextView loadHTMLString:tempStr baseURL:nil];
            [self.quesScrollView addSubview:quesView];
        }else
        {
            for (int i = 0; i < 5; i++) {
                NSString * tempStr = [currentDisplayItems objectAtIndex:i];
                QuestionView * quesView = [[QuestionView alloc]initWithFrame:CGRectMake(320*(printOnPage+i), 0, 320, questionViewHeight)
                                                                   ItemIndex:(printOnPage+i)
                                                                   PaperType:[self paperType:(printOnPage+i)]
                                                                     isTitle:[self isExamTitle:(printOnPage+i)]];
                [quesView setBlock:[self buttonBlock]];
                [quesView.quesTextView loadHTMLString:tempStr baseURL:nil];
                
                [self.quesScrollView addSubview:quesView];
            }
            
        }
    }
    
}

-(void)removeTheOppositeQuestionViewWithDirection:(PanDirection)direction
{
#ifdef LogoutFunctionName
    NSLog(@"%s",__func__);
#endif

    NSArray *subViews = [self.quesScrollView subviews];
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
            NSInteger tempInt = criticalPage - nextPage;
            if (tempInt >1) {
                criticalPage = nextPage -1;
                NSLog(@"something wrong");
            }
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
   
    
    
    
//    CGFloat offsetX = scrollView.contentOffset.x;
//    //    NSLog(@"%f",offsetX);
//    CGFloat pageWidth = scrollView.frame.size.width;
//    float fractionalPage = scrollView.contentOffset.x / pageWidth;
//    NSInteger page = lround(fractionalPage);
//       if (page >2) {
//        currentPage = page;
//        criticalPage = page;
////        NSLog(@"当前页:%d",page);
//        NSInteger  offset = page*self.quesScrollView.frame.size.width;
////        NSLog(@"offsetX:%f",offsetX);
////        NSLog(@"offset:%d",offset);
////        NSLog(@"preOffset:%d",preOffsetX);
//        preOffsetX = criticalPage * 320;
//        if (offsetX >=offset&&isEndScrolling&&offsetX>preOffsetX) {
//            NSLog(@"*************下一页");
//            isEndScrolling = NO;
//            panDirectioin = PanDirectionRight;
//            [self refreshScrollViewWithDirection:panDirectioin];
//        }else if (offsetX < preOffsetX&&isEndScrolling){
//            NSLog(@"**************上一页");
//            isEndScrolling = NO;
//            panDirectioin = PanDirectionLeft;
//            [self refreshScrollViewWithDirection:panDirectioin];
//        }
//
//    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   isEndScrolling = YES;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
#ifdef LogoutFunctionName
    NSLog(@"%s",__func__);
#endif
    
//    isEndScrolling = YES;
}
- (IBAction)preQuestionAction:(id)sender {
    if (currentPage > 0) {
        currentPage --;
        [self.quesScrollView scrollRectToVisible:CGRectMake(currentPage *self.quesScrollView.frame.size.width, 0, 320, self.quesScrollView.frame.size.height) animated:YES];
        if (currentPage>2) {
            [self refreshScrollViewWithDirection:PanDirectionLeft];
        }
    }
}

- (IBAction)nextQuestionAction:(id)sender {
    if (currentPage <[questionStrArray count]) {
        currentPage ++;
        [self.quesScrollView scrollRectToVisible:CGRectMake(currentPage *self.quesScrollView.frame.size.width, 0, 320, self.quesScrollView.frame.size.height) animated:YES];
        if (currentPage>2) {
            [self refreshScrollViewWithDirection:PanDirectionRight];
        }
    
    }
}

- (IBAction)wrongTextBookAction:(id)sender {
    
    ExamPaperInfo * examQuestionInfo = [questionDataSource objectAtIndex:currentPage];
    if ([[examQuestionInfo valueForKey:@"IsRnd"]integerValue]!=0) {
        NSLog(@"%@",examQuestionInfo.title);
        
        ExamPaperInfoTimeStamp *info = [[ExamPaperInfoTimeStamp alloc] init];
        unsigned int varCount;
        Ivar *vars = class_copyIvarList([ExamPaperInfo class], &varCount);
        for (int i = 0; i < varCount; i++) {
            Ivar var = vars[i];
            const char* name = ivar_getName(var);
            NSString *valueKey = [NSString stringWithUTF8String:name];

            [info setValue:[examQuestionInfo valueForKey:valueKey] forKeyPath:valueKey];
        }
//        NSString* aStr;
//        aStr = [[NSString alloc] initWithData:[NSDate date] encoding:NSASCIIStringEncoding];
        
        NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString * timeStr = [dateFormat stringFromDate:[NSDate date]];
        info.timeStamp = timeStr;
        timeStr = nil;
        free(vars);

        
        [wrongExamPaperInfoArray addObject:info];
    }
    
    
}

-(void)endExamAction
{
    if ([countTimer isValid]) {
        [countTimer invalidate];
    }
    EndExamViewController * viewController = [[EndExamViewController alloc]initWithNibName:@"EndExamViewController" bundle:nil];
    NSInteger stopTimeStamp = examOriginTime - examTime;
    int minute = floor(stopTimeStamp / 60.0);
    int second = stopTimeStamp % 60;
    NSString * timeStr = [NSString stringWithFormat:@"%d分%d秒",minute,second];
    [viewController setTimeStamp:timeStr];
    [viewController setDataSourece:questionDataSource];
    [viewController setAnswerDic:answerDictionary];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController =nil;
    
}
@end

