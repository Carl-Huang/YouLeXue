//
//  EndExamScoreViewController.m
//  YouLeXue
//
//  Created by vedon on 19/11/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import "EndExamScoreViewController.h"
#import "SubmittedPaperIndex.h"
#import <ShareSDK/ShareSDK.h>
#import "UIImage+SaveToLocal.h"
#import "AppDelegate.h"
#import "BrowsePaperViewController.h"
#import "PersistentDataManager.h"
#import "ExamInfo.h"
@interface EndExamScoreViewController ()

@end

@implementation EndExamScoreViewController
@synthesize dataSource;
@synthesize info;
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
    UIImage *image  = [UIImage readImageWithName:UserImageLocalDataName];
    if (image) {
        self.userImage.image = image;
    }
    self.scoreLabel.text = info.score;
    self.titleLabel.text = self.title;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@,您的本次考试成绩如下",    myDelegate.userInfo.UserName];
    self.descriptionLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.text = self.titleStr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserImage:nil];
    [self setDescriptionLabel:nil];
    [self setScoreLabel:nil];
    [self setPaperInfoTable:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}
- (IBAction)viewPaperAnswer:(id)sender {
    NSArray * array = [[PersistentDataManager sharePersistenDataManager]readEndExamTableData:info.uuid];
    NSArray * examInfoArray = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"PaperListTable" withObjClass:[ExamInfo class]];
    
    
    BrowsePaperViewController * viewcontroller = [[BrowsePaperViewController alloc]initWithNibName:@"BrowsePaperViewController" bundle:nil];
    [viewcontroller setQuestionDataSource:array];
    for (ExamInfo * examInfo in examInfoArray) {
        if ([[examInfo valueForKey:@"id"] isEqual:[[array objectAtIndex:0] valueForKey:@"kid"]]) {
            [viewcontroller setExamInfo:examInfo];
        }
    }
    [viewcontroller setIsExciseOrnot:NO];
    [viewcontroller setIsJustBrowse:YES];
    viewcontroller.title = info.paperTitleStr;
    [self presentModalViewController:viewcontroller animated:YES];
    viewcontroller = nil;

}

- (IBAction)ExamAgain:(id)sender {
    //重新考试
    NSArray * array = [[PersistentDataManager sharePersistenDataManager]readEndExamTableData:info.uuid];
    NSArray * examInfoArray = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"PaperListTable" withObjClass:[ExamInfo class]];
    
    
    BrowsePaperViewController * viewcontroller = [[BrowsePaperViewController alloc]initWithNibName:@"BrowsePaperViewController" bundle:nil];
    [viewcontroller setQuestionDataSource:array];
    for (ExamInfo * examInfo in examInfoArray) {
        if ([[examInfo valueForKey:@"id"] isEqual:[[array objectAtIndex:0] valueForKey:@"kid"]]) {
            [viewcontroller setExamInfo:examInfo];
        }
    }
    [viewcontroller setIsExciseOrnot:NO];
    [viewcontroller setIsJustBrowse:NO];
    [viewcontroller setTitleStr:info.paperTitleStr];
    [self presentModalViewController:viewcontroller animated:YES];
    viewcontroller = nil;

    
}

- (IBAction)shareExam:(id)sender {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];

}

- (IBAction)back:(id)sender {
 
    [self popModalsToRootFrom:self];
}

-(void)popModalsToRootFrom:(UIViewController*)aVc {
    if([aVc.presentingViewController isKindOfClass:[YDSlideMenuContainerViewController class]]) {
        [aVc.presentingViewController dismissModalViewControllerAnimated:NO];
        return;
    }else
    {
        [self popModalsToRootFrom:aVc.presentingViewController];  
    }

}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.PaperInfoTable dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];


    NSString * str = nil;
    if (indexPath.row == 0) {
        str = [NSString stringWithFormat:@"您的得分: %@",info.score];
    }else if (indexPath.row == 1)
    {
        str = [NSString stringWithFormat:@"试卷总分: %@",info.paperTotalScore];
    }else if (indexPath.row ==2)
    {
        str = [NSString stringWithFormat:@"您的时间: %@",info.useTime];
    }else if (indexPath.row ==3)
    {
        str = [NSString stringWithFormat:@"考卷时间: %@",info.totalExamTime];
    }
    cell.textLabel.text = str;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    [cell.imageView setImage:[UIImage imageNamed:@"User Settings_Icon_Point@2x"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView * headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"User Settings_Frame01"]];
    UILabel * description = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, 100, 30)];
    description.text = @"成绩单";
    description.textAlignment = NSTextAlignmentCenter;
    description.textColor = [UIColor whiteColor];
    description.font = [UIFont systemFontOfSize:16];
    [description setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:description];
    description = nil;
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIImageView * footerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"User Settings_Frame03"]];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
@end
