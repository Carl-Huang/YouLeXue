//
//  UserInfoViewController.m
//  YouLeXue
//
//  Created by vedon on 10/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//
#define TableViewOffsetY 50;

#import "UserInfoViewController.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "HttpHelper.h"
#import "PersistentDataManager.h"
#import "UserLoginInfo.h"
#import "PersistentDataManager.h"
#import "Constant.h"
#import "VDAlertView.h"
#import "MBProgressHUD.h"
@interface UserInfoViewController ()<UITableViewDelegate,UITextFieldDelegate>
{
    AppDelegate * myDelegate;
    BOOL isEditingTableView;
    UITextField * userNameTextField;
    UITextField * qqTextField;
    UITextField * mobileTextField;
    UITextField * emailTextField;
    
    
    //用户登陆消息
    UserLoginInfo * loginInfo;
}
@end

@implementation UserInfoViewController
@synthesize isShouldShowLoginView;

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
    myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    NSString * imageStr = [myDelegate.userInfo valueForKey:@"UserFace"];
    imageStr = [imageStr stringByReplacingOccurrencesOfString:@"3g" withString:@"www"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageStr] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30.0];
    __weak UIImageView *weakImageview = self.userImage;
    [self.userImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakImageview setImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        ;
    }];
    [self.backScrollView setContentSize:CGSizeMake(320, 700)];
    
    [self.alertUserInfo setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alterUserInfoAction)];
    [self.alertUserInfo addGestureRecognizer:tapGesture1];
    tapGesture1 = nil;
    
    [self.logoutAction setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logout)];
    [self.logoutAction addGestureRecognizer:tapGesture2];
    tapGesture2 = nil;
    
    [self.myService setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myServiceAction)];
    [self.myService addGestureRecognizer:tapGesture3];
    tapGesture3 = nil;

    isEditingTableView=  NO;
    [self configureTextField];
    
   
    NSArray *array = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"UserLoginInfoTable" withObjClass:[UserLoginInfo class]];
    if ([array count]) {
        //因为用户始终有一个，所以只读取第零个元素
         loginInfo = (UserLoginInfo *)[array objectAtIndex:0];
    }else
    {
        loginInfo = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserInfoTable:nil];
    [self setDescriptionLabel:nil];
    [self setUserImage:nil];
    [self setBackScrollView:nil];
    [self setAlertUserInfo:nil];
    [self setLogoutAction:nil];
    [self setMyService:nil];
    [self setBtnBackGround:nil];
    [super viewDidUnload];
}
-(void)cancelAlter
{
    [self.btnBackGround setHidden:NO];
    self.btnBackGround.alpha = 0.1;
    CGRect rect = self.userInfoTable.frame;
    rect.size.height -=TableViewOffsetY;
    [UIView animateWithDuration:0.3 animations:^{
        self.userInfoTable.frame = rect;
        self.btnBackGround.alpha = 1.0;
    }];
    isEditingTableView = NO;
    [self.userInfoTable reloadData];
    
}

-(void)confirmAlter
{
    //更新用户个人信息
    __weak UserInfoViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpHelper updateUserInfoWithUserId:[loginInfo valueForKey:@"UserID"] realName:userNameTextField.text qqNum:qqTextField.text mobile:mobileTextField.text email:emailTextField.text completedBlock:^(id item, NSError *error) {
        if ([item isEqualToString:@"1"]) {
            NSLog(@"更新成功");
            [weakSelf reloadUserInfo];
        }
        
        if (error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSLog(@"%@",[error description]);
        }
    }];
    [self.btnBackGround setHidden:NO];
    self.btnBackGround.alpha = 0.1;
    CGRect rect = self.userInfoTable.frame;
    rect.size.height -=TableViewOffsetY;
    [UIView animateWithDuration:0.3 animations:^{
        self.userInfoTable.frame = rect;
        self.btnBackGround.alpha = 1.0;
    }];
    isEditingTableView = NO;
    [self.userInfoTable reloadData];
}

-(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

-(void)reloadUserInfo
{
    NSString *passwordStr = [[NSUserDefaults standardUserDefaults]stringForKey:PassWordKey];

    [HttpHelper userLoginWithName:[loginInfo valueForKey:@"UserName"] pwd:passwordStr completedBlock:^(id item, NSError *error) {
        if (item) {
            if ([[item valueForKey:@"UserName"] length]) {
                loginInfo = item;
                [[PersistentDataManager sharePersistenDataManager]createUserLoginInfoTable:loginInfo];
                [self.userInfoTable reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }
        if (error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[error domain] isEqualToString:@"NSURLErrorDomain"]) {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"与服务器连接失败，请检查" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                alertView = nil;
            }
        }
        
    }];
}

-(void)alterUserInfoAction
{
    NSLog(@"%s",__func__);
    CGRect rect = self.userInfoTable.frame;
    rect.size.height +=TableViewOffsetY;
    [UIView animateWithDuration:0.3 animations:^{
        self.userInfoTable.frame = rect;
        self.btnBackGround.alpha = 0.0;
        [self.btnBackGround setHidden:YES];
    }];
    
    isEditingTableView = YES;
    [self.userInfoTable reloadData];
}

-(void)logout
{
    NSLog(@"%s",__func__);
    NSString * str = [myDelegate.userInfo valueForKey:@"UserID"];
    [[PersistentDataManager sharePersistenDataManager]deleteRecordWithPrimaryKey:@"UserID" keyValue:[myDelegate.userInfo valueForKey:@"UserID"] tableName:@"UserLoginInfoTable"];
    self.isShouldShowLoginView = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:LogoutNotification object:nil];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)myServiceAction
{
    NSLog(@"%s",__func__);
    VDAlertView * alertView = [[VDAlertView alloc]initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    NSString * servicePersonInfo = [loginInfo valueForKey:@"KS_kefu"];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 10, 250, 80)];
    [webView loadHTMLString:servicePersonInfo baseURL:nil];
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 100)];
    [bgView setBackgroundColor:[UIColor clearColor]];
    [bgView addSubview:webView];
    webView = nil;
    
    [alertView setCustomSubview:bgView];
    bgView =nil;
    [alertView show];
    
}

-(void)cleanSubViewInCell:(UITableViewCell *)cell
{
    NSArray * arr =  cell.contentView.subviews;
    if ([arr count]) {
        [arr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

-(void)configureTextField
{
    mobileTextField = [[UITextField alloc]initWithFrame:CGRectMake(125, 5, 130, 25)];
    userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(125, 5, 130, 25)];
    qqTextField = [[UITextField alloc]initWithFrame:CGRectMake(125, 5, 130, 25)];
    emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(125, 5, 130, 25)];
    
    mobileTextField.font = [UIFont systemFontOfSize:14];
    userNameTextField.font = [UIFont systemFontOfSize:14];
    qqTextField.font = [UIFont systemFontOfSize:14];
    emailTextField.font = [UIFont systemFontOfSize:14];
    
    [mobileTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [userNameTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [qqTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [emailTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    [mobileTextField setHidden:!isEditingTableView];
    [userNameTextField setHidden:!isEditingTableView];
    [qqTextField setHidden:!isEditingTableView];
    [emailTextField setHidden: !isEditingTableView];
    
    mobileTextField.delegate = self;
    userNameTextField.delegate = self;
    qqTextField.delegate = self;
    emailTextField.delegate = self;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isEditingTableView) {
        return 8;
    }
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.userInfoTable dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
   
    [self cleanSubViewInCell:cell];
    cell = [self configureCellInterface:cell withIndex:indexPath];
    
    return cell;
}

-(UITableViewCell *)configureCellInterface:(UITableViewCell *)cell withIndex:(NSIndexPath*)indexPath
{
    UILabel * descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 120, 25)];
    UILabel * detailDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 5, 130, 25)];
    if (indexPath.row == 0) {
        detailDescriptionLabel.text = [loginInfo valueForKey:@"UserName"];
        descriptionLabel.text = [NSString stringWithFormat:@"用户名: "];
        [cell.contentView addSubview:detailDescriptionLabel];
    }else if(indexPath.row == 1)
    {
        NSString *str = [loginInfo valueForKey:@"RealName"];
        detailDescriptionLabel.text = str;
        descriptionLabel.text =[NSString stringWithFormat:@"姓名: "];
        if (!isEditingTableView) {
            [cell.contentView addSubview:detailDescriptionLabel];
        }else
        {
            userNameTextField.text = str;
            [userNameTextField setHidden:!isEditingTableView];
            [cell.contentView addSubview:userNameTextField];
        }
    }else if(indexPath.row == 2)
    {
        detailDescriptionLabel.text = [loginInfo valueForKey:@"GroupName"];
        descriptionLabel.text = [NSString stringWithFormat:@"报考专业: "];
        [cell.contentView addSubview:detailDescriptionLabel];
    }else if(indexPath.row == 3)
    {
        NSString * beginData = [loginInfo valueForKey:@"BeginDate"];
        if ([beginData length]) {
            beginData = [beginData stringByReplacingOccurrencesOfString:@"-" withString:@""];
            beginData = [beginData substringToIndex:8];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyyMMdd"];
            NSDate *date = [dateFormat dateFromString:beginData];
            NSString * validateDays = [loginInfo valueForKey:@"EDays"];
            int daysToAdd = [validateDays integerValue];
            NSDate *newDate1 = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
            NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
            fmt.dateStyle = kCFDateFormatterLongStyle;
            fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            NSString* dateString = [fmt stringFromDate:newDate1];
            detailDescriptionLabel.text = dateString;
            descriptionLabel.text = [NSString stringWithFormat:@"有效期: "];
            [cell.contentView addSubview:detailDescriptionLabel];
        }
        
       
    }else if(indexPath.row == 4)
    {
        NSString *str = [loginInfo valueForKey:@"QQ"];
        detailDescriptionLabel.text = str;
        descriptionLabel.text = [NSString stringWithFormat:@"QQ: "];
        if (!isEditingTableView) {
            [cell.contentView addSubview:detailDescriptionLabel];
        }else
        {
            qqTextField.text = str;
            [qqTextField setHidden:!isEditingTableView];
            [cell.contentView addSubview:qqTextField];
        }
    }else if(indexPath.row == 5)
    {
        NSString * str = [loginInfo valueForKey:@"Mobile"];
        detailDescriptionLabel.text = str;
        descriptionLabel.text = [NSString stringWithFormat:@"联系电话或手机: "];
        if (!isEditingTableView) {
            [cell.contentView addSubview:detailDescriptionLabel];
        }else
        {
            mobileTextField.text = str;
            [mobileTextField setHidden:!isEditingTableView];
            [cell.contentView addSubview:mobileTextField];
        }
    }else if(indexPath.row == 6)
    {
        NSString * str = [loginInfo valueForKey:@"Email"];
        detailDescriptionLabel.text = [loginInfo valueForKey:@"Email"];
        descriptionLabel.text = [NSString stringWithFormat:@"电子邮箱: "];
        if (!isEditingTableView) {
            [cell.contentView addSubview:detailDescriptionLabel];
        }else
        {
            emailTextField.text = str;
            [emailTextField setHidden:!isEditingTableView];
            [cell.contentView addSubview:emailTextField];
        }
    }else if(indexPath.row == 7)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 273, 35)];
        UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"User_Edit_Button_Confirm"] forState:UIControlStateNormal];
        
        [sureBtn addTarget:self action:@selector(confirmAlter) forControlEvents:UIControlEventTouchUpInside];
        [sureBtn setFrame:CGRectMake(30, 5, 100, 30)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"User Edit_Button_Cancel"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelAlter) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setFrame:CGRectMake(150, 5, 100, 30)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [view addSubview:sureBtn];
        [view addSubview:cancelBtn];
        sureBtn = nil;
        cancelBtn = nil;
        [cell.contentView addSubview:view];
        view = nil;
    }
    
    if (indexPath.row !=7) {
        descriptionLabel.textAlignment = NSTextAlignmentRight;
        descriptionLabel.font = [UIFont systemFontOfSize:14];
        detailDescriptionLabel.textAlignment = NSTextAlignmentLeft;
        detailDescriptionLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:descriptionLabel];
        cell.imageView.image = [UIImage imageNamed:@"User Settings_Icon_Point"];
        descriptionLabel = nil;
        detailDescriptionLabel = nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 8) {
        return 50.0f;
    }else
        return 35.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView * headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"User Settings_Frame01"]];
    UILabel * description = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, 100, 30)];
    description.text = @"您的资料";
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
- (IBAction)backAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)dealloc
{
    [self removeObserver:self.proxy forKeyPath:@"isShouldShowLoginView"];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect  rect = self.backScrollView.frame;
    if ([textField isEqual:emailTextField]) {
        
        rect.origin.y +=160;
        [self.backScrollView scrollRectToVisible:rect animated:YES];
    }else if([textField isEqual:mobileTextField])
    {
        rect.origin.y +=120;
        [self.backScrollView scrollRectToVisible:rect animated:YES];
    }else if ([textField isEqual:qqTextField])
    {
        rect.origin.y += 90;
        [self.backScrollView scrollRectToVisible:rect animated:YES];
        
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return  NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length]) {
        [textField resignFirstResponder];
    }
    return YES;
}
@end
