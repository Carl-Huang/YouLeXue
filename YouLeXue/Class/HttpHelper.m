//
//  HttpHelper.m
//  YouLeXue
//
//  Created by vedon on 8/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "HttpHelper.h"
#import "Constant.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UserLoginInfo.h"
#import "ExamInfo.h"
#import "ExamPaperInfo.h"
#import "ExamplePaperInfo.h"
@implementation HttpHelper
+(void)userLoginWithName:(NSString *)name pwd:(NSString *)password completedBlock:(void (^)(id item,NSError * error))block
{
    NSString * cmdStr = [NSString stringWithFormat:@"CheckUserLogin.asp?username=%@&password=%@",name,password];
    cmdStr = [Server_URL stringByAppendingString:cmdStr];

     AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[cmdStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject count]) {
            UserLoginInfo * info = [HttpHelper mapModelProcess:responseObject withClass:[UserLoginInfo class]];
            block(info,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
   
}

+(void)getGroupExamListWithId:(NSString *)groupId completedBlock:(void (^)(id item,NSError * error))block
{
    NSString * cmdStr = [NSString stringWithFormat:@"exam/search.asp?groupid=%@",groupId];
    cmdStr = [Server_URL stringByAppendingString:cmdStr];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[cmdStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject count]) {
            NSArray * tempArray = [HttpHelper mapModelArrProcess:responseObject withClass:[ExamInfo class]];
            block(tempArray,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];

}

+(void)getExamPaperListWithExamId:(NSString *)examId completedBlock:(void (^)(id item,NSError * error))block
{
    NSString * cmdStr = [NSString stringWithFormat:@"exam/question.asp?examId=%@",examId];
    cmdStr = [Server_URL stringByAppendingString:cmdStr];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[cmdStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject count]) {
            NSArray * tempArray = [HttpHelper mapModelArrProcess:responseObject withClass:[ExamPaperInfo class]];
            block(tempArray,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

+(void)getExampleListWithGroupId:(NSString *)groupId completedBlock:(void (^)(id item,NSError * error))block
{
    NSString * cmdStr = [NSString stringWithFormat:@"case.asp?KS_leixing=1&groupid%@",groupId];
    cmdStr = [Server_URL stringByAppendingString:cmdStr];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[cmdStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject count]) {
            NSArray * tempArray = [HttpHelper mapModelArrProcess:responseObject withClass:[ExamplePaperInfo class]];
            block(tempArray,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];

}

+(void)getOtherInformationCompletedBlock:(void (^)(id item,NSError * error))block
{
    
}


//将取得的内容转换为模型
+ (id )mapModelProcess:(id)responseObject withClass:(Class)class
{
    //判断返回值
    NSDictionary * results = (NSDictionary *)responseObject;

    unsigned int outCount,i;
    objc_property_t * properties = class_copyPropertyList(class, &outCount);
    id model = [[class alloc] init];
    for(i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString * propertyName = [NSString stringWithUTF8String:property_getName(property)];
        [model setValue:[results objectForKey:propertyName] forKeyPath:propertyName];
    }
    return model;
}

//将取得的内容转换为模型
+ (NSArray *)mapModelArrProcess:(id)responseObject withClass:(Class)class
{
    //判断返回值
    NSArray * results = (NSArray *)responseObject;
    
    unsigned int outCount,i;
    objc_property_t * properties = class_copyPropertyList(class, &outCount);
    NSMutableArray * models = [NSMutableArray arrayWithCapacity:results.count];
    for(NSDictionary * info in results)
    {
        id model = [[class alloc] init];
        for(i = 0; i < outCount; i++)
        {
            objc_property_t property = properties[i];
            NSString * propertyName = [NSString stringWithUTF8String:property_getName(property)];
            [model setValue:[info objectForKey:propertyName] forKeyPath:propertyName];
        }
        [models addObject:model];
    }
    return (NSArray *)models;
}





+(void)printClassInfo:(NSObject *)info
{
    unsigned int varCount;
    Ivar *vars = class_copyIvarList([info class], &varCount);
    for (int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        const char* name = ivar_getName(var);
        NSString *valueKey = [NSString stringWithUTF8String:name];
        NSLog(@"%@:%@",valueKey,[info valueForKey:valueKey]);
    }
    free(vars);
}
@end
