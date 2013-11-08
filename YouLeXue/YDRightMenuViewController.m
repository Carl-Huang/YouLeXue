//
//  YDRightMenuViewController.m
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "YDRightMenuViewController.h"
#import "HttpHelper.h"
#import "UserLoginInfo.h"
@interface YDRightMenuViewController ()
{
    NSArray * descriptionArray;
    
}
@end

@implementation YDRightMenuViewController
@synthesize userInfo;

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
    [self.afterLoginView setHidden:YES];
    descriptionArray = @[@"如何成为手机版用户？",@"忘记了用户名或者密码怎么办？",@"使用手机号来登陆手机端？",@"上进版服务说明？",@"版权和免责声明！"];
    // Do any additional setup after loading the view from its nib.
    
    self.userNameImage.highlighted = YES;
    userInfo = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userCenterAction:(id)sender {
}

- (IBAction)upgrateVersionAction:(id)sender {
}
- (void)viewDidUnload {
    [self setRightTable:nil];
    [self setAfterLoginView:nil];
    [self setBeforeLoginView:nil];
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [self setUserNameImage:nil];
    [self setPasswordImage:nil];
    [self setUserImage:nil];
    [self setPhoneAlertBtnAction:nil];
    [self setUserNamelabel:nil];
    [self setUserDesclabel:nil];
    [self setUserDetailDescLabel:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [descriptionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.rightTable dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.textLabel.text = [descriptionArray objectAtIndex:indexPath.row];
    if ([descriptionArray count]-1 == indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:@"Unfold_Right_Button_Emphasise"];
    }else
    cell.imageView.image = [UIImage imageNamed:@"Unfold_Right_Button_Help"];
    
    cell.textLabel.font  = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (IBAction)loginAction:(id)sender {
//用户登录
//    [HttpHelper userLoginWithName:@"test" pwd:@"test" completedBlock:^(id item, NSError *error) {
//       userInfo = (UserLoginInfo *)item;
//        if (userInfo) {
//            [HttpHelper printClassInfo:userInfo];
//        }
//    }];
    
    
//考试列表
//    [HttpHelper getGroupExamListWithId:@"42" completedBlock:^(id item, NSError *error) {
//    }];
    
    
//试卷题目列表
//    [HttpHelper getExamPaperListWithExamId:@"819" completedBlock:^(id item, NSError *error) {
//        ;
//    }];
    
//案例题目列表    
    [HttpHelper getExampleListWithGroupId:@"42" completedBlock:^(id item, NSError *error) {
        ;
    }];
    
}
- (IBAction)phoneAlertBtnAction:(id)sender {
    
}

- (IBAction)adviceBtnAction:(id)sender {
    
}

- (IBAction)reloadQuesBankAction:(id)sender {
}

- (IBAction)userInfoAction:(id)sender {
}

- (IBAction)updatePaperAction:(id)sender {
}

- (IBAction)logoutAction:(id)sender {
}
@end
