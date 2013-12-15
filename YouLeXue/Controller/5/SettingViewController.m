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
#import "UserSetting.h"
#import <objc/runtime.h>
#import "PersistentDataManager.h"
#import "Constant.h"
#import "VDAlertView.h"
#import "WrongRuleViewController.h"
#import "MainViewController.h"
#import "PopUpWrongRuleViewController.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,VDAlertViewDelegate,UITextFieldDelegate>
{
    NSArray *firSectionDataSource;
    
    //slider
    UILabel * sliderLabel;
    UISlider * slider;
    
    //
    NSString * regulationStr;
    
    //记录cell的选中状态
    NSMutableDictionary * checkItems;
    
    //服务器修改地址框
    UIView * textFieldBg;
    UITextField * alterServerUrlTextField;
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
        [checkItems setObject:@"No" forKey:[NSNumber numberWithInt:i]];
    }
    
    //slider
    sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 35)];
    sliderLabel.text = @"亮度设置";
    [sliderLabel setBackgroundColor:[UIColor clearColor]];
    sliderLabel.font = [UIFont systemFontOfSize:FontSize];
    slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 20, 280, 40)];
    [slider addTarget:self action:@selector(intensityControl:) forControlEvents:UIControlEventTouchUpInside];
    regulationStr = @"1";
    
    //设置这个页面，不能左右滑动。
   
    
    //创建用户设置的表
    UserSetting * settingData =[[PersistentDataManager sharePersistenDataManager]readUserSettingData];
    if (settingData ==nil) {
        [[PersistentDataManager sharePersistenDataManager]createUserSettingTable];
    }else
    {
        
        if ([settingData.isAutoTurnPage isEqualToString:@"Yes"]) {
            [checkItems setObject:@"Yes" forKey:[NSNumber numberWithInt:0]];
        }else if ([settingData.isVibrateWhenClick isEqualToString:@"Yes"])
        {
            [checkItems setObject:@"Yes" forKey:[NSNumber numberWithInt:1]];
        }else if ([settingData.isAutoUpdatePaper isEqualToString:@"Yes"])
        {
            [checkItems setObject:@"Yes" forKey:[NSNumber numberWithInt:2]];
        }
   
    }
    textFieldBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
    [textFieldBg setBackgroundColor:[UIColor clearColor]];
    alterServerUrlTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 260, 35)];
    [alterServerUrlTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [alterServerUrlTextField setBackgroundColor:[UIColor clearColor]];
    alterServerUrlTextField.delegate = self;
    NSString * tempUrl = [AppDelegate getServerAddress];
    if (![tempUrl length]) {
         alterServerUrlTextField.text = @"http://www.55280.com";
    }else
    {
        alterServerUrlTextField.text = tempUrl;
    }
    
    [textFieldBg addSubview:alterServerUrlTextField];
}

-(void)viewDidAppear:(BOOL)animated
{
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

-(void)updateUserSettingTableWithKey:(NSString * )key Value:(NSString *)value
{
    [[PersistentDataManager sharePersistenDataManager]updateUserSettingTableWithkey:key value:value];
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
            return 1;
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
    if (indexPath.section ==0)
    {
        if (indexPath.row !=3) {
            [self configureCheckItemWithIndexPath:indexPath];
            switch (indexPath.row) {
                case 0:
                    [[NSUserDefaults standardUserDefaults]setObject:[checkItems objectForKey:[NSNumber numberWithInt:indexPath.row]] forKey:AutoNextQuestion];
                    break;
                case 1:
                    [[NSUserDefaults standardUserDefaults]setObject:[checkItems objectForKey:[NSNumber numberWithInt:indexPath.row]] forKey:VibrateWhenClick];
                    break;
                case 2:
                    [[NSUserDefaults standardUserDefaults]setObject:[checkItems objectForKey:[NSNumber numberWithInt:indexPath.row]] forKey:AutoUpdateQuestion];
                    break;
                default:
                    break;
            }
            [tableView reloadData];
        }else
        {
         
            PopUpWrongRuleViewController * viewController = [[PopUpWrongRuleViewController alloc]initWithNibName:@"PopUpWrongRuleViewController" bundle:nil];
            [viewController setBlock:[self didSelectedItemBlock]];
            [self.view addSubview:viewController.view];
            [self addChildViewController:viewController];
            viewController.view.alpha= 0.0;
            [UIView animateWithDuration:0.3 animations:^{
               viewController.view.alpha = 1.0;
            } completion:^(BOOL finished) {
    
            }];
            viewController = nil;
           
        }
        
    }else if (indexPath.section == 2)
    {
        VDAlertView * alert = [[VDAlertView alloc]initWithTitle:@"请输入" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        [alert setCustomSubview:textFieldBg];
        alert.delegate = self;
        [alert show];
    }else if (indexPath.section == 3)
    {
        if (indexPath.row == 0) {
            NSLog(@"%s",__func__);
            VDAlertView * alertView = [[VDAlertView alloc]initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];

//            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 10, 250, 80)];
//            [webView loadHTMLString:servicePersonInfo baseURL:nil];
            UILabel * textLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 200, 30)];
            [textLabel1 setBackgroundColor:[UIColor clearColor]];
            textLabel1.font = [UIFont systemFontOfSize:13];
            textLabel1.text = @"版权所有:优乐学网校";
            
            UILabel * textLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 200, 30)];
            [textLabel2 setBackgroundColor:[UIColor clearColor]];
            textLabel2.font = [UIFont systemFontOfSize:13];
            textLabel2.text = @"客服热线：40086-55280";
            
            UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 100)];
            [bgView setBackgroundColor:[UIColor clearColor]];
            [bgView addSubview:textLabel1];
            [bgView addSubview:textLabel2];
            textLabel1 = nil;
            textLabel2 = nil;
            
            [alertView setCustomSubview:bgView];
            bgView =nil;
            [alertView show];
        }
    }
}

-(DidSelectedItemBlock)didSelectedItemBlock
{
    DidSelectedItemBlock block = ^(NSInteger item)
    {
        NSLog(@"%d",item);
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",item] forKey:WrongTextRuleTime];
        [[NSUserDefaults standardUserDefaults]synchronize];
    };
    return block;
}


-(void)configureCheckItemWithIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = [checkItems objectForKey:[NSNumber numberWithInt:indexPath.row]];
    if ([str isEqualToString:@"No"]) {
        [checkItems setObject:@"Yes" forKey:[NSNumber numberWithInt:indexPath.row]];
    }else
        [checkItems setObject:@"No" forKey:[NSNumber numberWithInt:indexPath.row]];
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
                    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Setting_Icon_Check@2x"]];
                    [self updateUserSettingTableWithKey:[self updateUserTableWithIndex:index.row] Value:@"Yes"];
                }else
                {
                    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Setting_Icon_UnCheck@2x"]];
                    [self updateUserSettingTableWithKey:[self updateUserTableWithIndex:index.row] Value:@"No"];
                }
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
            if ([alterServerUrlTextField.text length]) {
                cell.detailTextLabel.text = alterServerUrlTextField.text;
            }else
            {
                cell.detailTextLabel.text = @"http://www55280.com";
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 3:
        {
//            if (index.row ==0) {
//                cell.textLabel.text = @"分享";
//            }else
//            {
//                cell.textLabel.text = @"关于";
//            }
            cell.textLabel.text = @"关于";
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

-(NSString *)updateUserTableWithIndex:(NSInteger)index
{
    NSString * tempKey = nil;
    switch (index) {
        case 0:
            tempKey = @"isAutoTurnPage";
            break;
        case 1:
            tempKey = @"isVibrateWhenClick";
            break;
        case 2:
            tempKey = @"isAutoUpdatePaper";
            break;
        default:
            break;
    }
    return tempKey;
}

-(void)intensityControl:(id)sender
{
    UISlider * tempSlider = (UISlider *)sender;
    [[NSUserDefaults standardUserDefaults]setFloat:tempSlider.value forKey:@"APP_BRIGHTNESS"];
    [UIScreen mainScreen].brightness = tempSlider.value;
    NSLog(@"%f",tempSlider.value);
}

#pragma mark - VDAlertView delegate
-(void)alertView:(VDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //修改服务器地址
            NSString * serverUrl = alterServerUrlTextField.text;
            [[NSUserDefaults standardUserDefaults]setObject:serverUrl forKey:ServerURLKey];
            [[NSUserDefaults standardUserDefaults]synchronize];

            [self.settingTable reloadData];
            

        }
            break;
        case 1:
            ;
            break;
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
