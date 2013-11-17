//
//  ExamInfo.h
//  YouLeXue
//
//  Created by vedon on 8/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamInfo : NSObject
@property (strong ,nonatomic)NSString * id; //试卷ID
@property (strong ,nonatomic)NSString * tid; //试卷分类ID
@property (strong ,nonatomic)NSString * title;
@property (strong ,nonatomic)NSString * sj; //试卷内容、简介
@property (strong ,nonatomic)NSString * sjjd;
@property (strong ,nonatomic)NSString * kssj; //考试时间120分钟
@property (strong ,nonatomic)NSString * form_user;
@property (strong ,nonatomic)NSString * form_url;
@property (strong ,nonatomic)NSString * hits;
@property (strong ,nonatomic)NSString * date;
@property (strong ,nonatomic)NSString * sq;
@property (strong ,nonatomic)NSString * user;
@property (strong ,nonatomic)NSString * groupid; //允许答题的用户组id，以英文逗号加一个空格间隔，如1, 2
@property (strong ,nonatomic)NSString * DownUrl;
@property (strong ,nonatomic)NSString * verific;
@property (strong ,nonatomic)NSString * recommend;
@property (strong ,nonatomic)NSString * popular;
@property (strong ,nonatomic)NSString * dtfs;
@property (strong ,nonatomic)NSString * sjzf; //试卷总分
@property (strong ,nonatomic)NSString * Times; //答题次数
@property (strong ,nonatomic)NSString * allowtj; //允许马上提交看答案及解答
@property (strong ,nonatomic)NSString * KS_leixing;
@property (strong ,nonatomic)NSString * tname;


@end
