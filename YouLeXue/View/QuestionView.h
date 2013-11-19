//
//  QuestionView.h
//  YouLeXue
//
//  Created by vedon on 13/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PaperType)
{
    PaperTypeChoose = 2,
    PaperTypeMutiChooseAD = 3,
    PaperTypeMutiChooseAF = 5,
    PaperTypeMutiChooseAE = 6,
    PaperTypeOpinion = 4,
    
};
typedef void (^ButtonConfigrationBlock) (NSString *str,NSInteger itemIndex);
@interface QuestionView : UIView<UIWebViewDelegate>
{
    CGRect rect;
    CGRect originRect;
    BOOL buttonAState;
    BOOL buttonBState;
    BOOL buttonCState;
    BOOL buttonDState;
    NSArray * buttonArray;
    NSArray * alphabetAryS;
    NSArray * alphabetAryM;
    NSInteger ButtonOffsetX;
    NSInteger ButtonOffsetY;
    NSInteger ButtonWidth;
    NSInteger ButtonHeight;
    NSInteger ButtonGap;
    
    
    //多选题的答案容器
    NSMutableArray *mutiAnswer;
}
@property (strong ,nonatomic) UIWebView * quesTextView;
@property (strong ,nonatomic) NSString * answerStr;
@property (strong ,nonatomic) ButtonConfigrationBlock block;
@property (assign ,nonatomic) NSInteger itemIndex;
@property (assign ,nonatomic) NSInteger questionIndex;
@property (assign ,nonatomic) PaperType paperType;
- (id)initWithFrame:(CGRect)frame ItemIndex:(NSInteger)index PaperType:(PaperType)type isTitle:(BOOL)isTitle;

-(void)setSelectButonStatus:(NSString *)str;

@end
