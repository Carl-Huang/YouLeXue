//
//  PersistentDataManager.m
//  YouLeXue
//
//  Created by vedon on 8/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "PersistentDataManager.h"
#import "FMDatabase.h"
#import <objc/runtime.h>
#import "UserLoginInfo.h"
@implementation PersistentDataManager
@synthesize db;

+(PersistentDataManager *)sharePersistenDataManager
{
    static PersistentDataManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PersistentDataManager alloc]init];
    });
    return manager;
}

-(id)init
{
    self = [super init];
    if (self) {
        NSString *dataPath = [self initializationFilePath];
        NSLog(@"%@",dataPath);
        self.db = [FMDatabase databaseWithPath:dataPath];
        if (![db open]) {
            NSLog(@"Open db error");
        }else
        {
            NSLog(@"open db successfully");
        }
    }
    return self;
}


#pragma mark - 数据库操作方法
//创建登陆的表
-(void)createUserLoginInfoTable:(UserLoginInfo *)info
{
    if ([self isTableOK:@"UserLoginInfoTable"]) {
        NSLog(@"数据表已经存在");
        [self insertValueToExistedTableWithArguments:info];
    }else
    {
        NSLog(@"数据表不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists UserLoginInfoTable %@",[self enumerateObjectConverToStr:info withPrimarykey:@"UserID"]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create table successfully");
            [self insertValueToExistedTableWithArguments:info];
        }else
        {
            NSLog(@"Failer to create table,Error: %@",[db lastError]);
        }

    }
}

//插入数据到表
-(void)insertValueToExistedTableWithArguments:(id )obj
{
    NSMutableArray * objectValueArray = [NSMutableArray array];
    unsigned int varCount;
    Ivar *vars = class_copyIvarList([obj class], &varCount);
    for (int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        const char* name = ivar_getName(var);
        NSString *valueKey = [NSString stringWithUTF8String:name];
        NSLog(@"%@",valueKey);
        [objectValueArray addObject:[obj valueForKey:valueKey]];
    }
    free(vars);
    NSString *sqlInsertStr = [NSString stringWithFormat:@"insert into UserLoginInfoTable %@",[self insertKeyStringWithkeyNum:varCount]];
    
    if ([db executeUpdate:sqlInsertStr withArgumentsInArray:objectValueArray]) {
        NSLog(@"Insert value successfully");
    }else
    {
        NSLog(@"Failer to insert value to table,Error: %@",[db lastError]);
    }
}

-(void)readDataWithPrimaryKey:(NSString *)key keyValue:(NSString *)keyValue withTableName:(NSString *)tableName withObj:(id)obj
{
    NSString * sqlStr = [NSString stringWithFormat:@"select * from %@ where %@=%@",tableName,key,keyValue];
    FMResultSet *rs = [db executeQuery:sqlStr];
    while ([rs next]) {
        unsigned int varCount;
        Ivar *vars = class_copyIvarList([obj class], &varCount);
        for (int i = 0; i < varCount; i++) {
            Ivar var = vars[i];
            const char* name = ivar_getName(var);
            NSString *valueKey = [NSString stringWithUTF8String:name];
            valueKey = [valueKey substringFromIndex:1];
            NSLog(@"%@",[rs stringForColumn:valueKey]);
        }
        free(vars);
    }
}











#pragma mark - Utility
//**************************************************************************
//生成需要插入的key 字符串
-(NSString *)insertKeyStringWithkeyNum:(unsigned int)keyNum
{
    NSString * inserStr= @"(";
    for (int i = 0; i<keyNum; i++) {
        if (i == keyNum-1) {
            inserStr  = [inserStr stringByAppendingString:@"?)"];
        }else
        inserStr = [inserStr stringByAppendingString:@"?,"];
    }
     NSString *sqlInsertStr = [NSString stringWithFormat:@"values%@",inserStr];
    return sqlInsertStr;
}

//创建表的时候读取object 的key 作为创建表的key
-(NSString *)enumerateObjectConverToStr:(id)object withPrimarykey:(NSString *)primaryKey
{
    unsigned int varCount;
    NSString * createTableStr = @"(";
    Ivar *vars = class_copyIvarList([object class], &varCount);
    for (int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        const char* name = ivar_getName(var);
        NSString *valueKey = [NSString stringWithUTF8String:name];
        valueKey = [valueKey substringFromIndex:1];
        NSLog(@"%@",valueKey);
        NSString *tempStr = nil;
        if (i != varCount -1) {
            if ([valueKey isEqualToString:primaryKey]) {
                tempStr = [NSString stringWithFormat:@"%@ text primary key,",valueKey];
            }else
                tempStr = [NSString stringWithFormat:@"%@ text,",valueKey];
        }else
        {
            tempStr = [NSString stringWithFormat:@"%@ text)",valueKey];
        }
        
        createTableStr = [createTableStr stringByAppendingString:tempStr];
    }
    free(vars);
    return createTableStr;
}

//检测table是否存在
- (BOOL) isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %d", count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

//数据库文件路径
-(NSString *)initializationFilePath
{
    NSString * tempFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filePath = [tempFilePath stringByAppendingPathComponent:@"DataBase.db"];
    return filePath;
}


@end
