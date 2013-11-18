//
//  WrongBookViewController.m
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import "WrongBookViewController.h"
#import "PersistentDataManager.h"
#import "ExamPaperInfoTimeStamp.h"
#import "WrongTextBookView.h"
#import "SVPullToRefresh.h"
#import "WrongPaperViewController.h"

@interface WrongBookViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong ,nonatomic) NSArray * dataSource;
@end

@implementation WrongBookViewController
@synthesize dataSource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"错题本";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataSource = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"WrongTextBookTable" withObjClass:[ExamPaperInfoTimeStamp class]];
    __weak WrongBookViewController * weakSelf = self;
    [self.wrongBookTable addPullToRefreshWithActionHandler:^{
        [weakSelf pullToUpdate];
    }];
    // Do any additional setup after loading the view from its nib.
}

-(void)pullToUpdate
{
    if (![dataSource count]) {
         dataSource = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"WrongTextBookTable" withObjClass:[ExamPaperInfoTimeStamp class]];
        [self.wrongBookTable.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
        [self.wrongBookTable reloadData];
    }else
    {
        [self.wrongBookTable.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)tabImageName
{
	return @"Bottom_Icon_List_Down";
}

- (void)viewDidUnload {
    [self setWrongBookTable:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.wrongBookTable dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    ExamPaperInfoTimeStamp * info = [dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [info valueForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    

//    NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd"];
//    NSString * timeStr = [dateFormat stringFromDate:info.timeStamp];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"更新时间: %@",info.timeStamp];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WrongPaperViewController * viewcontroller = [[WrongPaperViewController alloc]initWithNibName:@"WrongPaperViewController" bundle:nil];
    [viewcontroller setQuestionDataSource:self.dataSource];
    [viewcontroller setDidSelectedindex:indexPath.row];
    [viewcontroller setTitleStr:@"错题本"];
    [self.navigationController pushViewController:viewcontroller animated:YES];
    viewcontroller = nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
@end
