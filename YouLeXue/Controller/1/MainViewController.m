//
//  MainViewController.m
//  YouLeXue
//
//  Created by vedon on 6/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserLoginInfo.h"
#import "AppDelegate.h"
#import "PersistentDataManager.h"
#import "HttpHelper.h"
#import "UIImage+SaveToLocal.h"


#define Ad1 @"http://www.55280.com//UploadFiles/2013/0/2013091210340360268.jpg"
#define Ad2 @"http://www.55280.com//UploadFiles/2013/0/2013091210504240285.jpg"
#define Ad3 @"http://www.55280.com/UploadFiles/2013/0/2013091210580477232.jpg"


@interface MainViewController ()
{
    UserLoginInfo * info;
    
    //保存下载的图片
    NSMutableArray *imageArray;
    NSInteger  count;
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"优乐学";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self animation];
    [self.afterLoginView setHidden:YES];
    [self updateInterface];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInterface) name:@"LogoutNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInterface) name:@"LoginNotification" object:nil];
    imageArray = [NSMutableArray array];
    
    
    //判断之前是否保存过图片
    NSArray * imageNameAry = @[@"Ad1",@"Ad2",@"Ad3"];
    for (NSString * str in imageNameAry) {
        UIImage * image = [UIImage readImageWithName:str];
        if (image) {
            [imageArray addObject:image];
        }
    }
    if ([imageArray count]==0) {
        [self downloadAdImage];
    }
    
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];

    self.backgroundImgeView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openAdUrl)];
    [self.backgroundImgeView addGestureRecognizer:tapGesture];
    tapGesture = nil;
    count = 0;

}

-(void)openAdUrl
{
    NSLog(@"image：%d",count);
    switch (count) {
            
        case 1:
            [self openURL:@"http://www.55280.com/Item/list.asp?id=1511"];
            //打开广告一的连接
            ;
            break;
        case 2:
            //打开广告二的连接
            [self openURL:@"http://www.55280.com/Item/list.asp?id=1511"];
            
            break;
        case 3:
            //打开广告三的连接
            [self openURL:@"http://www.55280.com/Item/list.asp?id=1511"];
            break;

        default:
            break;
    }
}

-(void)openURL:(NSString *)urlStr
{
   
    NSURL * url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)changeImage
{
    if ([imageArray count]) {
        if (count >= [imageArray count]) {
            count = 0;
        }
        for (int i = count;i<[imageArray count];i++) {
            UIImage *image = [imageArray objectAtIndex:i];
            [self.backgroundImgeView setImage:image];
            count ++;
            break;
        }
        
    }
}

-(void)downloadAdImage
{
    [HttpHelper getAdImageWithURL:Ad1 CompletedBlock:^(id item, NSError *error) {
        if (item) {
            UIImage * image = [[UIImage alloc]initWithData:item];
            [UIImage saveImage:image name:@"Ad1"];
            
            [imageArray addObject:image];
        }
    }];
    [HttpHelper getAdImageWithURL:Ad2 CompletedBlock:^(id item, NSError *error) {
        if (item) {
            UIImage * image = [[UIImage alloc]initWithData:item];
            [UIImage saveImage:image name:@"Ad2"];
            [imageArray addObject:image];
        }
    }];
    [HttpHelper getAdImageWithURL:Ad3 CompletedBlock:^(id item, NSError *error) {
        if (item) {
            UIImage * image = [[UIImage alloc]initWithData:item];
            [UIImage saveImage:image name:@"Ad3"];
            [imageArray addObject:image];
        }
    }];
}

-(void)updateInterface
{
    info = nil;
    NSArray * array = [[PersistentDataManager sharePersistenDataManager]readDataWithTableName:@"UserLoginInfoTable" withObjClass:[UserLoginInfo class]];
    if ([array count]) {
        info = [array objectAtIndex:0];
    }
    
    if (info) {
        [self.NotLoignLabel setHidden:YES];
        [self.afterLoginView setHidden:NO];
        
        NSDate * date = [self dateFromString:[info valueForKey:@"examTime"]];
        NSDate * currentDate = [NSDate date];
        
        NSInteger lastDate = [self daysWithinEraFromDate:currentDate toDate:date];
        
        if (lastDate <0) {
            lastDate = 0;
        }
        NSString * timeText = [NSString stringWithFormat:@"离考试时间还有%d天",lastDate];
        
        NSString * messageText = [NSString stringWithFormat:@"未读消息%@",[info valueForKey:@"MsgNum"]];
        self.countTimeLabel.text = timeText;
        self.messageCountLabel.text = messageText;
    }else
    {
        [self.afterLoginView setHidden:YES];
        [self.NotLoignLabel setHidden:NO];
    }

}


- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}

-(NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate
{

    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                        options:0];
    return components.day;
}

-(void)animation
{
    
    CABasicAnimation *translate1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    translate1.duration = 0.4;
    translate1.autoreverses = YES;
    translate1.repeatCount  = MAXFLOAT;
    translate1.removedOnCompletion = NO;
    translate1.fromValue   = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
    translate1.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(30, 0, 0)];
    [self.leftImage.layer addAnimation:translate1 forKey:@"shakeAnimation"];
    
    
    CABasicAnimation *translate2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    translate2.duration = 0.4;
    translate2.autoreverses = YES;
    translate2.repeatCount  = MAXFLOAT;
    translate2.removedOnCompletion = NO;
    translate2.fromValue   = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
    translate2.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-30, 0, 0)];
    [self.rightImage.layer addAnimation:translate2 forKey:@"shakeAnimation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tabImageName
{
	return @"Bottom_Icon_Home_Down";
}


- (void)viewDidUnload {
    [self setLeftImage:nil];
    [self setRightImage:nil];
    [self setAfterLoginView:nil];
    [self setCountTimeLabel:nil];
    [self setMessageCountLabel:nil];
    [self setNotLoignLabel:nil];
    [self setBackgroundImgeView:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
