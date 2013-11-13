//
//  PaperViewController.m
//  YouLeXue
//
//  Created by vedon on 13/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

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
@interface PaperViewController ()
{
    NSArray * questTypes;
    
    //标志是否显示popTableview
    BOOL isShouldShowTable;
    CGRect originTableRect;
    
    //考试时间
    CGFloat examTime;
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
    QuestionView * quesView = [[QuestionView alloc]initWithFrame:CGRectMake(0, 0, 320, 250)];
    NSString * str = [NSString stringWithFormat:@"%@%@",[[questionDataSource objectAtIndex:1]valueForKey:@"title"],[[questionDataSource objectAtIndex:1]valueForKey:@"tmnr"]];
    [quesView.quesTextView loadHTMLString:str baseURL:nil];
    [self.quesScrollView addSubview:quesView];
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
//        self.popUpTable.frame=rect;
    }else
    {
        self.popUpTable.frame = originTableRect;
    }
}
@end
