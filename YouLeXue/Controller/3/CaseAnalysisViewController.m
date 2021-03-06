//
//  TestUserGroupViewController.m
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//
#define FirTableTag  5001
#define SecTableTag  5002
#define ThiTableTag  5003
#define FouTableTag  5004


#define ContentScrollviewTag    2001
#import "CaseAnalysisViewController.h"
#import "SVPullToRefresh.h"
#import "AppDelegate.h"
#import "ExamplePaperInfo.h"
#import "HttpHelper.h"
#import "UserLoginInfo.h"
#import "PersistentDataManager.h"
#import "SelectedPaperPopupView.h"
#import "CasePaperViewController.h"
static NSString *identifier = @"Cell";
@interface CaseAnalysisViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger currentPage;
    NSInteger preOffsetX;
    UserLoginInfo * info;
    
    //各个tableview 对应的dataSource
    NSMutableArray * firstDataSource;
    NSMutableArray * secondDataSource;
    NSMutableArray * thirdDataSource;
    NSMutableArray * fourthDataSource;
    
    //试卷id 对应的试卷信息
    NSMutableDictionary * paper;
    
    //标志哪个cell被选择
    NSInteger selectedRow1;
    NSInteger selectedRow2;
    NSInteger selectedRow3;
    NSInteger selectedRow4;
    
    NSInteger preSelectedRow1;
    NSInteger preSelectedRow2;
    NSInteger preSelectedRow3;
    NSInteger preSelectedRow4;
    
    BOOL isShouldDownExamPaper;
    
    
    //current reload tableview
    UITableView * currentTableview;
    
    //保存标注信息的数组
    NSMutableArray * markArray;
    
    //保存全部信息的数组
    NSMutableArray * totalDataVector;
}
@property (assign,nonatomic)NSInteger downloadedPaperCount; //记录需要下载的试卷数目
@end

@implementation CaseAnalysisViewController
@synthesize downloadedPaperCount;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"案例分析";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置这个页面，不能左右滑动。
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
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
    [self dataSourceSetting];
    [self settingPullRefreshAction];
    
    
    
    //标记选中的项
    selectedRow1 = -1;
    selectedRow2 = -1;
    selectedRow3 = -1;
    selectedRow4 = -1;
    preSelectedRow1 = -1;
    preSelectedRow2 = -1;
    preSelectedRow3 = -1;
    preSelectedRow4 = -1;
    
    [self addObserver:self forKeyPath:@"downloadedPaperCount" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadUserInfo) name:@"LoginNotification" object:nil];
    
    AppDelegate * myDeleate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    info = myDeleate.userInfo;
}


-(void)reloadUserInfo
{
    NSArray * array = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"UserLoginInfoTable" withObjClass:[UserLoginInfo class]];
    if ([array count]) {
        info = [array objectAtIndex:0];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    //
    isShouldDownExamPaper = NO;
    paper = [NSMutableDictionary dictionary];
    paper = [[PersistentDataManager sharePersistenDataManager]readExamPaperToDic];
    if ([paper count]==0) {
        isShouldDownExamPaper = YES;
    }

    
    NSArray * array = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"UserLoginInfoTable" withObjClass:[UserLoginInfo class]];
    if ([array count]) {
        info = [array objectAtIndex:0];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"downloadedPaperCount"]) {
        NSLog(@"%d",self.downloadedPaperCount);
        if (downloadedPaperCount == 0) {
            //保存数据到数据库
            NSMutableArray * tempArray = [NSMutableArray array];
            NSArray *tempPaperArr = [paper allValues];
            [tempArray addObjectsFromArray:tempPaperArr];
            __weak CaseAnalysisViewController * weakSelf = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[PersistentDataManager sharePersistenDataManager]createExamPaperTable:tempArray];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [weakSelf stopReloadData];
                });
            });
        }
    }
}
-(void)stopReloadData
{
    [currentTableview.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
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
    [self fillData];
}

-(void)fillData
{
    NSArray * array = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"ExampleListTable" withObjClass:[ExamplePaperInfo class]];
    totalDataVector = [NSMutableArray arrayWithArray:array];
    if ([array count]) {
        [self cleanDataSource];
        for (ExamplePaperInfo * examInfo in array) {
            downloadedPaperCount = [array count];
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
    
}

-(void)cleanDataSource
{
    [firstDataSource removeAllObjects];
    [secondDataSource removeAllObjects];
    [thirdDataSource removeAllObjects];
    [fourthDataSource removeAllObjects];
}



//-(void)downPaperListWithExamInfo:(ExamplePaperInfo *)tempExamInfo
//{
//    if (isShouldDownExamPaper) {
//        [HttpHelper getExamPaperListWithExamId:[tempExamInfo valueForKey:@"id"] completedBlock:^(id item, NSError *error) {
//            NSArray * arr = (NSArray *)item;
//            
//            if([arr count])
//            {
//                [paper setObject:arr forKey:[tempExamInfo valueForKey:@"id"]];
//                self.downloadedPaperCount --;
//            }
//        }];
//        
//    }
//}

-(void)settingPullRefreshAction
{
    __weak CaseAnalysisViewController *weakSelf = self;
    
    __weak UITableView *weakFirstTable = self.firstTable;
    self.firstTable.tag = FirTableTag;
    [self.firstTable addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        //执行下啦时候的操作
        [weakSelf pullToUpdateWithTable:weakFirstTable];
    }];
    
    
    __weak UITableView *weakSecondTable = self.secondTable;
    self.secondTable.tag = SecTableTag;
    [self.secondTable addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        [weakSelf pullToUpdateWithTable:weakSecondTable];
    }];
    
    __weak UITableView *weakThirdTable = self.thirdTable;
    self.thirdTable.tag = ThiTableTag;
    [self.thirdTable addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        [weakSelf pullToUpdateWithTable:weakThirdTable];
    }];
    
    __weak UITableView *weakFourthTable = self.fourthTable;
    self.fourthTable.tag = FouTableTag;
    [self.fourthTable addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        [weakSelf pullToUpdateWithTable:weakFourthTable];
    }];
    
}

-(void)pullToUpdateWithTable:(UITableView *)tableview
{
    __weak CaseAnalysisViewController *weakSelf = self;
    if (info) {
   
        [HttpHelper getExampleListWithGroupId:[info valueForKey:@"GroupID"] completedBlock:^(id item, NSError *error) {
            if ([item count]) {
                [[PersistentDataManager sharePersistenDataManager]createExampleListTable:(NSArray *)item];
                [tableview.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
                
                //创建标注的信息表
                NSArray * arr = [[PersistentDataManager sharePersistenDataManager]readAlreadyMarkCaseTable];
                if ([arr count]==0) {
                    [[PersistentDataManager sharePersistenDataManager]createAlreadyMarkCaseTable:item];
                }

                
                [weakSelf fillData];
            }else
            {
                [tableview.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
            }
            if (error) {
                NSLog(@"%@",[error description]);
            }
            [weakSelf reloadAllTable];
        }];
    }else
    {
        UIAlertView * alerview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerview show];
        alerview = nil;
        [tableview.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }
    
}

-(void)reloadAllTable
{
    [self.firstTable reloadData];
    [self.secondTable reloadData];
    [self.thirdTable reloadData];
    [self.fourthTable reloadData];
}

-(void)configureCell:(UITableViewCell *)cell withTable:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (tableView.tag) {
        case FirTableTag:
        {
            ExamplePaperInfo * tempInfo = [firstDataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = [tempInfo valueForKey:@"Title"];
            NSString * detailStr = [self getDetailDateStr:tempInfo];
            cell.detailTextLabel.text = detailStr;
            [self configureSpecificRowPopViewWithRow:selectedRow1 preSelectedRow:&preSelectedRow1 Cell:cell indexPath:indexPath];
            [self setMarkOrNot:cell info:tempInfo];
            
        }
            break;
        case SecTableTag:
        {
            ExamplePaperInfo * tempInfo = [secondDataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = [tempInfo valueForKey:@"Title"];
            NSString * detailStr = [self getDetailDateStr:tempInfo];
            cell.detailTextLabel.text = detailStr;
            [self configureSpecificRowPopViewWithRow:selectedRow2 preSelectedRow:&preSelectedRow2 Cell:cell indexPath:indexPath];
            [self setMarkOrNot:cell info:tempInfo];
        }
            
            break;
        case ThiTableTag:
        {
            ExamplePaperInfo * tempInfo = [thirdDataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = [tempInfo valueForKey:@"Title"];
            NSString * detailStr = [self getDetailDateStr:tempInfo];
            cell.detailTextLabel.text = detailStr;
            [self configureSpecificRowPopViewWithRow:selectedRow3 preSelectedRow:&preSelectedRow3 Cell:cell indexPath:indexPath];
        }
            
            break;
        case FouTableTag:
        {
            ExamplePaperInfo * tempInfo = [fourthDataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = [tempInfo valueForKey:@"Title"];
            NSString * detailStr = [self getDetailDateStr:tempInfo];
            cell.detailTextLabel.text = detailStr;
        }
            break;
            
        default:
            break;
    }
    
}

-(void)setMarkOrNot:(UITableViewCell *)cell  info:(ExamplePaperInfo *)tempExamInfo
{
    if (markArray) {
        markArray =nil;
    }
    markArray = [[[PersistentDataManager sharePersistenDataManager]readAlreadyMarkCaseTable]mutableCopy];
    [markArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * dic = (NSDictionary *)obj;
        NSString *tempId = dic[@"ID"];
        if ([tempId isEqualToString:[tempExamInfo valueForKey:@"ID"]]) {
            if ([dic[@"isSelected"]isEqualToString:@"Yes"]) {
                cell.textLabel.textColor = [UIColor orangeColor];
                cell.detailTextLabel.textColor = [UIColor orangeColor];
                
            }else
            {
                cell.textLabel.textColor = [UIColor blackColor];
                cell.detailTextLabel.textColor = [UIColor blackColor];
                
            }
        }
    }];
}

-(void)markPaperActionWithDataSource:(NSArray *)dataSource row:(NSInteger)selectedRow
{
    __weak CaseAnalysisViewController * weakSelf = self;
    //对应的试卷信息
    ExamplePaperInfo * selectedInfo = [dataSource objectAtIndex:selectedRow];
    [markArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * dic = (NSDictionary *)obj;
        NSString *tempId = dic[@"ID"];
        if ([tempId isEqualToString:[selectedInfo valueForKey:@"ID"]]) {
            if ([dic[@"isSelected"]isEqualToString:@"Yes"]) {
                [[PersistentDataManager sharePersistenDataManager]updateAlreadyMarkCaseTableWithKey:[selectedInfo valueForKey:@"ID"] value:@"No"];
            }else
            {
                [[PersistentDataManager sharePersistenDataManager]updateAlreadyMarkCaseTableWithKey:[selectedInfo valueForKey:@"ID"] value:@"Yes"];
            }
            
        }
        if (stop) {
            [weakSelf reloadAllTable];
        }
    }];
    
}

-(NSString *)getDetailDateStr:(ExamplePaperInfo *)tempExamInfo
{
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString * dateStr = [tempExamInfo valueForKey:@"AddDate"];
    NSDate *date = [self dateFromString:dateStr];
    NSString * time = [dateFormat stringFromDate:date];
    NSString * detailStr = [NSString stringWithFormat:@"发布:%@ ",time];
    return detailStr;
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}
-(void)configureSpecificRowPopViewWithRow:(NSInteger)selectedRow preSelectedRow:(NSInteger *)preSelectedRow Cell:(UITableViewCell *)cell indexPath:(NSIndexPath*)indexPath
{
    if (selectedRow == indexPath.row&&selectedRow !=*preSelectedRow) {
        *preSelectedRow = indexPath.row;
        NSLog(@"do somethinghere");
        __block SelectedPaperPopupView * popView = [[SelectedPaperPopupView alloc]initWithFrame:CGRectMake(70, 0, 250, 40) withBtnImage1:nil btnImage2:nil btnImage3:nil text1:@"查看题干" test2:@"查看答案" test3:@"标注案例"];
        [popView setExamBlock:[self configureExamModelBlock]];
        [popView setPracticeBlock:[self configurePracticeModelBlock]];
        [popView setMarkBlock:[self configureMarkModelBlock]];
        popView.alpha = 0.1;
        [UIView animateWithDuration:0.3 animations:^{
            popView.alpha = 1.0;
            [cell.contentView addSubview:popView];
            popView = nil;
        }];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else
    {
        NSArray * subviewAry = cell.contentView.subviews;
        for (UIView * view in subviewAry) {
            if ([view isKindOfClass:[SelectedPaperPopupView class]]) {
                *preSelectedRow =-1;
                [UIView animateWithDuration:0.3 animations:^{
                    view.alpha = 0.1;
                    [view removeFromSuperview];
                }];
                
            }
        }
    }
}

#pragma mark - SelectedPopView Block
-(ExamModelBlock )configureExamModelBlock
{
    ExamModelBlock  block = ^()
    {
        switch (currentPage) {
            case 1:
            {
                [self viewControllerActionWithDataSource:firstDataSource row:selectedRow1 exciseOrNot:NO];
            }
                break;
            case 2:
            {
                [self viewControllerActionWithDataSource:secondDataSource row:selectedRow2 exciseOrNot:NO];
            }
                break;
            case 3:
            {
                [self viewControllerActionWithDataSource:thirdDataSource row:selectedRow3 exciseOrNot:NO];
            }
                break;
            case 4:
            {
                [self viewControllerActionWithDataSource:fourthDataSource row:selectedRow4 exciseOrNot:NO];
            }
                break;
            default:
                break;
        }
        NSLog(@"%s",__func__);
    };
    return  block;
}


-(PracticeModelBlock )configurePracticeModelBlock
{
    PracticeModelBlock  block = ^()
    {
        NSLog(@"%s",__func__);
    };
    return  block;
}

-(MarkModelBlock )configureMarkModelBlock
{
    MarkModelBlock  block = ^()
    {
        switch (currentPage) {
            case 1:
            {
                [self markPaperActionWithDataSource:firstDataSource row:selectedRow1];
            }
                break;
            case 2:
            {
                [self markPaperActionWithDataSource:secondDataSource row:selectedRow2];
            }
                break;
            case 3:
            {
                [self markPaperActionWithDataSource:thirdDataSource row:selectedRow3];
            }
                break;
            case 4:
            {
                [self markPaperActionWithDataSource:thirdDataSource row:selectedRow4];
            }
                break;
            default:
                break;
        }
        NSLog(@"%s",__func__);
    };
    return  block;
}

-(void)viewControllerActionWithDataSource:(NSArray *)dataSource row:(NSInteger)seletedRow exciseOrNot:(BOOL)exciseOrnot
{
    //对应的试卷信息
//    ExamplePaperInfo * selectedInfo = [dataSource objectAtIndex:seletedRow];
//    
//    //根据id 拿出相应的试卷
//    NSArray * paperList = [paper objectForKey:[selectedInfo valueForKey:@"ID"]];
    
    if (1) {
        CasePaperViewController * viewcontroller = [[CasePaperViewController alloc]initWithNibName:@"CasePaperViewController" bundle:nil];
        [viewcontroller setCaseDataSource:totalDataVector];
//        [viewcontroller setExamInfo:selectedInfo];
//        [viewcontroller setIsExciseOrnot:exciseOrnot];
        viewcontroller.title = @"题目标题";
        [self.navigationController pushViewController:viewcontroller animated:YES];
        viewcontroller = nil;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)tabImageName
{
	return @"Bottom_Icon_Case_Down";
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    
    
    [self configureCell:cell withTable:tableView indexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (tableView.tag) {
        case FirTableTag:
            selectedRow1 = indexPath.row;
            break;
        case SecTableTag:
            selectedRow2 = indexPath.row;
            break;
        case ThiTableTag:
            selectedRow3 = indexPath.row;
            break;
        case FouTableTag:
            selectedRow4 = indexPath.row;
            break;
        default:
            break;
    }
    //    selectedRow = tableView.indexPathForSelectedRow.row;
    [tableView reloadData];
    
}

#pragma  mark - UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX > 50) {
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage)+1;
        currentPage = page;
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

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"downloadedPaperCount"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
