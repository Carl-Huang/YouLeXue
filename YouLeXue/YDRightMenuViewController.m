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
#import "ExamInfo.h"
#import "UIImage+SaveToLocal.h"
#import "MBProgressHUD.h"
#import "SDWebImageManager.h"
#import "Constant.h"


@interface YDRightMenuViewController ()
{
    NSArray * descriptionArray;
    NSArray * dataSource;
    
    NSInteger dwonloadingImage;
    NSInteger downloadedImage;
    
    //downloader
    SDWebImageManager * manager;
    NSMutableDictionary * paper;
    BOOL isShouldDownExamPaper;
    NSInteger paperCount;
    
    BOOL isLogout;
}
@property (assign ,nonatomic) NSInteger downloadedPaperCount;

@end

@implementation YDRightMenuViewController
@synthesize userInfo;
@synthesize downloadedPaperCount;
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
    manager = [SDWebImageManager sharedManager];
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
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.userNameTextField.text = @"";
    self.passwordTextField.text = @"";
    
   
    [self refreshStatus];
    
    isShouldDownExamPaper = NO;
    paper = [NSMutableDictionary dictionary];
    paper = [[PersistentDataManager sharePersistenDataManager]readExamPaperToDic];
    if ([paper count]==0) {
        isShouldDownExamPaper = YES;
    }
    [self addObserver:self forKeyPath:@"downloadedPaperCount" options:NSKeyValueObservingOptionNew context:NULL];
    isLogout = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isUserLoginout) name:LogoutNotification object:nil];
}

-(void)isUserLoginout
{
    isLogout = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (!isLogout) {
        self.userInfo = nil;
        [self fillData];
        [self refreshStatus];
    }else
    {
        self.beforeLoginView.alpha = 1.0;
        self.userNameTextField.text = @"";
        self.passwordTextField.text = @"";
        [self.beforeLoginView setHidden:NO];
        [self.afterLoginView setHidden:YES];
        [self cleanInterface];
    }
}

-(void)fillData
{
    NSLog(@"%s",__func__);
    dataSource = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"OtherInformationTable" withObjClass:[FetchDataInfo class]];
    //下载连接中的图片
    for (FetchDataInfo *info in dataSource) {
        NSString * tempStr = info.ArticleContent;
        [self downloadImageWithImageURL:tempStr];
    }
    
    
    if ([dataSource count] == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            __weak YDRightMenuViewController *weakSelf = self;
            [HttpHelper getOtherInformationCompletedBlock:^(id item, NSError *error)
             {
                 if ([item count]) {
                     [[PersistentDataManager sharePersistenDataManager]createOtherInformationTable:(NSArray *)item];
                     dataSource = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"OtherInformationTable" withObjClass:[FetchDataInfo class]];
                     [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                     [weakSelf.rightTable reloadData];
                 }
                 if (error) {
                     [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                     NSLog(@"%@",error);
                 }
             }];
            
        });
    }
   
}
-(void)refreshStatus
{
    NSLog(@"%s",__func__);
    dispatch_async(dispatch_get_main_queue(), ^{
   
    NSArray *array = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"UserLoginInfoTable" withObjClass:[UserLoginInfo class]];
    if ([array count]) {
        //因为用户始终有一个，所以只读取第零个元素
        self.userInfo = (UserLoginInfo *)[array objectAtIndex:0];
    }
        if (userInfo) {
            [self.afterLoginView setHidden:NO];
            NSString * imageStr = [userInfo valueForKey:@"UserFace"];
            imageStr = [imageStr stringByReplacingOccurrencesOfString:@"3g" withString:@"www"];
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageStr] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30.0];
            __weak UIImageView *weakImageview = self.userImage;
            [self.userImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                [weakImageview setImage:image];
                [UIImage saveImage:image name:UserImageLocalDataName];
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

-(void)cleanInterface
{
    self.userImage = nil;
    self.userNamelabel.text = @"";
    self.userDesclabel.text = @"";
    self.userDetailDescLabel.text = @"";
}
- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
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
//    NSString * serverlUrl = [AppDelegate getServerAddress];
//    NSString * requireStr = [NSString stringWithFormat:@"%@/Item/list.asp?id=1518",serverlUrl];
    NSURL  *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",userInfo.vipurl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (url) {
        [[UIApplication sharedApplication]openURL:url];
    }else
    {
        [self showAlertView:@"指定URL 为空"];
    }

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
        NSString * str = [NSString stringWithFormat:@"%@",obj.KS_phoneSeq];
        if ([str isKindOfClass:[NSString class]]) {
            if (obj.KS_phoneSeq.integerValue == indexPath.row+1) {
                UIWebView * contentView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 280, 150)];
                [contentView stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 10.0;"];
         
                
                float scaleFactor = 0.8;
                contentView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
                
                
                
                NSString *tempStr = obj.ArticleContent;
                NSString * imageFolder = [UIImage getFolderName];
                NSString * imageUrl = [self getImageName:tempStr];
                NSURL *url =nil;
                NSString *descrption =nil;
                if (imageUrl) {
                    url = [NSURL fileURLWithPath:[imageFolder stringByAppendingPathComponent:imageUrl]];
                    NSString * replaceStr = [self getImageUrl:tempStr];
                    if (replaceStr) {
                        descrption = [tempStr stringByReplacingOccurrencesOfString:replaceStr withString:imageUrl];
                    }
                    [contentView loadHTMLString:descrption baseURL:url];
                }else
                {
                    [contentView loadHTMLString:obj.ArticleContent baseURL:nil];
                }
                
                contentView.backgroundColor = [UIColor clearColor];
//                contentView.scrollView.scrollEnabled = NO;
                contentView.scrollView.bounces = NO;
                [contentView setOpaque:NO];
                
                VDAlertView * alert = [[VDAlertView alloc]initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert setCustomSubview:contentView];
                [alert show];

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
//    if (textField.tag == UserNameTextFieldTag) {
//        [self.passwordTextField becomeFirstResponder];
//         return NO;
//    }
//    
    [self.passwordTextField resignFirstResponder];
    [self.userNameTextField resignFirstResponder];
    
    return  YES;
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
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    alert = nil;
}

-(void)saveDataTolocal
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    myDelegate.userInfo = userInfo;
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
    [[NSUserDefaults standardUserDefaults]setObject:self.passwordTextField.text forKey:PassWordKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak YDRightMenuViewController * weakSelf = self;
    
//    NSString * uuidStr = [[NSUserDefaults standardUserDefaults]stringForKey:@"AppMacAddress"];
    NSString * uuidStr = @"244:2A:60:B2:99:CE";
    if ([uuidStr length]) {
        [HttpHelper userLoginWithName:self.userNameTextField.text pwd:self.passwordTextField.text uuid:uuidStr completedBlock:^(id item, NSError *error) {
            if (item) {
                isLogout = NO;
                userInfo = (UserLoginInfo *)item;
                if ([userInfo.KS_IMEI isEqualToString:uuidStr]) {
                    [weakSelf saveDataTolocal];
                    [weakSelf refreshStatus];
                    [weakSelf.afterLoginView setHidden:NO];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginNotification" object:nil];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.beforeLoginView.alpha = 0.0;
                        weakSelf.afterLoginView.alpha = 1.0;
                        [weakSelf.beforeLoginView setHidden:YES];
                    }];
                }else
                {
                    [weakSelf showAlertView:@"验证失败"];
                }
                
            }
            [weakSelf removeMBView];
            if (error) {
                [weakSelf processingError:error];
            }
            
        }];
    }

}

-(void)processingError:(NSError *)error
{
    if ([[error domain]isEqualToString:@"LoginError"]) {
        NSString * errorDes = nil;
        switch (error.code) {
            case LoginStatusFailed:
                errorDes  = @"用户名或密码错误";
                break;
            case LoginStatusLock:
                errorDes = @"账号已被管理员锁定";
                break;
            case LoginStatusNotActive:
                errorDes = @"账号还没有激活";
                break;
            case LoginStatusNotVerify:
                errorDes = @"账号还没有通过认证";
                break;
            case LoginStatusUUID:
                errorDes = @"验证失败";
                break;
            default:
                break;
        }
        if ([errorDes length]) {
            [self showAlertView:errorDes];
        }
    
    }
    
    if ([[error domain] isEqualToString:@"NSURLErrorDomain"]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"与服务器连接失败，请检查" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        alertView = nil;
    }

}


-(void)removeMBView
{
    [MBProgressHUD  hideHUDForView:self.view animated:YES];
}

//手机通知
- (IBAction)phoneAlertBtnAction:(id)sender {
    
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    RightPhontNotiViewController * viewcontroller = [[RightPhontNotiViewController alloc]initWithNibName:@"RightPhontNotiViewController" bundle:nil];
    [myDelegate.containerViewController presentModalViewController:viewcontroller animated:YES];
    viewcontroller = nil;
}

- (IBAction)adviceBtnAction:(id)sender {
    NSString * str = [NSString stringWithFormat:@"http://www.55280.com/shoujijianyi.html/username=%@",[userInfo valueForKey:@"UserName"]];
    NSURL * url = [NSURL URLWithString:@"http://www.55280.com/3g/yijian.asp"];
     [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)reloadQuesBankAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    __weak YDRightMenuViewController * weakSelf =self;
    [HttpHelper getGroupExamListWithId:[userInfo valueForKey:@"GroupID"] completedBlock:^(id item, NSError *error) {
        if ([item count]) {
            //保存数据数据库
            self.downloadedPaperCount = [item count];
            paperCount = [item count];
//            NSString * desStr = [NSString stringWithFormat:@"已下载试卷%d",paperCount];
            NSArray * tempArr = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"PaperListTable" withObjClass:[ExamInfo class]];
            if ([tempArr count]==0) {
                [[PersistentDataManager sharePersistenDataManager]createPaperListTable:(NSArray *)item];
            }
        
            NSArray * arr = [[PersistentDataManager sharePersistenDataManager]readAlreadyMarkPaperTable];
            if ([arr count]==0) {
                [[PersistentDataManager sharePersistenDataManager]createAlreadyMarkPaperTable:item];
            }
//            if (isShouldDownExamPaper) {
//                for (ExamInfo * examInfo in item) {
//                    [self downPaperListWithExamInfo:examInfo];
//                }
//
//            }else
//            {
//                [weakSelf showVDAlertViewWithTitle:@"提示" message:desStr];
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            }
            for (ExamInfo * examInfo in item) {
                [self downPaperListWithExamInfo:examInfo];
            }
        }else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];

}

-(void)downPaperListWithExamInfo:(ExamInfo *)tempExamInfo
{
   
    [HttpHelper getExamPaperListWithExamId:[tempExamInfo valueForKey:@"id"] completedBlock:^(id item, NSError *error) {
        NSArray * arr = (NSArray *)item;
        self.downloadedPaperCount --;
        if([arr count])
        {
            [paper setObject:arr forKey:[tempExamInfo valueForKey:@"id"]];
        }
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpHelper getExampleListWithGroupId:[userInfo valueForKey:@"GroupID"] completedBlock:^(id item, NSError *error) {
        if ([item count]) {
            [[PersistentDataManager sharePersistenDataManager]createExampleListTable:(NSArray *)item];
            
            //创建标注的信息表
            NSArray * arr = [[PersistentDataManager sharePersistenDataManager]readAlreadyMarkCaseTable];
            if ([arr count]==0) {
                [[PersistentDataManager sharePersistenDataManager]createAlreadyMarkCaseTable:item];
            }

        }
        if (error) {
            NSLog(@"%@",[error description]);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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

- (IBAction)registerAction:(id)sender {
//    NSString * tempServerUrl = [AppDelegate getServerAddress];
    
//    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/3g/reg.asp",tempServerUrl]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.55280.com/3g/reg.asp"]];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"isShouldShowLoginView"]) {
        //登陆
        [self refreshStatus];
    }
    if ([keyPath isEqualToString:@"downloadedPaperCount"]) {
        NSLog(@"%d",self.downloadedPaperCount);
        if (self.downloadedPaperCount == 0) {
            //保存数据到数据库
            NSMutableArray * tempArray = [NSMutableArray array];
            NSArray *tempPaperArr = [paper allValues];
            [tempArray addObjectsFromArray:tempPaperArr];
            [[PersistentDataManager sharePersistenDataManager]createExamPaperTable:tempArray];
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [self showVDAlertViewWithTitle:@"提示" message:[NSString stringWithFormat:@"成功更新%d 套试卷",paperCount]];
        }
    }
}

#pragma mark - 提取图片url
-(NSString *)getImageUrl:(NSString *)searchStr
{
    NSError * error;
    NSRegularExpression * regex = [[NSRegularExpression alloc]initWithPattern:@"/\\S*\\d.jpg" options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
    NSArray * compomentArray =[regex matchesInString:searchStr options:NSMatchingReportProgress range:NSMakeRange(0, [searchStr length])];
    
    if ([compomentArray count]) {
        for (NSTextCheckingResult * checktStr in compomentArray) {
            NSRange range = [checktStr rangeAtIndex:0];
            return [searchStr substringWithRange:range];
        }
        return searchStr;
    }
    return  nil;
}

-(NSString *)getImageName:(NSString *)searchStr
{
    
    NSError * error;
    NSRegularExpression * regex = [[NSRegularExpression alloc]initWithPattern:@"\\d*.jpg" options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
    NSArray * compomentArray =[regex matchesInString:searchStr options:NSMatchingReportProgress range:NSMakeRange(0, [searchStr length])];
    
    for (NSTextCheckingResult * checktStr in compomentArray) {
        NSRange range = [checktStr rangeAtIndex:0];
        return [searchStr substringWithRange:range];
    }
    return nil;
}

-(void)downloadImageWithImageURL:(NSString *)imageurl
{
    __weak YDRightMenuViewController * weakSelf =self;
    if (imageurl) {
        NSString * imageName = [self getImageUrl:imageurl];
        if (imageName) {
            NSString *imageUrl = [ServerPrefix stringByAppendingString:[self getImageUrl:imageurl]];
            NSURL *url = [NSURL URLWithString:imageUrl];
            dwonloadingImage ++;
            [manager downloadWithURL:url options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
                ;
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                [UIImage saveImage:image name:[self getImageName:[url absoluteString]]];
                downloadedImage ++;
                [weakSelf isAllImageDownload];
            }];
        }
    }
}

-(void)isAllImageDownload
{
    if (downloadedImage ==downloadedImage) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

-(void)showVDAlertViewWithTitle:(NSString *)title message:(NSString *)msg
{
    VDAlertView * alertView = [[VDAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    UILabel * textLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 180, 30)];
    [textLabel1 setBackgroundColor:[UIColor clearColor]];
    textLabel1.font = [UIFont systemFontOfSize:16];
    textLabel1.textAlignment = NSTextAlignmentCenter;
    textLabel1.text = msg;
    
//    UILabel * textLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 200, 30)];
//    [textLabel2 setBackgroundColor:[UIColor clearColor]];
//    textLabel2.font = [UIFont systemFontOfSize:13];
//    textLabel2.text = @"客服热线：40086-55280";
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 100)];
    [bgView setBackgroundColor:[UIColor clearColor]];
    [bgView addSubview:textLabel1];
//    [bgView addSubview:textLabel2];
    textLabel1 = nil;
//    textLabel2 = nil;
    
    [alertView setCustomSubview:bgView];
    bgView =nil;
    [alertView show];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
