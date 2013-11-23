//
//  PersistentDataManager.h
//  YouLeXue
//
//  Created by vedon on 8/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@class UserLoginInfo;
@class UserSetting;
@class SubmittedPaperIndex;
@interface PersistentDataManager : NSObject
@property (retain ,nonatomic)FMDatabase *db;
+(PersistentDataManager *)sharePersistenDataManager;


-(void)createUserLoginInfoTable:(UserLoginInfo *)info;
-(void)readDataWithPrimaryKey:(NSString *)key keyValue:(NSString *)keyValue withTableName:(NSString *)tableName withObj:(id)obj;
-(id)readDataWithTableName:(NSString *)tableName withObjClass:(Class)objClass;
-(void)createPaperListTable:(NSArray *)array;
-(void)deleteRecordWithPrimaryKey:(NSString *)key keyValue:(NSString *)keyValue tableName:(NSString *)tableName;
-(void)createExampleListTable:(NSArray *)array;
-(void)createOtherInformationTable:(NSArray *)array;
-(void)createExamPaperTable:(NSArray *)array;
-(void)createWrongTextBook:(NSArray *)array;
-(void)insertValueIntoWrongTextBookTable:(NSArray *)array;
-(void)createUserSettingTable;
-(void)updateUserSettingTableWithkey:(NSString *)key value:(NSString *)value;
-(UserSetting *)readUserSettingData;
-(NSMutableDictionary *)readExamPaperToDic;

-(void)createAlreadyMarkPaperTable:(NSArray *)array;
-(NSArray *)readAlreadyMarkPaperTable;
-(void)updateAlreadyMarkPaperTableWithKey:(NSString *)key  value:(NSString *)value;
-(void)createEndExamPaperTable:(NSArray *)array;

-(BOOL)deleteTable:(NSString *)tableName;
-(BOOL)eraseTableData:(NSString *)tableName;
-(NSArray *)readEndExamTableData:(NSString *)key;

-(void)createEndExamPaperIndexTable:(SubmittedPaperIndex *)info;
-(void)insertIntoEndExamPaperIndexTable:(SubmittedPaperIndex *)info;
-(NSArray *)readEndExamPaperIndexTable;

-(void)createAlreadyMarkCaseTable:(NSArray *)array;
-(NSArray *)readAlreadyMarkCaseTable;
-(void)updateAlreadyMarkCaseTableWithKey:(NSString *)key  value:(NSString *)value;

@end
