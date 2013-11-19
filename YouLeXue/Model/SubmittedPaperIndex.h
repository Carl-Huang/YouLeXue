//
//  SubmittedPaperIndex.h
//  YouLeXue
//
//  Created by vedon on 19/11/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubmittedPaperIndex : NSObject
@property (strong ,nonatomic) NSString * paperTitleStr;
@property (strong ,nonatomic) NSString * timeStamp;
@property (strong ,nonatomic) NSString * uuid;
@property (strong ,nonatomic) NSString * score;
@property (strong ,nonatomic) NSString * paperTotalScore;
@property (strong ,nonatomic) NSString * useTime;
@property (strong ,nonatomic) NSString * totalExamTime;
@end
