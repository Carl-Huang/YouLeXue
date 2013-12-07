//
//  FetchUserMessageInfo.h
//  YouLeXue
//
//  Created by vedon on 8/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchUserMessageInfo : NSObject
@property (strong ,nonatomic) NSString * ID;
@property (strong ,nonatomic) NSString * Sender;
@property (strong ,nonatomic) NSString * Incept;
@property (strong ,nonatomic) NSString * Title;
@property (strong ,nonatomic) NSString * Content;
@property (strong ,nonatomic) NSString * Flag;
@property (strong ,nonatomic) NSString * Sendtime;
@property (strong ,nonatomic) NSString * DelR;
@property (strong ,nonatomic) NSString * DelS;
@property (strong ,nonatomic) NSString * IsSend;
@property (strong ,nonatomic) NSString * isDelete;
@property (strong ,nonatomic) NSString * isRead;
@end
