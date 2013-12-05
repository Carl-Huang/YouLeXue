//
//  RightPhontNotiViewController.m
//  YouLeXue
//
//  Created by vedon on 10/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import "RightPhontNotiViewController.h"
#import "UIViewController+TabbarConfigure.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
#import "FetchUserMessageInfo.h"
#import "DetailPhoneNotiViewController.h"
#import "MBProgressHUD.h"
#import "PersistentDataManager.h"
@interface RightPhontNotiViewController ()
{
    NSMutableArray *dataSource;
    NSArray * localMessageData;
    NSMutableArray * tempData;
    
    BOOL isFirstShow;
}
@end

@implementation RightPhontNotiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataSource = [NSMutableArray array];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    isFirstShow = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if (isFirstShow) {
        //读取本地短消息
        
        localMessageData = [[PersistentDataManager sharePersistenDataManager]readMessageTableData];
        
        //从网络读取数据
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AppDelegate * myDeleate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        __weak RightPhontNotiViewController * weakSelf= self;
        [HttpHelper getUserMessageWithUserName:[myDeleate.userInfo valueForKey:@"UserName"] completedBlock:^(id item, NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            tempData = item;
            
            [weakSelf eliminateRedundanceData];
            
        }];
        
    }else
    {
         localMessageData = [[PersistentDataManager sharePersistenDataManager]readMessageTableData];
        [self eliminateRedundanceData];
    }
}

-(void)eliminateRedundanceData
{
    //对比本地与网络数据，排除已经删除选项
    if (![localMessageData count]) {
        [[PersistentDataManager sharePersistenDataManager]createMessageTable:tempData];
        dataSource = tempData;
    }else
    {
        [dataSource removeAllObjects];
        for (FetchUserMessageInfo * obj in tempData) {
            for (FetchUserMessageInfo * tempObj in localMessageData) {
                NSString * objID = [NSString stringWithFormat:@"%@",[obj valueForKey:@"ID"]];
                NSString * tempObjID = [NSString stringWithFormat:@"%@",[tempObj valueForKey:@"ID"]];
                if ([objID isEqualToString:tempObjID]) {
                    if ([[tempObj valueForKey:@"isDelete"]integerValue] == 1) {
                       
                    }else
                    {
                        [dataSource addObject:obj];
                    }
                }
            }
        }
    }
    isFirstShow =  NO;
    [self.phoneNotiTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackItem:nil];
    [self setPhoneNotiTable:nil];
    [super viewDidUnload];
}
- (IBAction)backAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
    UITableViewCell *cell = [self.phoneNotiTable dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    FetchUserMessageInfo * info = [dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [info valueForKey:@"Title"];
    cell.detailTextLabel.text = [info valueForKey:@"Content"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FetchUserMessageInfo *info = [dataSource objectAtIndex:indexPath.row];
    DetailPhoneNotiViewController * viewcontroller = [[DetailPhoneNotiViewController alloc]initWithNibName:@"DetailPhoneNotiViewController" bundle:nil];
    [viewcontroller setInfo:info];
    [self presentModalViewController:viewcontroller animated:YES];
}
@end
