//
//  HttpHelper.h
//  YouLeXue
//
//  Created by vedon on 8/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface HttpHelper : NSObject
//用户登陆验证
+(void)userLoginWithName:(NSString *)name pwd:(NSString *)password completedBlock:(void (^)(id item,NSError * error))block;


//读取某用户组的考试列表
+(void)getGroupExamListWithId:(NSString *)groupId completedBlock:(void (^)(id item,NSError * error))block;

//试卷题目列表
+(void)getExamPaperListWithExamId:(NSString *)examId completedBlock:(void (^)(id item,NSError * error))block;

//案例题目列表
+(void)getExampleListWithGroupId:(NSString *)groupId completedBlock:(void (^)(id item,NSError * error))block;

//读取其他信息
//说明：读取网站其他信息，包括如何成为手机版用户、忘记用户名和密码？、使用手机号登陆手机端?、上进版服务说明、版权和免责声明、关于信息
+(void)getOtherInformationCompletedBlock:(void (^)(id item,NSError * error))block;

//读取用户短消息
+(void)getUserMessageWithUserName:(NSString *)name
                   completedBlock:(void (^)(id item,NSError * error))block;

//更新用户个人信息
+(void)updateUserInfoWithUserId:(NSString *)userId
                       realName:(NSString *)realName
                          qqNum:(NSString *)qqNum
                         mobile:(NSString *)mobile
                          email:(NSString *)email
                 completedBlock:(void (^)(id item,NSError *error))block;



//*************************验证接口**********************************


//考试列表
//    [HttpHelper getGroupExamListWithId:@"42" completedBlock:^(id item, NSError *error) {
//    }];


//试卷题目列表
//    [HttpHelper getExamPaperListWithExamId:@"819" completedBlock:^(id item, NSError *error) {
//        ;
//    }];

//案例题目列表
//    [HttpHelper getExampleListWithGroupId:@"42" completedBlock:^(id item, NSError *error) {
//        ;
//    }];

//    [HttpHelper getOtherInformationCompletedBlock:^(id item, NSError *error) {
//        ;
//    }];


//读取用户短消息
//    [HttpHelper getUserMessageWithUserName:@"test" completedBlock:^(id item, NSError *error) {
//        ;
//    }];

//更新用户个人信息
//    [HttpHelper updateUserInfoWithUserId:@"735" realName:@"test" qqNum:@"123" mobile:@"123" email:@"32@qq.com" completedBlock:^(id item, NSError *error) {
//        ;
//    }];



+(void)printClassInfo:(NSObject *)info;
@end
