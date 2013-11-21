//
//  YDLeftMenuViewController.m
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import "YDLeftMenuViewController.h"
#import "PersistentDataManager.h"
#import "SVPullToRefresh.h"
#import "SubmittedPaperIndex.h"
#import "EndExamScoreViewController.h"
@interface YDLeftMenuViewController ()
@property (strong ,nonatomic) NSMutableArray * dataSource;
@end

@implementation YDLeftMenuViewController

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
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"User Settings_Frame02@2x"] forBarMetrics:UIBarMetricsDefault];
    
    if (IS_SCREEN_4_INCH) {
        CGRect rect = self.leftTable.frame;
        rect.size.height +=88;
        self.leftTable.frame = rect;
    }
    __weak YDLeftMenuViewController * weakSelf = self;
    [self.leftTable addPullToRefreshWithActionHandler:^{
        [weakSelf fillData];
    }];
    
    
    [self fillData];
    // Do any additional setup after loading the view from its nib.
}

-(void)fillData
{
    self.dataSource = [[[PersistentDataManager sharePersistenDataManager]readEndExamPaperIndexTable]mutableCopy];
    [self.leftTable.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    [self.leftTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftHistoryBtnAction:(id)sender {
    NSLog(@"%s",__func__);
}

- (IBAction)leftCleanHistoryAction:(id)sender {
    NSLog(@"%s",__func__);
    [self.dataSource removeAllObjects];
    [self.leftTable reloadData];
    if ([[PersistentDataManager sharePersistenDataManager]eraseTableData:@"EndExamPaperIndexTable"]) {
        NSLog(@"删除成功");
    }else
    {
        NSLog(@"删除失败");
    }
    
}
- (void)viewDidUnload {
    [self setLeftTable:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.leftTable dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    SubmittedPaperIndex * info = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [info valueForKey:@"paperTitleStr"];
    cell.detailTextLabel.text = [info valueForKey:@"timeStamp"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    [cell.imageView setImage:[UIImage imageNamed:@"Unfold_Left_Icon_Subject"]];
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubmittedPaperIndex * info = [self.dataSource objectAtIndex:indexPath.row];
    EndExamScoreViewController * viewcontroller = [[EndExamScoreViewController alloc]initWithNibName:@"EndExamScoreViewController" bundle:nil];
    viewcontroller.title = info.paperTitleStr;
    [viewcontroller setInfo:info];
    [self presentModalViewController:viewcontroller animated:YES];
//    [self.navigationController pushViewController:viewcontroller animated:YES];
    viewcontroller = nil;
}
@end
