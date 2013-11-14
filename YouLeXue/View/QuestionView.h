//
//  QuestionView.h
//  YouLeXue
//
//  Created by vedon on 13/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionView : UIView<UIWebViewDelegate>
{
    CGRect rect;
}
@property (strong ,nonatomic) UIWebView * quesTextView;
@property (strong ,nonatomic) NSString * answerStr;


@property (strong ,nonatomic) NSString * textViewText;

//-(void)initWebView:(NSString *)str;
@end
