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

@interface RightPhontNotiViewController ()
{
    NSMutableArray *dataSource;
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
    
//读取用户短消息
    AppDelegate * myDeleate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    __weak RightPhontNotiViewController * weakSelf= self;
    [HttpHelper getUserMessageWithUserName:[myDeleate.userInfo valueForKey:@"UserName"] completedBlock:^(id item, NSError *error) {
        dataSource = item;
        [weakSelf.phoneNotiTable reloadData];
    }];
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
