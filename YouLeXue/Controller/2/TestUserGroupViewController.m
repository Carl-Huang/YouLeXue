//
//  TestUserGroupViewController.m
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//
#define ContentScrollviewTag    2001
#define FirTableTag  4001
#define SecTableTag  4002
#define ThiTableTag  4003
#define FouTableTag  4004


#import "TestUserGroupViewController.h"
#import "SVPullToRefresh.h"
#import "AppDelegate.h"
#import "HttpHelper.h"
#import "UserLoginInfo.h"
#import "PersistentDataManager.h"
#import "ExamPaperInfo.h"
#import "ExamInfo.h"

@interface TestUserGroupViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger currentPage;
    NSInteger preOffsetX;
    UserLoginInfo * info;
    
    //各个tableview 对应的dataSource
    NSMutableArray * firstDataSource;
    NSMutableArray * secondDataSource;
    NSMutableArray * thirdDataSource;
    NSMutableArray * fourthDataSource;
}

@end

@implementation TestUserGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"测试用户组";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置这个页面，不能左右滑动。
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    info = myDelegate.userInfo;
    myDelegate.containerViewController.canPan = NO;
    
    //设置scrollview
    self.contentScrollview.frame = CGRectMake(0, 0,320, self.contentScrollview.frame.size.height);
    [self.contentScrollview addSubview:self.firstTable];
    [self.contentScrollview addSubview:self.secondTable];
    [self.contentScrollview addSubview:self.thirdTable];
    [self.contentScrollview addSubview:self.fourthTable];
    self.contentScrollview.showsHorizontalScrollIndicator = NO;
    [self.contentScrollview setContentSize:CGSizeMake(1290, 320)];
    self.contentScrollview.pagingEnabled = YES;
    self.contentScrollview.scrollEnabled = YES;
    self.contentScrollview.delegate = self;
    self.contentScrollview.tag = ContentScrollviewTag;
   
    
    //默认选中第一页
    currentPage = 1;
    [self.firstBtn setSelected:YES];
    [self settingPullRefreshAction];
    
    [self dataSourceSetting];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    myDelegate.containerViewController.canPan = YES;
}


-(void)dataSourceSetting
{
    
    //初始化datasource
    firstDataSource     = [NSMutableArray array];
    secondDataSource    = [NSMutableArray array];
    thirdDataSource     = [NSMutableArray array];
    fourthDataSource    = [NSMutableArray array];
    
    //试卷题目列表
    NSArray * array = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"PaperListTable" withObjClass:[ExamInfo class]];
    if ([array count]) {
        for (ExamInfo * examInfo in array) {
            NSLog(@"%@",examInfo.KS_leixing);
            if ([examInfo.KS_leixing isEqualToString:@"1"]) {
                [firstDataSource addObject:examInfo];
            }else if([examInfo.KS_leixing isEqualToString:@"2"])
            {
                [secondDataSource addObject:examInfo];
            }else if([examInfo.KS_leixing isEqualToString:@"3"])
            {
                [thirdDataSource addObject:examInfo];
            }else if([examInfo.KS_leixing isEqualToString:@"4"])
            {
                [fourthDataSource addObject:examInfo];
            }
        }
    }
    
    //    [HttpHelper getExamPaperListWithExamId: completedBlock:^(id item, NSError *error) {
    //        ;
    //    }];
    //
}

-(void)settingPullRefreshAction
{
    __weak UITableView *weakFirstTable = self.firstTable;
    self.firstTable.tag = FirTableTag;
    [self.firstTable addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        //执行下啦时候的操作
        [weakFirstTable.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
    
    
     __weak UITableView *weakSecondTable = self.secondTable;
    self.secondTable.tag = SecTableTag;
    [self.secondTable addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        [weakSecondTable.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
    
    __weak UITableView *weakThirdTable = self.thirdTable;
    self.thirdTable.tag = ThiTableTag;
    [self.thirdTable addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        [weakThirdTable.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
    
    __weak UITableView *weakFourthTable = self.fourthTable;
    self.fourthTable.tag = FouTableTag;
    [self.fourthTable addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        [weakFourthTable.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];

}

-(void)configureCell:(UITableViewCell *)cell withTable:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case FirTableTag:
        {
            ExamInfo * tempExamInfo = [firstDataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = [tempExamInfo valueForKey:@"title"];
            NSString * detailStr = [self getDetailDateStr:tempExamInfo];
            cell.detailTextLabel.text = detailStr;
        }
            break;
        case SecTableTag:
        {
            ExamInfo * tempExamInfo = [secondDataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = [tempExamInfo valueForKey:@"title"];
            NSString * detailStr = [self getDetailDateStr:tempExamInfo];
            cell.detailTextLabel.text = detailStr;
        }
            break;
        case ThiTableTag:
        {
            ExamInfo * tempExamInfo = [thirdDataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = [tempExamInfo valueForKey:@"title"];
            NSString * detailStr = [self getDetailDateStr:tempExamInfo];
            cell.detailTextLabel.text = detailStr;
        }

            break;
        case FouTableTag:
        {
            ExamInfo * tempExamInfo = [fourthDataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = [tempExamInfo valueForKey:@"title"];
            NSString * detailStr = [self getDetailDateStr:tempExamInfo];
            cell.detailTextLabel.text = detailStr;
        }

            break;
            
        default:
            break;
    }
}
-(NSString *)getDetailDateStr:(ExamInfo *)tempExamInfo
{
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString * dateStr = [tempExamInfo valueForKey:@"date"];
    NSDate *date = [self dateFromString:dateStr];
    NSString * time = [dateFormat stringFromDate:date];
    NSString * detailStr = [NSString stringWithFormat:@"发布:%@ 分值:%@ 时间:%@",time,[tempExamInfo valueForKey:@"kssj"],[tempExamInfo valueForKey:@"sjzf"]];
    return detailStr;
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)tabImageName
{
	return @"Bottom_Icon_Section_Down";
}
- (void)viewDidUnload {
    [self setFirstTable:nil];
    [self setSecondTable:nil];
    [self setThirdTable:nil];
    [self setFourthTable:nil];
    [self setContentScrollview:nil];
    [self setTopScrollview:nil];
    [self setFirstBtn:nil];
    [self setSecBtn:nil];
    [self setThirdBtn:nil];
    [self setFourthBtn:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (tableView.tag) {
        case FirTableTag:
            return [firstDataSource count];
            break;
        case SecTableTag:
            return [secondDataSource count];
            break;
        case ThiTableTag:
            return [thirdDataSource count];
            break;
        case FouTableTag:
            return [fourthDataSource count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.firstTable dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];

    [self configureCell:cell withTable:tableView indexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma  mark - UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX > 50) {
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage)+1;
        [self updateBtnStatusWithIndex:page];
    }
}



//更新btn的状态
-(void)updateBtnStatusWithIndex:(NSInteger)index
{
    switch (index) {
        case 1:
            [self.firstBtn setSelected:YES];
            [self.secBtn setSelected:NO];
            [self.thirdBtn setSelected:NO];
            [self.fourthBtn setSelected:NO];
            break;
        case 2:
            [self.firstBtn setSelected:NO];
            [self.secBtn setSelected:YES];
            [self.thirdBtn setSelected:NO];
            [self.fourthBtn setSelected:NO];
            break;
        case 3:
            [self.firstBtn setSelected:NO];
            [self.secBtn setSelected:NO];
            [self.thirdBtn setSelected:YES];
            [self.fourthBtn setSelected:NO];
            break;
        case 4:
            [self.firstBtn setSelected:NO];
            [self.secBtn setSelected:NO];
            [self.thirdBtn setSelected:NO];
            [self.fourthBtn setSelected:YES];
            break;

        default:
            break;
    }
    
}

#pragma mark - Button Action
- (IBAction)firstBtnAction:(id)sender {
    CGRect frame = self.contentScrollview.frame;
    frame.origin.x = frame.size.width * 0;
    frame.origin.y = 0;
    [self.contentScrollview scrollRectToVisible:frame animated:YES];
}

- (IBAction)secondBtnAction:(id)sender {
    CGRect frame = self.contentScrollview.frame;
    frame.origin.x = frame.size.width * 1;
    frame.origin.y = 0;
    [self.contentScrollview scrollRectToVisible:frame animated:YES];

}

- (IBAction)thirdBtnAction:(id)sender {
    CGRect frame = self.contentScrollview.frame;
    frame.origin.x = frame.size.width * 2;
    frame.origin.y = 0;
    [self.contentScrollview scrollRectToVisible:frame animated:YES];

}

- (IBAction)fourthBtnAction:(id)sender {
    CGRect frame = self.contentScrollview.frame;
    frame.origin.x = frame.size.width * 3;
    frame.origin.y = 0;
    [self.contentScrollview scrollRectToVisible:frame animated:YES];

}
@end
