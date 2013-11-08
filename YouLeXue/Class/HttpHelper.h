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


+(void)printClassInfo:(NSObject *)info;
@end
