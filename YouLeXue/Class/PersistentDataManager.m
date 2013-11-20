//
//  PersistentDataManager.m
//  YouLeXue
//
//  Created by vedon on 8/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import "PersistentDataManager.h"
#import "FMDatabase.h"
#import <objc/runtime.h>
#import "UserLoginInfo.h"
#import "ExamInfo.h"
#import "ExamplePaperInfo.h"
#import "FetchDataInfo.h"
#import "ExamPaperInfo.h"
#import "ExamPaperInfoTimeStamp.h"
#import "UserSetting.h"
#import "SubmittedPaperInfo.h"
#import "SubmittedPaperIndex.h"

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
        NSLog(@"UserLoginInfoTable已经存在");
        [self eraseTableData:@"UserLoginInfoTable"];
        [self insertValueToExistedTableWithTableName:@"UserLoginInfoTable" Arguments:info primaryKey:@"UserID"];
    }else
    {
        NSLog(@"UserLoginInfoTable不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists UserLoginInfoTable %@",[self enumerateObjectConverToStr:[info  class] withPrimarykey:@"UserID"]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create UserLoginInfoTable successfully");
            if (info) {
                  [self insertValueToExistedTableWithTableName:@"UserLoginInfoTable" Arguments:info primaryKey:@"UserID"];
            }
        
        }else
        {
            NSLog(@"Failer to create UserLoginInfoTable,Error: %@",[db lastError]);
        }

    }
    [db close];
}

#pragma mark - 创建考试列表的表
-(void)createPaperListTable:(NSArray *)array 
{
    [db open];
    if ([self isTableOK:@"PaperListTable"]) {
        NSLog(@"PaperListTable已经存在");
        [self eraseTableData:@"PaperListTable"];
        if ([array count]) {
            for (ExamInfo * info in array) {
                [self insertValueToExistedTableWithTableName:@"PaperListTable" Arguments:info primaryKey:@"id"];
            }

        }
    }else
    {
        NSLog(@"PaperListTable不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists PaperListTable %@",[self enumerateObjectConverToStr:[ExamInfo class] withPrimarykey:@"id"]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create PaperListTable successfully");
            if ([array count]) {
                for (ExamInfo * info in array) {
                    [self insertValueToExistedTableWithTableName:@"PaperListTable" Arguments:info primaryKey:@"id"];
                }
            }
        
        }else
        {
            NSLog(@"Failer to create PaperListTable,Error: %@",[db lastError]);
        }
        
    }
    [db close];
}

#pragma mark - 创建对应考试列表的试卷

-(void)createExamPaperTable:(NSArray *)array
{
    [db open];
    if ([self isTableOK:@"ExamPaperTable"]) {
        NSLog(@"ExamPaperTable已经存在");
        [self eraseTableData:@"ExamPaperTable"];
        if ([array count]) {
            for (NSArray * specificArray in array) {
                for (ExamPaperInfo * info in specificArray) {
                    [self insertValueToExistedTableWithTableName:@"ExamPaperTable" Arguments:info primaryKey:@"id"];
                }
            }
        }
    
    }else
    {
        NSLog(@"ExamPaperTable不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists ExamPaperTable %@",[self enumerateObjectConverToStr:[ExamPaperInfo class] withPrimarykey:@"id"]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create ExamPaperTable successfully");
            if ([array count]) {
                for (NSArray * specificArray in array) {
                    for (ExamPaperInfo * info in specificArray) {
                        [self insertValueToExistedTableWithTableName:@"ExamPaperTable" Arguments:info primaryKey:@"id"];
                    }
                }
            }
        }else
        {
            NSLog(@"Failer to create table,Error: %@",[db lastError]);
        }
        
    }
    [db close];
}

#pragma mark - 创建错题本
-(void)createWrongTextBook:(NSArray *)array
{
    [db open];
    if ([self isTableOK:@"WrongTextBookTable"]) {
        NSLog(@"WrongTextBookTable已经存在");
        [self eraseTableData:@"WrongTextBookTable"];
        if ([array count]) {
            for (ExamPaperInfoTimeStamp * info in array) {
                [self insertValueToExistedTableWithTableName:@"WrongTextBookTable" Arguments:info primaryKey:@"id"];
            }
        }
    }else
    {
        NSLog(@"WrongTextBookTable不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists WrongTextBookTable %@",[self enumerateObjectConverToStr:[ExamPaperInfoTimeStamp class] withPrimarykey:@"id"]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create WrongTextBookTable successfully");
            if ([array count]) {
                for (ExamPaperInfoTimeStamp * info in array) {
                    [self insertValueToExistedTableWithTableName:@"WrongTextBookTable" Arguments:info primaryKey:@"id"];
                }

            }
            
        }else
        {
            NSLog(@"Failer to create WrongTextBookTable,Error: %@",[db lastError]);
        }
    }
    [db close];
}
-(void)insertValueIntoWrongTextBookTable:(NSArray *)array
{
    [db open];
    if ([array count]) {
        for (ExamPaperInfoTimeStamp * info in array) {
            [self insertValueToExistedTableWithTableName:@"WrongTextBookTable" Arguments:info primaryKey:@"id"];
        }
    }
    [db close];
}

#pragma mark - 创建案例的表
-(void)createExampleListTable:(NSArray *)array
{
    [db open];
    if ([self isTableOK:@"ExampleListTable"]) {
        NSLog(@"ExampleListTable已经存在");
        [self eraseTableData:@"ExampleListTable"];
        if ([array count]) {
            for (ExamplePaperInfo * info in array) {
                [self insertValueToExistedTableWithTableName:@"ExampleListTable" Arguments:info primaryKey:@"TID"];
            }
        }
    }else
    {
        NSLog(@"ExampleListTable不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists ExampleListTable %@",[self enumerateObjectConverToStr:[ExamplePaperInfo class] withPrimarykey:@"TID"]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create table successfully");
            if ([array count]) {
                for (ExamplePaperInfo * info in array) {
                    [self insertValueToExistedTableWithTableName:@"ExampleListTable" Arguments:info primaryKey:@"TID"];
                }
            }
        }else
        {
            NSLog(@"Failer to create table,Error: %@",[db lastError]);
        }
        
    }
    [db close];
}

#pragma mark - 创建其他信息表
-(void)createOtherInformationTable:(NSArray *)array
{
    [db open];
    if ([self isTableOK:@"OtherInformationTable"]) {
        NSLog(@"OtherInformationTable已经存在");
        [self eraseTableData:@"OtherInformationTable"];
        if ([array count]) {
            for (FetchDataInfo * info in array) {
                [self insertValueToExistedTableWithTableName:@"OtherInformationTable" Arguments:info primaryKey:@"KS_phoneSeq"];
            }
        }
    
    }else
    {
        NSLog(@"OtherInformationTable不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists OtherInformationTable %@",[self enumerateObjectConverToStr:[FetchDataInfo class] withPrimarykey:@"KS_phoneSeq"]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create table successfully");
            if ([array count]) {
                for (FetchDataInfo * info in array) {
                    [self insertValueToExistedTableWithTableName:@"OtherInformationTable" Arguments:info primaryKey:@"KS_phoneSeq"];
                }
            }
        
        }else
        {
            NSLog(@"Failer to create table,Error: %@",[db lastError]);
        }
        
    }
    [db close];

}
#pragma mark - 读取试卷，每一份试卷为一个对象，并返回一个dictionary
//读取试卷，每一份试卷为一个对象，并返回一个dictionary
-(NSMutableDictionary *)readExamPaperToDic
{
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    
    NSArray * keyArr = [self readDistinctObjWithKey:@"kid" tableName:@"ExamPaperTable"];
    if ([keyArr count]) {
        [db open];
        for (NSString * key in keyArr) {
            NSString * sqlStr = [NSString stringWithFormat:@"select * from ExamPaperTable where kid='%@'",key];
            
            FMResultSet *rs = [db executeQuery:sqlStr];
            NSMutableArray * array = [NSMutableArray array];
            while ([rs next]) {
                id info = [[ExamPaperInfo alloc] init];
                unsigned int varCount;
                Ivar *vars = class_copyIvarList([ExamPaperInfo class], &varCount);
                for (int i = 0; i < varCount; i++) {
                    Ivar var = vars[i];
                    const char* name = ivar_getName(var);
                    NSString *valueKey = [NSString stringWithUTF8String:name];
                    valueKey = [valueKey substringFromIndex:1];
                    [info setValue:[rs stringForColumn:valueKey] forKeyPath:valueKey];
                }
                free(vars);
                [array addObject:info];
            }
            [tempDic setObject:array forKey:key];
            array = nil;
        }
        [db close];
    }
    
    return tempDic;
}

-(NSArray *)readDistinctObjWithKey:(NSString *)key tableName:(NSString *)tableName
{
    [db open];
    NSString * sqlStr = [NSString stringWithFormat:@"select distinct %@ from %@",key,tableName];
    FMResultSet *rs = [db executeQuery:sqlStr];
    NSMutableArray * tempArray = [NSMutableArray array];
    while ([rs next]) {
        [tempArray addObject:[rs stringForColumn:@"kid"]];
        //        NSLog(@"%@",[rs stringForColumn:@"kid"]);
    }
    
    [rs close];
    [db close];
    return tempArray;
}



#pragma mark - 创建保存用户设置的表
-(void)createUserSettingTable
{
    [db open];
    NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists UserSettingTable %@",[self enumerateObjectConverToStr:[UserSetting class] withPrimarykey:nil]];
    if ([db executeUpdate:cmdStr]) {
        
        NSLog(@"create table successfully");
        [self eraseTableData:@"UserSettingTable"];
        NSMutableArray * objectValueArray = [NSMutableArray array];
        unsigned int varCount;
        Ivar *vars = class_copyIvarList([UserSetting class], &varCount);
        for (int i = 0; i < varCount; i++) {
            [objectValueArray addObject:@"No"];
            
        }
        free(vars);
        NSString *sqlInsertStr = [NSString stringWithFormat:@"insert into %@ %@",@"UserSettingTable",[self insertKeyStringWithkeyNum:varCount]];
        if ([db executeUpdate:sqlInsertStr withArgumentsInArray:objectValueArray]) {
            NSLog(@"初始化UserSetting 成功");
        }
    }else
    {
        NSLog(@"Failer to create table,Error: %@",[db lastError]);
    }
    [db close];
}

-(UserSetting *)readUserSettingData
{
    [db open];
    
    NSString * sqlStr = [NSString stringWithFormat:@"select * from UserSettingTable"];
    FMResultSet *rs = [db executeQuery:sqlStr];
    while ([rs next]) {
        id settingInfo = [[UserSetting alloc]init];
        unsigned int varCount;
        Ivar *vars = class_copyIvarList([UserSetting class], &varCount);
        for (int i = 0; i < varCount; i++) {
            Ivar var = vars[i];
            const char* name = ivar_getName(var);
            NSString *valueKey = [NSString stringWithUTF8String:name];
            valueKey = [valueKey substringFromIndex:1];
            NSLog(@"%@",[rs stringForColumn:valueKey]);
            [settingInfo setValue:[rs stringForColumn:valueKey] forKeyPath:valueKey];
        }
        free(vars);
        [rs close];
        [db close];
        return settingInfo;
    }
    return nil;
}

-(void)updateUserSettingTableWithkey:(NSString *)key value:(NSString *)value
{
    [db open];
    NSString * cmdStr = [NSString stringWithFormat:@"update UserSettingTable set %@=?",key];
    if ([db executeUpdate:cmdStr,value]) {
        NSLog(@"update UserSettingTable successfully");
    }else
    {
        NSLog(@"Failer to update value to UserSettingTable,Error: %@",[db lastError]);
    }
    [db close];
}

#pragma mark - 创建试卷标注表
-(void)createAlreadyMarkPaperTable:(NSArray *)array
{
    [db open];
    NSMutableArray * idArray = [NSMutableArray array];
    for (ExamInfo * info in array) {
        NSString * str = [info valueForKey:@"id"];
        [idArray addObject:str];
    }
    
    NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists AlreadyMarkPaperTable (id text primary key,isSelected text)"];
    if ([db executeUpdate:cmdStr]) {
        NSLog(@"create AlreadyMarkPaperTable successfully");
        //插入数据
            for (NSString *str  in idArray) {
                NSString * cmdStr = [NSString stringWithFormat:@"INSERT INTO AlreadyMarkPaperTable values (?,?)"];
                [db executeUpdate:cmdStr withArgumentsInArray:@[str,@"No"]];
            }
 
    }else
    {
        NSLog(@"Failer to create PaperListTable,Error: %@",[db lastError]);
    }
    [db close];
}
-(NSArray *)readAlreadyMarkPaperTable
{
    [db open];
    NSString * sqlStr = [NSString stringWithFormat:@"select * from AlreadyMarkPaperTable"];
    FMResultSet *rs = [db executeQuery:sqlStr];
    NSMutableArray * tempArray = [NSMutableArray array];
    while ([rs next]) {
        NSString * idStr = [rs stringForColumn:@"id"];
        NSString * isCheckOrnot = [rs stringForColumn:@"isSelected"];
        NSDictionary * tempDic =@{@"id": idStr,@"isSelected":isCheckOrnot};
        [tempArray addObject:tempDic];
        tempDic = nil;
    }
    [rs close];
    [db close];
    if ([tempArray count]) {
        return tempArray;
    }
    return nil;
}

-(void)updateAlreadyMarkPaperTableWithKey:(NSString *)key  value:(NSString *)value
{
    [db open];
    [db beginTransaction];
    NSString * cmdStr = [NSString stringWithFormat:@"update AlreadyMarkPaperTable set isSelected=? where id=?"];
    [db executeUpdate:cmdStr,value,key];
    [db commit];
    [db close];
}

#pragma mark - 创建保存提交试卷的表
-(void)createEndExamPaperTable:(NSArray *)array
{
    [db open];
    if ([self isTableOK:@"EndExamPaperTable"]) {
        NSLog(@"EndExamPaperTable已经存在");
        if ([array count]) {
                for (SubmittedPaperInfo * info in array) {
                    [self insertValueToExistedTableWithTableName:@"EndExamPaperTable" Arguments:info primaryKey:nil];
                }
        }
        
    }else
    {
        NSLog(@"ExamPaperTable不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists EndExamPaperTable %@",[self enumerateObjectConverToStr:[SubmittedPaperInfo class] withPrimarykey:nil]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create ExamPaperTable successfully");
            if ([array count]) {
                for (SubmittedPaperInfo * info in array) {
                    [self insertValueToExistedTableWithTableName:@"EndExamPaperTable" Arguments:info primaryKey:nil];
                }

            }
        }else
        {
            NSLog(@"Failer to create table,Error: %@",[db lastError]);
        }
        
    }
    [db close];
}

-(NSArray *)readEndExamTableData:(NSString *)key
{
    [db open];
   
    NSMutableArray * endExamDataArray = [NSMutableArray array];
    NSString * sqlStr = [NSString stringWithFormat:@"select * from EndExamPaperTable where uuid='%@'",key];
    FMResultSet *rs = [db executeQuery:sqlStr];
    while ([rs next]) {
        unsigned int varCount;
        SubmittedPaperInfo * obj = [[SubmittedPaperInfo alloc]init];
        Ivar *vars = class_copyIvarList([SubmittedPaperInfo class], &varCount);
        for (int i = 0; i < varCount; i++) {
            Ivar var = vars[i];
            const char* name = ivar_getName(var);
            NSString *valueKey = [NSString stringWithUTF8String:name];
            valueKey  = [valueKey substringFromIndex:1];
            [obj setValue:[rs stringForColumn:valueKey] forKey:valueKey];
        }
        [endExamDataArray addObject:obj];
        free(vars);
    }
    [rs close];
    [db close];
    if ([endExamDataArray count]) {
        return endExamDataArray;
    }
    return nil;
}

#pragma mark - 创建用于搜索已提交试卷的索引表
-(void)createEndExamPaperIndexTable:(SubmittedPaperIndex *)info
{
    [db open];
    if ([self isTableOK:@"EndExamPaperIndexTable"]) {
        NSLog(@"EndExamPaperTable已经存在");
        [self insertValueToExistedTableWithTableName:@"EndExamPaperIndexTable" Arguments:info primaryKey:@"uuid"];
    }else
    {
        NSLog(@"EndExamPaperIndexTable不存在");
        NSString * cmdStr = [NSString stringWithFormat:@"create table if not exists EndExamPaperIndexTable %@",[self enumerateObjectConverToStr:[SubmittedPaperIndex class] withPrimarykey:@"uuid"]];
        if ([db executeUpdate:cmdStr]) {
            NSLog(@"create ExamPaperTable successfully");

            [self insertValueToExistedTableWithTableName:@"EndExamPaperIndexTable" Arguments:info primaryKey:@"uuid"];
 
        }else
        {
            NSLog(@"Failer to create table,Error: %@",[db lastError]);
        }
        
    }
    [db close];
}

-(void)insertIntoEndExamPaperIndexTable:(SubmittedPaperIndex *)info
{
    [db open];
     [self insertValueToExistedTableWithTableName:@"EndExamPaperIndexTable" Arguments:info primaryKey:@"uuid"];
    [db close];
}

-(NSArray *)readEndExamPaperIndexTable
{
    NSArray * array =[self readDataWithTableName:@"EndExamPaperIndexTable" withObjClass:[SubmittedPaperIndex class]];
    return array;
}


#pragma mark - 清除表的所有信息
-(BOOL)eraseTableData:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![db executeUpdate:sqlstr])
    {
        return NO;
    }
    return YES;
}


#pragma mark - 插入数据到表
-(void)insertValueToExistedTableWithTableName:(NSString *)tableName Arguments:(id )obj primaryKey:(NSString *)key
{
    
    NSMutableArray * objectValueArray = [NSMutableArray array];
    unsigned int varCount;
    Ivar *vars = class_copyIvarList([obj class], &varCount);
    for (int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        const char* name = ivar_getName(var);
        NSString *valueKey = [NSString stringWithUTF8String:name];
//        NSLog(@"%@",valueKey);
        if ([obj valueForKey:valueKey] == nil) {
            [objectValueArray addObject:@"NULL"];
        }else
        {
           [objectValueArray addObject:[obj valueForKey:valueKey]];
        }
        
    }
    free(vars);
    NSString *sqlInsertStr = [NSString stringWithFormat:@"insert into %@ %@",tableName,[self insertKeyStringWithkeyNum:varCount]];
    
    if ([db executeUpdate:sqlInsertStr withArgumentsInArray:objectValueArray]) {
        if (key) {
             NSLog(@"插入key: %@ 的记录",[obj valueForKey:key]);
        }
    }else
    {
        NSLog(@"Failer to insert value to table,Error: %@",[db lastError]);
        //19 插入重复主键错误
        if ([db lastErrorCode]==19) {
            //主键重复，则更新已存在的主键信息
            [self deleteRecordWithPrimaryKey:key keyValue:[obj valueForKey:key] tableName:tableName];
            [db executeUpdate:sqlInsertStr withArgumentsInArray:objectValueArray];
            if (key) {
                NSLog(@"插入key: %@ 的记录",[obj valueForKey:key]);
            }
        
        }
        
    }
}

-(void)deleteRecordWithPrimaryKey:(NSString *)key keyValue:(NSString *)keyValue tableName:(NSString *)tableName
{
    [db open];
    [db beginTransaction];
    NSLog(@"删除key:%@  的记录",keyValue);
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where %@=%@",tableName,key,keyValue];
    if ([db executeUpdate:sqlStr]) {
        NSLog(@"update value successfully");
    }else
    {
        NSLog(@"Failer to update value to table,Error: %@",[db lastError]);
    }
    [db commit];
}

-(BOOL)deleteTable:(NSString *)tableName
{
    [db open];
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![db executeUpdate:sqlstr])
    {
        NSLog(@"Delete table error!");
        return NO;
    }
    [db close];
    return YES;
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

-(NSArray *)readDataWithTableName:(NSString *)tableName withObjClass:(Class)objClass
{
    [db open];
    NSString * sqlStr = [NSString stringWithFormat:@"select * from %@",tableName];
    
    FMResultSet *rs = [db executeQuery:sqlStr];
    NSMutableArray * array = [NSMutableArray array];
    while ([rs next]) {
        id info = [[objClass alloc] init];
        unsigned int varCount;
        Ivar *vars = class_copyIvarList(objClass, &varCount);
        for (int i = 0; i < varCount; i++) {
            Ivar var = vars[i];
            const char* name = ivar_getName(var);
            NSString *valueKey = [NSString stringWithUTF8String:name];
            valueKey = [valueKey substringFromIndex:1];
//            NSLog(@"%@",[rs stringForColumn:valueKey]);
            [info setValue:[rs stringForColumn:valueKey] forKeyPath:valueKey];
        }
        free(vars);
        [array addObject:info];
    }
    [rs close];
    [db close];
    if ([array count]) {
        return array;
    }
    
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
