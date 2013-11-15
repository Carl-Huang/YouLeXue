//
//  QuestionView.h
//  YouLeXue
//
//  Created by vedon on 13/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PaperType)
{
    PaperTypeChoose = 1,
    PaperTypeOpinion = 2,
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
    NSArray * alphabetAry;
}
@property (strong ,nonatomic) UIWebView * quesTextView;
@property (strong ,nonatomic) NSString * answerStr;
@property (strong ,nonatomic) ButtonConfigrationBlock block;
@property (assign ,nonatomic) NSInteger itemIndex;
@property (assign ,nonatomic) PaperType paperType;
- (id)initWithFrame:(CGRect)frame ItemIndex:(NSInteger)index PaperType:(PaperType)type isTitle:(BOOL)isTitle;

-(void)setSelectButonStatus:(NSString *)str;

@end
