//
//  PersistentDataManager.h
//  YouLeXue
//
//  Created by vedon on 8/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@class UserLoginInfo;
@interface PersistentDataManager : NSObject
@property (retain ,nonatomic)FMDatabase *db;
+(PersistentDataManager *)sharePersistenDataManager;


-(void)createUserLoginInfoTable:(UserLoginInfo *)info;
-(id)readDataWithPrimaryKey:(NSString *)key keyValue:(NSString *)keyValue withTableName:(NSString *)tableName withObj:(id)obj;

-(id)readDataWithTableName:(NSString *)tableName withObjClass:(Class)objClass;
@end
