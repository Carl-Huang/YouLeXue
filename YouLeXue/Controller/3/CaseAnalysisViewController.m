//
//  TestUserGroupViewController.m
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//
#define ContentScrollviewTag    2001
#import "CaseAnalysisViewController.h"
#import "SVPullToRefresh.h"
#import "AppDelegate.h"
@interface CaseAnalysisViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger currentPage;
    NSInteger preOffsetX;
}

@end

@implementation CaseAnalysisViewController

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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    myDelegate.containerViewController.canPan = YES;
}

-(void)settingPullRefreshAction
{
    __weak UITableView *weakFirstTable = self.firstTable;
    [self.firstTable addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        //执行下啦时候的操作
        
        [weakFirstTable.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
     __weak UITableView *weakSecondTable = self.secondTable;
    [self.secondTable addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        [weakSecondTable.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
    
         __weak UITableView *weakThirdTable = self.thirdTable;
    [self.thirdTable addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        [weakThirdTable.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
    
    __weak UITableView *weakFourthTable = self.fourthTable;
    [self.fourthTable addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        [weakFourthTable.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];

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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.firstTable dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    cell.textLabel.text = @"hello";
       
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma  mark - UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage)+1;
//    NSLog(@"%d",page);
     [self updateBtnStatusWithIndex:page];

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
