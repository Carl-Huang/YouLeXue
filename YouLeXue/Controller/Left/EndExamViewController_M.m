//
//  EndExamViewController.m
//  YouLeXue
//
//  Created by vedon on 16/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import "EndExamViewController_M.h"
#import "UIViewController+TabbarConfigure.h"
#import "AppDelegate.h"
#import "ExamPaperInfo.h"
#import "VDAlertView.h"
@interface EndExamViewController_M ()<VDAlertViewDelegate>

@end

@implementation EndExamViewController_M
@synthesize timeStamp;
@synthesize answerSheetView;
@synthesize answerDic;

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
    
    //Interface Setting
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    myDelegate.containerViewController.canPan = NO;
//    [self setBackItem:@selector(back) withImage:@"Bottom_Icon_Back"];
//    [self setForwardItem:@selector(endExamAction) withImage:@"Exercise_Model_Button_Submit"];
    self.timeLabel.text = self.timeStamp;
    __block NSInteger alreadyAnswerQuesCount = 0;
    for (int i = 0; i<[[answerDic allValues]count]; i++) {
        NSString * str = [[answerDic allValues]objectAtIndex:i];
        if ([str length]) {
            alreadyAnswerQuesCount++;
        }
        
    }
    self.doneQuestionCount.text = [NSString stringWithFormat:@"已答%d题",alreadyAnswerQuesCount];
    
    
    //AnswerSheet
    NSInteger count = [self.dataSourece count];
    self.answerSheetView = [[AnswerSheetView alloc]initWithFrame:CGRectMake(10, 122, 310, (count/5.0)*AnswerSheetRowHeight)];
    [self.answerSheetView setBackgroundColor:[UIColor whiteColor]];
    self.answerSheetView.answerCount =count;
    [self.answerSheetView setAlreadyAnswerTitle:[self getAlreadyAnswerItems]];
    [self.answerSheetView setTitleDataSourece:[self getTitleWithDataSource]];
    [self.answerSheetView setBlock:[self configureAnswerSheetBlock]];
    
    //BackgroundScrollview
    [self.backgroundScrollView addSubview:self.answerSheetView];
    self.answerSheetView = nil;
    [self.backgroundScrollView setContentSize:CGSizeMake(320,  (count/5.0)*AnswerSheetRowHeight+300)];
    self.titleLabel.text = self.title;
}

-(void)viewDidDisappear:(BOOL)animated
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    myDelegate.containerViewController.canPan = YES;
}

-(NSArray *)getAlreadyAnswerItems
{
    NSMutableArray * tempArray = [NSMutableArray array];
    [answerDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isEqual:@""]) {
            [tempArray addObject:key];
        }
    }];
    return tempArray;
}

-(NSArray *)getTitleWithDataSource
{
    NSMutableArray * array = [NSMutableArray array];
    if ([self.dataSourece count]) {
        for (ExamPaperInfo * info in self.dataSourece) {
            NSString * tempTitle = nil;
            if ([[info valueForKey:@"IsRnd"]integerValue]==0) {
                NSInteger type = [[info valueForKey:@"num"]integerValue];
                switch (type) {
                    case 1:
                        tempTitle = @"一";
                        break;
                    case 2:
                        tempTitle = @"二";
                        break;
                    case 3:
                        tempTitle = @"三";
                        break;
                    case 4:
                        tempTitle = @"四";
                        break;
                    case 5:
                        tempTitle = @"五";
                        break;
                    case 6:
                        tempTitle = @"六";
                        break;
                    default:
                        break;
                }
                [array addObject:@{@"Title": tempTitle,@"IsTitle":@"yes"}];
            }else
            {
                tempTitle =[info valueForKey:@"num"];
                [array addObject:@{@"Title": tempTitle,@"IsTitle":@"no"}];
            }
        }

    }
    return array;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)endExamAction
{
    //交卷
//    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定交卷吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//    [alertview show];
//    alertview = nil;
    [self showVDAlertViewWithTitle:@"提示" message:@"确定交卷吗?"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTimeLabel:nil];
    [self setDoneQuestionCount:nil];
    [self setBackgroundScrollView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Block for the AnswerSheet
-(AnswerSheetBlock)configureAnswerSheetBlock
{
    __weak EndExamViewController_M *weakSelf = self;
    AnswerSheetBlock block = ^(NSInteger index)
    {
        self.block(index);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    return  block;
}

#pragma mark AlertView Deleaget
- (void)alertView:(VDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //交卷
        {
            self.endBlock();
            
        }
            break;
        case 1:
            //继续考试
            break;
        default:
            break;
    }
}


- (IBAction)continousExam:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitPaper:(id)sender {
    //交卷
//    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定交卷吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//    [alertview show];
//    alertview = nil;
    [self showVDAlertViewWithTitle:@"提示" message:@"确定交卷吗?"];
}

- (IBAction)modelViewBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)submitPaperAction:(id)sender {
//    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定交卷吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//    [alertview show];
//    alertview = nil;
        [self showVDAlertViewWithTitle:@"提示" message:@"确定交卷吗?"];
}

-(void)showVDAlertViewWithTitle:(NSString *)title message:(NSString *)msg
{
    VDAlertView * alertView = [[VDAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    
    UILabel * textLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 250, 30)];
    [textLabel1 setBackgroundColor:[UIColor clearColor]];
    textLabel1.font = [UIFont systemFontOfSize:16];
    textLabel1.textAlignment = NSTextAlignmentCenter;
    textLabel1.text = msg;
    
    //    UILabel * textLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 200, 30)];
    //    [textLabel2 setBackgroundColor:[UIColor clearColor]];
    //    textLabel2.font = [UIFont systemFontOfSize:13];
    //    textLabel2.text = @"客服热线：40086-55280";
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 100)];
    [bgView setBackgroundColor:[UIColor clearColor]];
    [bgView addSubview:textLabel1];
    //    [bgView addSubview:textLabel2];
    textLabel1 = nil;
    //    textLabel2 = nil;
    
    [alertView setCustomSubview:bgView];
    bgView =nil;
    alertView.delegate = self;
    [alertView show];
    alertView = nil;
}
@end
