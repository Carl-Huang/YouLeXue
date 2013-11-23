//
//  SelectedPaperPopupView.h
//  YouLeXue
//
//  Created by vedon on 12/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ExamModelBlock) ();
typedef void (^PracticeModelBlock) ();
typedef void (^MarkModelBlock) ();
@interface SelectedPaperPopupView : UIView


//block
@property (strong,nonatomic) ExamModelBlock     examBlock;
@property (strong,nonatomic) PracticeModelBlock practiceBlock;
@property (strong,nonatomic) MarkModelBlock     markBlock;
- (id)initWithFrame:(CGRect)frame withBtnImage1:(NSString *)image1 btnImage2:(NSString *)image2 btnImage3:(NSString *)image3 text1:(NSString *)str1 test2:(NSString *)str2 test3:(NSString *)str3;
@end
