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

-(void)createUserLoginInfoTable:(UserLoginInfo *)info
{
    if ([self isTableOK:@"UserLoginInfoTable"]) {
        NSLog(@"数据表已经存在");
    }else
    {
        NSLog(@"数据表不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists UserLoginInfoTable %@",[self enumerateObjectConverToStr:info withPrimarykey:@"UserID"]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create table successfully");
        }else
        {
            NSLog(@"Failer to create table,Error: %@",[db lastError]);
        }

    }

}

-(void)insertValueToExistedTableWithArguments:(NSArray *)array
{
    if ([db executeUpdate:@"insert into UserLoginInfoTable values(?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:array]) {
        NSLog(@"Insert value successfully");
    }else
    {
        NSLog(@"Failer to insert value to table,Error: %@",[db lastError]);
    }
}


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
