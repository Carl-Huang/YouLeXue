//
//  ExamPaperInfoTimeStamp.h
//  YouLeXue
//
//  Created by vedon on 16/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamPaperInfoTimeStamp : NSObject
@property (strong , nonatomic) NSString * id; //题目ID
@property (strong , nonatomic) NSString * kid; //题目所属的考试id
@property (strong , nonatomic) NSString * tmfs; // 题目分数
@property (strong , nonatomic) NSString * Answer;
@property (strong , nonatomic) NSString * Tmtype; // 题目类型2表示单选题，3表示A-D多选题，4表示判断题，5表示A-F多选题，6表示A-E多选题
@property (strong , nonatomic) NSString * num;
@property (strong , nonatomic) NSString * did; //若为0表示是大题，不为0表示是小题，值是它所属的大题的id
@property (strong , nonatomic) NSString * beizhu;
@property (strong , nonatomic) NSString * title;
@property (strong , nonatomic) NSString * tmnr;
@property (strong , nonatomic) NSString * DAJS; // 答案解释
@property (strong , nonatomic) NSString * IsRnd;
@property (strong , nonatomic) NSString * Tid;
@property (strong , nonatomic) NSString * IsMedia;
@property (strong , nonatomic) NSString * MediaUrl;
@property (strong , nonatomic) NSString * MediaTxt;
@property (strong , nonatomic) NSString * DAJSMedia;
@property (strong , nonatomic) NSString * glyy;
@property (strong , nonatomic) NSString * Difficulty;
@property (strong , nonatomic) NSString * timeStamp;
@end
