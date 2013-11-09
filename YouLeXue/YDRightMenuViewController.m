//
//  YDRightMenuViewController.m
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
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
    
    
    userInfo = nil;
    
    
    self.userNameTextField.tag = UserNameTextFieldTag;
    self.passwordTextField.tag = PassWordTextFieldTag;
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.userNameTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.userNameTextField.text = @"";
    self.passwordTextField.text = @"";
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
//    __weak YDRightMenuViewController * weakSelf = self;
//    [HttpHelper userLoginWithName:self.userNameTextField.text pwd:self.passwordTextField.text completedBlock:^(id item, NSError *error) {
//        if (item) {
//            userInfo = (UserLoginInfo *)item;
//            [weakSelf saveDataTolocal];
//        }
////        if (userInfo) {
////            [HttpHelper printClassInfo:userInfo];
////            
////        }
//    }];
    [[PersistentDataManager sharePersistenDataManager]readDataWithPrimaryKey:@"UserID" keyValue:@"735" withTableName:@"UserLoginInfoTable" withObj:[UserLoginInfo class]];;
    
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
