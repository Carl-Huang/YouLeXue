//
//  SelectedPaperPopupView.h
//  YouLeXue
//
//  Created by vedon on 12/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
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

@end
