//
//  YDRightMenuViewController.m
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#define LoginSuccess                0
#define AccountInfoError            1 //用户名或密码有误
#define AccountIsLocked             2 //账号已被管理员锁定
#define AccountNotActive            3 //账号还没有激活
#define AccountNotAuthentication    4 //账号还没有通过认证

#define UserNameTextFieldTag 1001
#define PassWordTextFieldTag 1002
#import "YDRightMenuViewController.h"
#import "HttpHelper.h"
#import "UserLoginInfo.h"
#import "PersistentDataManager.h"
#import "UIImageView+AFNetworking.h"
#import "RightPhontNotiViewController.h"
#import "UserInfoViewController.h"
#import "AppDelegate.h"
#import "FetchDataInfo.h"
#import "VDAlertView.h"
@interface YDRightMenuViewController ()
{
    NSArray * descriptionArray;
    NSArray * dataSource;
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
    
    //屏幕适配
    if (IS_SCREEN_4_INCH) {
        CGRect rect1 = self.rightTable.frame;
        rect1.size.height +=44;
        self.rightTable.frame = rect1;
        
        CGRect rect2 = self.bottomView.frame;
        rect2.origin.y += 44;
        rect2.size.height +=44;
        self.bottomView.frame = rect2;
    }
    
    UIButton * leftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"Unfold_Right_Button_Student_Center"] forState:UIControlStateNormal];
    
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    [self.afterLoginView setHidden:YES];
    [self.beforeLoginView setHidden:YES];
    descriptionArray = @[@"如何成为手机版用户？",@"忘记了用户名或者密码怎么办？",@"使用手机号来登陆手机端？",@"上进版服务说明？",@"版权和免责声明！"];

    self.userNameTextField.tag = UserNameTextFieldTag;
    self.passwordTextField.tag = PassWordTextFieldTag;
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.userNameTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.userNameTextField.text = @"";
    self.passwordTextField.text = @"";
    
    [self fillData];
    [self refreshStatus];
    

}

-(void)fillData
{
    dataSource = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"OtherInformationTable" withObjClass:[FetchDataInfo class]];
    
    if ([dataSource count] == 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            __weak YDRightMenuViewController *weakSelf = self;
            [HttpHelper getOtherInformationCompletedBlock:^(id item, NSError *error)
             {
                 if ([item count]) {
                     [[PersistentDataManager sharePersistenDataManager]createOtherInformationTable:(NSArray *)item];
                     dataSource  = item;
                     [weakSelf.rightTable reloadData];
                 }
                 if (error) {
                     NSLog(@"%@",error);
                 }
             }];
            
        });
    }
   
}
-(void)refreshStatus
{
    dispatch_async(dispatch_get_main_queue(), ^{
   
        NSArray *array = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"UserLoginInfoTable" withObjClass:[UserLoginInfo class]];
        //因为用户始终有一个，所以只读取第零个元素
        if ([array count]) {
            self.userInfo = [array objectAtIndex:0];
            [self.afterLoginView setHidden:NO];
            NSString * imageStr = [userInfo valueForKey:@"UserFace"];
            imageStr = [imageStr stringByReplacingOccurrencesOfString:@"3g" withString:@"www"];
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageStr] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30.0];
            __weak UIImageView *weakImageview = self.userImage;
            [self.userImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                [weakImageview setImage:image];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                ;
            }];
            
            //用户名
            self.userNamelabel.text = [userInfo valueForKey:@"RealName"];
            
            
            //判断证件的有效期
            NSString * beginData = [userInfo valueForKey:@"BeginDate"];
            NSDate * beginDate = [self dateFromString:beginData];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyyMMdd"];
            
            NSString * validateDays = [userInfo valueForKey:@"EDays"];
            int daysToAdd = [validateDays integerValue];
            NSDate *newDate1 = [beginDate dateByAddingTimeInterval:60*60*24*daysToAdd];
            
            NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
            fmt.dateStyle = kCFDateFormatterLongStyle;
            fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            NSString* dateString = [fmt stringFromDate:newDate1];
            
            self.userDetailDescLabel.text = [NSString stringWithFormat:@"软件有效期：%@",dateString];
            self.userDesclabel.text = [NSString stringWithFormat:@"你报考的专业是：%@",[userInfo valueForKey:@"GroupName"]];
        }else
        {
            self.userInfo  = nil;
            [self.beforeLoginView setHidden:NO];
        }

    });
}


- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
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
    [self setBottomView:nil];
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
    for (FetchDataInfo * obj in dataSource) {
        
        if ([obj.KS_phoneSeq isKindOfClass:[NSString class]]) {
            if (obj.KS_phoneSeq.integerValue == indexPath.row+1) {
                UIWebView * contentView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 280, 150)];
                [contentView loadHTMLString:obj.ArticleContent baseURL:nil];
                contentView.backgroundColor = [UIColor clearColor];
//                contentView.scrollView.scrollEnabled = NO;
                contentView.scrollView.bounces = NO;
                [contentView setOpaque:NO];
                
                VDAlertView * alert = [[VDAlertView alloc]initWithTitle:@"hell" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert setCustomSubview:contentView];
                [alert show];

//                NSLog(@"%@",obj.ArticleContent);
            }
        }
    }
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == UserNameTextFieldTag) {
        self.userNameImage.highlighted = YES;
        self.passwordImage.highlighted = NO;
    }else if (textField.tag == PassWordTextFieldTag)
    {
        self.userNameImage.highlighted = NO;
        self.passwordImage.highlighted = YES;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == UserNameTextFieldTag) {
        [self.passwordTextField becomeFirstResponder];
         return NO;
    }
    [self.userNameTextField resignFirstResponder];
    return  YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if ([string isEqualToString:@"\n" ]) {
        [self.passwordTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)showAlertView:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    alert = nil;
}

-(void)saveDataTolocal
{
    [[PersistentDataManager sharePersistenDataManager]createUserLoginInfoTable:userInfo];
}
- (IBAction)loginAction:(id)sender {
//用户登录
    [self.passwordTextField resignFirstResponder];
    [self.userNameTextField resignFirstResponder];
    if (self.userNameTextField.text.length == 0) {
        [self showAlertView:@"用户名不能为空"];
        
    }
    if (self.passwordTextField.text.length == 0) {
        [self showAlertView:@"密码不能为空"];
    }
    __weak YDRightMenuViewController * weakSelf = self;
    [HttpHelper userLoginWithName:self.userNameTextField.text pwd:self.passwordTextField.text completedBlock:^(id item, NSError *error) {
        if (item) {
            userInfo = (UserLoginInfo *)item;
            [weakSelf saveDataTolocal];
            [weakSelf refreshStatus];
            [weakSelf.afterLoginView setHidden:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginNotification" object:nil];
            
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.beforeLoginView.alpha = 0.0;
                weakSelf.afterLoginView.alpha = 1.0;
                [weakSelf.beforeLoginView setHidden:YES];
            }];
            
        }
       
    }];
    
    
}
- (IBAction)phoneAlertBtnAction:(id)sender {
    
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    RightPhontNotiViewController * viewcontroller = [[RightPhontNotiViewController alloc]initWithNibName:@"RightPhontNotiViewController" bundle:nil];
    [myDelegate.containerViewController presentModalViewController:viewcontroller animated:YES];
    viewcontroller = nil;
}

- (IBAction)adviceBtnAction:(id)sender {
    NSString * str = [NSString stringWithFormat:@"http://www.55280.com/shoujijianyi.html/username=%@",[userInfo valueForKey:@"UserName"]];
    NSURL * url = [NSURL URLWithString:str];
     [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)reloadQuesBankAction:(id)sender {
    [HttpHelper getGroupExamListWithId:[userInfo valueForKey:@"GroupID"] completedBlock:^(id item, NSError *error) {

        //保存数据数据库
        [[PersistentDataManager sharePersistenDataManager]createPaperListTable:(NSArray *)item];
        
        //TODO:创建标注的信息表
        
    }];

}

- (IBAction)userInfoAction:(id)sender {
    UserInfoViewController * viewcontroller = [[UserInfoViewController alloc]initWithNibName:@"UserInfoViewController" bundle:nil];
    [viewcontroller addObserver:self forKeyPath:@"isShouldShowLoginView" options:NSKeyValueObservingOptionNew context:NULL];
    viewcontroller.proxy =self;
    [self presentModalViewController:viewcontroller animated:YES];
    viewcontroller = nil;
}

- (IBAction)updatePaperAction:(id)sender {
//案例题目列表
    [HttpHelper getExampleListWithGroupId:[userInfo valueForKey:@"GroupID"] completedBlock:^(id item, NSError *error) {
        if ([item count]) {
            [[PersistentDataManager sharePersistenDataManager]createExampleListTable:(NSArray *)item];
        }
        if (error) {
            NSLog(@"%@",[error description]);
        }
    }];

}

- (IBAction)logoutAction:(id)sender {
    [[PersistentDataManager sharePersistenDataManager]deleteRecordWithPrimaryKey:@"UserID" keyValue:[userInfo valueForKey:@"UserID"] tableName:@"UserLoginInfoTable"];
    self.userInfo = nil;
    AppDelegate * myDeleate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    myDeleate.userInfo = nil;

    [[NSNotificationCenter defaultCenter]postNotificationName:@"LogoutNotification" object:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.afterLoginView.alpha = 0.1;
        self.beforeLoginView.alpha = 1.0;
    }];
    [self.afterLoginView setHidden:YES];
    [self.beforeLoginView setHidden:NO];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"isShouldShowLoginView"]) {
        //登陆
        [self refreshStatus];
    }
}
@end
