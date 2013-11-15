//
//  QuestionView.m
//  YouLeXue
//
//  Created by vedon on 13/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//
#define ButtonOffsetX 30
#define ButtonOffsetY 10
#define ButtonWidth   30
#define ButtonHeight  30
#define ButtonGap     10
#import "QuestionView.h"

@implementation QuestionView
@synthesize quesTextView;
@synthesize answerStr;
@synthesize itemIndex;

- (id)initWithFrame:(CGRect)frame ItemIndex:(NSInteger)index PaperType:(PaperType)type isTitle:(BOOL)isTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        originRect = frame;
        rect = frame;
        rect.origin.x = 0;
        rect.size.height -=65;
        self.quesTextView = [[UIWebView alloc]initWithFrame:rect];
        self.quesTextView.dataDetectorTypes = UIDataDetectorTypeNone;
        [self addSubview:self.quesTextView];
        
        self.itemIndex = index;
        self.paperType = type;
        if (type == PaperTypeChoose) {
            if (!isTitle) {
                [self buttonChooseTypeInterface];
            }
        }else
        {
            [self buttonOpinionTypeInterface];
        }
    }
    return self;
}

-(void)buttonChooseTypeInterface
{
    //A,B,C,D选项view
    UIButton *buttonA = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonA setBackgroundColor:[UIColor clearColor]];
    buttonA.tag = 1;
    [buttonA setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose3"] forState:UIControlStateNormal];
    [buttonA setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose2"] forState:UIControlStateSelected];
    [buttonA setFrame:CGRectMake(ButtonOffsetX, ButtonOffsetY, ButtonWidth, ButtonHeight)];
    [buttonA addTarget:self action:@selector(buttonAAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *labelA = [[UILabel alloc]initWithFrame:CGRectMake(ButtonOffsetX+ButtonWidth+ButtonGap, ButtonOffsetY, ButtonWidth, ButtonHeight)];
    [labelA setBackgroundColor:[UIColor clearColor]];
    [labelA setText:@"A"];
    
    
    UIButton *buttonB = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonB setBackgroundColor:[UIColor clearColor]];
    [buttonB setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose3"] forState:UIControlStateNormal];
    [buttonB setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose2"] forState:UIControlStateSelected];
    buttonB.tag = 2;
    [buttonB setFrame:CGRectMake(ButtonGap+buttonA.frame.size.width+buttonA.frame.origin.x+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
    [buttonB addTarget:self action:@selector(buttonBAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *labelB = [[UILabel alloc]initWithFrame:CGRectMake(buttonB.frame.origin.x+ButtonGap+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
    [labelB setBackgroundColor:[UIColor clearColor]];
    [labelB setText:@"B"];
    
    UIButton *buttonC= [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonC setBackgroundColor:[UIColor clearColor]];
    [buttonC setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose3"] forState:UIControlStateNormal];
    buttonC.tag = 3;
    [buttonC setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose2"] forState:UIControlStateSelected];
    [buttonC setFrame:CGRectMake(ButtonGap+buttonB.frame.size.width+buttonB.frame.origin.x+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
    [buttonC addTarget:self action:@selector(buttonCAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *labelC = [[UILabel alloc]initWithFrame:CGRectMake(buttonC.frame.origin.x+ButtonGap+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
    [labelC setBackgroundColor:[UIColor clearColor]];
    [labelC setText:@"C"];
    
    
    UIButton *buttonD= [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonD setBackgroundColor:[UIColor clearColor]];
    [buttonD setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose3"] forState:UIControlStateNormal];
    buttonD.tag = 4;
    [buttonD setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose2"] forState:UIControlStateSelected];
    [buttonD setFrame:CGRectMake(ButtonGap+buttonC.frame.size.width+buttonC.frame.origin.x+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
    [buttonD addTarget:self action:@selector(buttonDAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *labelD = [[UILabel alloc]initWithFrame:CGRectMake(buttonD.frame.origin.x+ButtonGap+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
    [labelD setBackgroundColor:[UIColor clearColor]];
    [labelD setText:@"D"];
    
    
    
    UIView * containerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.quesTextView.frame.origin.y+self.quesTextView.frame.size.height, originRect.size.width, 65)];
    [containerView setBackgroundColor:[UIColor clearColor]];
    
    [containerView addSubview:buttonA];
    [containerView addSubview:labelA];
    [containerView addSubview:buttonB];
    [containerView addSubview:labelB];
    [containerView addSubview:buttonC];
    [containerView addSubview:labelC];
    [containerView addSubview:buttonD];
    [containerView addSubview:labelD];
    buttonArray  = @[buttonA,buttonB,buttonC,buttonD];
    buttonA = nil;
    buttonB = nil;
    buttonC = nil;
    buttonD = nil;
    labelA = nil;
    labelB = nil;
    labelC = nil;
    labelD = nil;
    [self addSubview:containerView];
    containerView = nil;
    // Initialization code
    buttonAState = NO;
    buttonBState = NO;
    buttonCState = NO;
    buttonDState = NO;
}

-(void)buttonOpinionTypeInterface
{
    UIButton *buttonA = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonA setBackgroundColor:[UIColor clearColor]];
    buttonA.tag = 1;
    [buttonA setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose3"] forState:UIControlStateNormal];
    [buttonA setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose1"] forState:UIControlStateSelected];
    [buttonA setFrame:CGRectMake(ButtonOffsetX, ButtonOffsetY, ButtonWidth, ButtonHeight)];
    [buttonA addTarget:self action:@selector(buttonAAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *labelA = [[UILabel alloc]initWithFrame:CGRectMake(ButtonOffsetX+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
    [labelA setBackgroundColor:[UIColor clearColor]];
    [labelA setText:@"√"];
    
    
    UIButton *buttonB = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonB setBackgroundColor:[UIColor clearColor]];
    [buttonB setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose3"] forState:UIControlStateNormal];
    [buttonB setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose1"] forState:UIControlStateSelected];
    buttonB.tag = 2;
    [buttonB setFrame:CGRectMake(ButtonGap+buttonA.frame.size.width+buttonA.frame.origin.x+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
    [buttonB addTarget:self action:@selector(buttonBAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *labelB = [[UILabel alloc]initWithFrame:CGRectMake(buttonB.frame.origin.x+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
    [labelB setBackgroundColor:[UIColor clearColor]];
    [labelB setText:@"×"];
    
    UIView * containerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.quesTextView.frame.origin.y+self.quesTextView.frame.size.height, originRect.size.width, 65)];
    [containerView setBackgroundColor:[UIColor clearColor]];
    
    [containerView addSubview:buttonA];
    [containerView addSubview:labelA];
    [containerView addSubview:buttonB];
    [containerView addSubview:labelB];
 
    buttonArray  = @[buttonA,buttonB];
    buttonA = nil;
    buttonB = nil;
    labelA = nil;
    labelB = nil;
    [self addSubview:containerView];
    containerView = nil;
}

-(void)buttonAAction:(id)sender
{
    UIButton *btn = sender;
    [self resetButtonStatus:btn.tag];
    if (self.block) {
        self.block(@"A",self.itemIndex);
    }
    NSLog(@"%s",__func__);
}

-(void)buttonBAction:(id)sender
{
    UIButton *btn = sender;
    [self resetButtonStatus:btn.tag];
    if (self.block) {
        self.block(@"B",self.itemIndex);
    }
    
    NSLog(@"%s",__func__);
}
-(void)buttonCAction:(id)sender
{
    UIButton *btn = sender;
    [self resetButtonStatus:btn.tag];
    if (self.block) {
        self.block(@"C",self.itemIndex);
    }
    NSLog(@"%s",__func__);
}
-(void)buttonDAction:(id)sender
{
    UIButton *btn = sender;
    [self resetButtonStatus:btn.tag];
    if (self.block) {
        self.block(@"D",self.itemIndex);
    }
    NSLog(@"%s",__func__);
}

-(void)resetButtonStatus:(NSInteger)tag
{
    for (UIButton *btn in buttonArray) {
        if (btn.tag == tag) {
            [btn setSelected:YES];
        }else
            [btn setSelected:NO];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect tempRect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(tempRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, tempRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
