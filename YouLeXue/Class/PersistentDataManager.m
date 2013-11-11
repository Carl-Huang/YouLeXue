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
#import "ExamInfo.h"
#import "ExamplePaperInfo.h"
#import "FetchDataInfo.h"
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
    [db open];
    if ([self isTableOK:@"UserLoginInfoTable"]) {
        NSLog(@"数据表已经存在");
        [self insertValueToExistedTableWithTableName:@"UserLoginInfoTable" Arguments:info primaryKey:@"UserID"];
    }else
    {
        NSLog(@"数据表不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists UserLoginInfoTable %@",[self enumerateObjectConverToStr:[info  class] withPrimarykey:@"UserID"]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create table successfully");
            [self insertValueToExistedTableWithTableName:@"UserLoginInfoTable" Arguments:info primaryKey:@"UserID"];
        }else
        {
            NSLog(@"Failer to create table,Error: %@",[db lastError]);
        }

    }
    [db close];
}

//创建考试列表的表
-(void)createPaperListTable:(NSArray *)array 
{
    [db open];
    if ([self isTableOK:@"PaperListTable"]) {
        NSLog(@"数据表已经存在");
        for (ExamInfo * info in array) {
            [self insertValueToExistedTableWithTableName:@"PaperListTable" Arguments:info primaryKey:@"id"];
        }
    }else
    {
        NSLog(@"数据表不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists PaperListTable %@",[self enumerateObjectConverToStr:[ExamInfo class] withPrimarykey:@"id"]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create table successfully");
            for (ExamInfo * info in array) {
                 [self insertValueToExistedTableWithTableName:@"PaperListTable" Arguments:info primaryKey:@"id"];
            }
        }else
        {
            NSLog(@"Failer to create table,Error: %@",[db lastError]);
        }
        
    }
    [db close];
}

//创建案例的表
-(void)createExampleListTable:(NSArray *)array
{
    [db open];
    if ([self isTableOK:@"ExampleListTable"]) {
        NSLog(@"数据表已经存在");
        for (ExamplePaperInfo * info in array) {
            [self insertValueToExistedTableWithTableName:@"ExampleListTable" Arguments:info primaryKey:@"TID"];
        }
    }else
    {
        NSLog(@"数据表不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists ExampleListTable %@",[self enumerateObjectConverToStr:[ExamplePaperInfo class] withPrimarykey:@"TID"]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create table successfully");
            for (ExamplePaperInfo * info in array) {
                [self insertValueToExistedTableWithTableName:@"ExampleListTable" Arguments:info primaryKey:@"TID"];
            }
        }else
        {
            NSLog(@"Failer to create table,Error: %@",[db lastError]);
        }
        
    }
    [db close];

}

//创建其他信息表
-(void)createOtherInformationTable:(NSArray *)array
{
    [db open];
    if ([self isTableOK:@"OtherInformationTable"]) {
        NSLog(@"数据表已经存在");
        for (FetchDataInfo * info in array) {
            [self insertValueToExistedTableWithTableName:@"OtherInformationTable" Arguments:info primaryKey:@"ID"];
        }
    }else
    {
        NSLog(@"数据表不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists OtherInformationTable %@",[self enumerateObjectConverToStr:[FetchDataInfo class] withPrimarykey:@"ID"]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create table successfully");
            for (FetchDataInfo * info in array) {
                [self insertValueToExistedTableWithTableName:@"OtherInformationTable" Arguments:info primaryKey:@"ID"];
            }
        }else
        {
            NSLog(@"Failer to create table,Error: %@",[db lastError]);
        }
        
    }
    [db close];

}


//插入数据到表
-(void)insertValueToExistedTableWithTableName:(NSString *)tableName Arguments:(id )obj primaryKey:(NSString *)key
{
    [db beginTransaction];
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
    NSString *sqlInsertStr = [NSString stringWithFormat:@"insert into %@ %@",tableName,[self insertKeyStringWithkeyNum:varCount]];
    
    if ([db executeUpdate:sqlInsertStr withArgumentsInArray:objectValueArray]) {
        NSLog(@"插入key: %@ 的记录",[obj valueForKey:key]);
    }else
    {
        NSLog(@"Failer to insert value to table,Error: %d",[db lastErrorCode]);
        //19 插入重复主键错误
        if ([db lastErrorCode]==19) {
            //主键重复，则更新已存在的主键信息
            [self deleteRecordWithPrimaryKey:key keyValue:[obj valueForKey:key] tableName:tableName];
            [db executeUpdate:sqlInsertStr withArgumentsInArray:objectValueArray];
             NSLog(@"插入key: %@ 的记录",[obj valueForKey:key]);
        }
        
        
    }
    [db commit];
}

-(void)deleteRecordWithPrimaryKey:(NSString *)key keyValue:(NSString *)keyValue tableName:(NSString *)tableName
{
    NSLog(@"删除key:%@  的记录",key);
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where %@=%@",tableName,key,keyValue];
    if ([db executeUpdate:sqlStr]) {
        NSLog(@"update value successfully");
    }else
    {
        NSLog(@"Failer to update value to table,Error: %@",[db lastError]);
    }
}


-(void)readDataWithPrimaryKey:(NSString *)key keyValue:(NSString *)keyValue withTableName:(NSString *)tableName withObj:(id)obj
{
    [db open];
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
    [rs close];
    [db close];
}

-(id)readDataWithTableName:(NSString *)tableName withObjClass:(Class)objClass
{
    [db open];
    NSString * sqlStr = [NSString stringWithFormat:@"select * from %@",tableName];

    id info = [[objClass alloc] init];
    FMResultSet *rs = [db executeQuery:sqlStr];
    while ([rs next]) {
        unsigned int varCount;
        Ivar *vars = class_copyIvarList(objClass, &varCount);
        for (int i = 0; i < varCount; i++) {
            Ivar var = vars[i];
            const char* name = ivar_getName(var);
            NSString *valueKey = [NSString stringWithUTF8String:name];
            valueKey = [valueKey substringFromIndex:1];
            NSLog(@"%@",[rs stringForColumn:valueKey]);
            [info setValue:[rs stringForColumn:valueKey] forKeyPath:valueKey];
        }
        free(vars);
        return info;
    }
    //TODO:关闭问题
    [rs close];
    [db close];
    return nil;
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
-(NSString *)enumerateObjectConverToStr:(Class)object withPrimarykey:(NSString *)primaryKey
{
    unsigned int varCount;
    NSString * createTableStr = @"(";
    Ivar *vars = class_copyIvarList(object, &varCount);
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

-(void)dealloc
{
    
}
@end
