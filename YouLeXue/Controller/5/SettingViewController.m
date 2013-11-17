//
//  SettingViewController.m
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#define FontSize 14
#import "SettingViewController.h"
#import "AppDelegate.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *firSectionDataSource;
    
    //slider
    UILabel * sliderLabel;
    UISlider * slider;
    
    //
    NSString * regulationStr;
    
    //记录cell的选中状态
    NSMutableDictionary * checkItems;
}
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.settingTable.backgroundView = nil;
    checkItems = [NSMutableDictionary dictionary];
    firSectionDataSource = @[@"单选答题自动进入下一题",@"答错后手机震动",@"自动更新题目",@"移除错题规则"];
    for (int i =0; i<[firSectionDataSource count]-1; i++) {
        [checkItems setObject:@"NO" forKey:[NSNumber numberWithInt:i]];
    }
    
    //slider
    sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 35)];
    sliderLabel.text = @"亮度设置";
    sliderLabel.font = [UIFont systemFontOfSize:FontSize];
    slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 20, 280, 40)];
    [slider addTarget:self action:@selector(intensityControl:) forControlEvents:UIControlEventTouchUpInside];
    
    regulationStr = @"1";
    
    //设置这个页面，不能左右滑动。
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    myDelegate.containerViewController.canPan = NO;
}
-(void)viewDidDisappear:(BOOL)animated
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    myDelegate.containerViewController.canPan = YES;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tabImageName
{
	return @"Bottom_Icon_Settings_Down";
}
- (void)viewDidUnload {
    [self setSettingTable:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1) {
        return 60.0f;
    }
    return 45.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
            break;
        case 3:
            return 2;
            break;
            
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.settingTable dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    [self configureCell:cell withIndex:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row !=3) {
            if ([[checkItems objectForKey:[NSNumber numberWithInt:indexPath.row]] isEqual:@"No"]) {
                [checkItems setObject:@"Yes" forKey:[NSNumber numberWithInt:indexPath.row]];
            }else
                [checkItems setObject:@"No" forKey:[NSNumber numberWithInt:indexPath.row]];
        
        }
        [tableView reloadData];
    }
}




-(void)configureCell:(UITableViewCell *)cell withIndex:(NSIndexPath *)index
{
    NSArray * contentSubViews = [cell.contentView subviews];
    if ([contentSubViews count]) {
        [contentSubViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (index.section) {
        case 0:
        {
            cell.textLabel.text = [firSectionDataSource objectAtIndex:index.row];
            if (index.row ==3) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"连续答对%@次后自动从错题中删除",regulationStr];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else
            {
                if ([[checkItems objectForKey:[NSNumber numberWithInt:index.row]] isEqual:@"Yes"]) {
                    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checkmark"]];
                }else
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cross"]];

            }
        }
            break;
        case 1:
        {
            [cell.contentView addSubview:sliderLabel];
            [cell.contentView addSubview:slider];
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"服务器地址设置";
            cell.detailTextLabel.text = @"http://www.55280.com";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 3:
        {
            if (index.row ==0) {
                cell.textLabel.text = @"分享";
            }else
            {
                cell.textLabel.text = @"关于";
            }

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:FontSize];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:FontSize -2];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)intensityControl:(id)sender
{
    UISlider * tempSlider = (UISlider *)sender;
    NSLog(@"%f",tempSlider.value);
}
@end
