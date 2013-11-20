//
//  SelectedPaperPopupView.m
//  YouLeXue
//
//  Created by vedon on 12/11/13.
//  Copyright (c) 2013 vedon. All rights reserved.
//

#define ButtonFrameForIcon CGRectMake(10, 10, 20, 20)
#define TextLabelHeight 20
#define TextLabelWidth  80
#define TextLabelOffsetY 10
#import "SelectedPaperPopupView.h"

@implementation SelectedPaperPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger width = frame.size.width / 3 ;
        CGRect ButtonFrame =CGRectMake(10, 10, width/4, 20);
        
        //背景
        UIImageView * backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Case List_Unfold_Bg"]];
        [backgroundView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:backgroundView];

        //考试模式
        UIButton * examModel = [UIButton buttonWithType:UIButtonTypeCustom];
        [examModel setFrame:ButtonFrame];
        [examModel setBackgroundImage:[UIImage imageNamed:@"Section_Icon_Mode@2x"] forState:UIControlStateNormal];
        [examModel addTarget:self action:@selector(examModelAction) forControlEvents:UIControlEventTouchUpInside];
        UILabel * examText = [[UILabel alloc]initWithFrame:CGRectMake(examModel.frame.origin.x+examModel.frame.size.width, TextLabelOffsetY,3*width/4, TextLabelHeight)];
        examText.font = [UIFont systemFontOfSize:12];
        [examText setTextColor:[UIColor colorWithRed:66.0/255.0 green:183.0/255.0 blue:201.0/255.0 alpha:1.0]];
        examText.text = @"考试模式";
        [self addSubview:examText];
        [self addSubview:examModel];
        
        //练习模式
        ButtonFrame = CGRectMake(10+width, 10, width/4, 20);
        UIButton * practiceModel = [UIButton buttonWithType:UIButtonTypeCustom];
        [practiceModel setFrame:ButtonFrame];
        [practiceModel setBackgroundImage:[UIImage imageNamed:@"Section_Icon_Exercise@2x"] forState:UIControlStateNormal];
        [practiceModel addTarget:self action:@selector(practiceModelAction) forControlEvents:UIControlEventTouchUpInside];
        UILabel * practiceText = [[UILabel alloc]initWithFrame:CGRectMake(practiceModel.frame.origin.x+practiceModel.frame.size.width, TextLabelOffsetY,3*width/4, TextLabelHeight)];
        practiceText.font = [UIFont systemFontOfSize:12];
        [practiceText setTextColor:[UIColor colorWithRed:66.0/255.0 green:183.0/255.0 blue:201.0/255.0 alpha:1.0]];
        practiceText.text = @"练习模式";
        [self addSubview:practiceText];
        [self addSubview:practiceModel];
        
        //标注试卷
        ButtonFrame = CGRectMake(10+2*width, 10, width/4, 20);
        UIButton * markModel = [UIButton buttonWithType:UIButtonTypeCustom];
        [markModel setFrame:ButtonFrame];
        [markModel setBackgroundImage:[UIImage imageNamed:@"Section_Icon_CancelN@2x"] forState:UIControlStateNormal];
        [markModel addTarget:self action:@selector(markModelAction) forControlEvents:UIControlEventTouchUpInside];
        UILabel * markText = [[UILabel alloc]initWithFrame:CGRectMake(markModel.frame.origin.x+markModel.frame.size.width, TextLabelOffsetY,3*width/4, TextLabelHeight)];
        markText.font = [UIFont systemFontOfSize:12];
        [markText setTextColor:[UIColor colorWithRed:66.0/255.0 green:183.0/255.0 blue:201.0/255.0 alpha:1.0]];
        markText.text = @"标注试卷";
        [self addSubview:markText];
        [self addSubview:markModel];

        self.backgroundColor = [UIColor clearColor];
        // Initialization code
    }
    return self;
}

-(void)examModelAction
{
    self.examBlock();
}

-(void)practiceModelAction
{
    self.practiceBlock();
}

-(void)markModelAction
{
    self.markBlock();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//Case List_Unfold_Bg
//Section_Icon_Mode
//Section_Icon_Exercise
//Section_Icon_Cancel

@end
