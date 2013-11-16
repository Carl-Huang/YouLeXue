//
//  QuestionView.m
//  YouLeXue
//
//  Created by vedon on 13/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

//PaperTypeButtons





#import "QuestionView.h"

@implementation QuestionView
@synthesize quesTextView;
@synthesize answerStr;
@synthesize itemIndex;

- (id)initWithFrame:(CGRect)frame ItemIndex:(NSInteger)index PaperType:(PaperType)type isTitle:(BOOL)isTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        alphabetAryS = @[@"A",@"B",@"C",@"D"];
        alphabetAryM = @[@"Y",@"N"];
        originRect = frame;
        rect = frame;
        rect.origin.x = 0;
        rect.size.height -=65;
        self.quesTextView = [[UIWebView alloc]initWithFrame:rect];
        self.quesTextView.dataDetectorTypes = UIDataDetectorTypeNone;
        [self addSubview:self.quesTextView];
        self.paperType = type;
        self.itemIndex = index;
        mutiAnswer = [NSMutableArray array];
        if (!isTitle) {
            switch (type) {
                case 4:
                    //判断题
                    [self PaperTypeOpinionButtons];
                    break;

                default:
                    [self PaperTypeButtons];
                    break;
            }
        }
    }
        
    return self;
}



-(void)PaperTypeButtons
{
    //计算button大小，距离
    [self calculateButtonRect];
    
    
    UIView * containerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.quesTextView.frame.origin.y+self.quesTextView.frame.size.height, originRect.size.width, 65)];
    [containerView setBackgroundColor:[UIColor clearColor]];
    
    
    
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
    [buttonA setSelected:NO];
    [containerView addSubview:buttonA];
    [containerView addSubview:labelA];
    labelA = nil;
    
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
    [buttonB setSelected:NO];
    [containerView addSubview:buttonB];
    [containerView addSubview:labelB];
    labelB = nil;
    
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
    [buttonC setSelected:NO];
    [containerView addSubview:buttonC];
    [containerView addSubview:labelC];
    labelC = nil;
    
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
    [buttonD setSelected:NO];
    [containerView addSubview:buttonD];
    [containerView addSubview:labelD];
    labelD = nil;
    switch (self.paperType) {
        case 5:
        {
            //AF多选题
            UIButton *buttonE= [UIButton buttonWithType:UIButtonTypeCustom];
            [buttonE setBackgroundColor:[UIColor clearColor]];
            [buttonE setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose3"] forState:UIControlStateNormal];
            buttonE.tag = 4;
            [buttonE setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose2"] forState:UIControlStateSelected];
            [buttonE setFrame:CGRectMake(ButtonGap+buttonD.frame.size.width+buttonD.frame.origin.x+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
            [buttonE addTarget:self action:@selector(buttonEAction:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *labelE = [[UILabel alloc]initWithFrame:CGRectMake(buttonE.frame.origin.x+ButtonGap+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
            [labelE setBackgroundColor:[UIColor clearColor]];
            [labelE setText:@"E"];
            [buttonE setSelected:NO];
            [containerView addSubview:buttonE];
            [containerView addSubview:labelE];
            labelE = nil;
            
            UIButton *buttonF= [UIButton buttonWithType:UIButtonTypeCustom];
            [buttonF setBackgroundColor:[UIColor clearColor]];
            [buttonF setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose3"] forState:UIControlStateNormal];
            buttonF.tag = 4;
            [buttonF setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose2"] forState:UIControlStateSelected];
            [buttonF setFrame:CGRectMake(ButtonGap+buttonE.frame.size.width+buttonE.frame.origin.x+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
            [buttonF addTarget:self action:@selector(buttonFAction:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *labelF = [[UILabel alloc]initWithFrame:CGRectMake(buttonF.frame.origin.x+ButtonGap+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
            [labelF setBackgroundColor:[UIColor clearColor]];
            [labelF setText:@"F"];
            [buttonF setSelected:NO];
            [containerView addSubview:buttonF];
            [containerView addSubview:labelF];
            labelF = nil;
            
            buttonArray  = @[buttonA,buttonB,buttonC,buttonD,buttonE,buttonF];
            buttonA = nil;
            buttonB = nil;
            buttonC = nil;
            buttonD = nil;
            buttonE = nil;
            buttonF = nil;
        }
        break;
        case 6:
        {
            //AE多选题
            UIButton *buttonE= [UIButton buttonWithType:UIButtonTypeCustom];
            [buttonE setBackgroundColor:[UIColor clearColor]];
            [buttonE setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose3"] forState:UIControlStateNormal];
            buttonE.tag = 4;
            [buttonE setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose2"] forState:UIControlStateSelected];
            [buttonE setFrame:CGRectMake(ButtonGap+buttonD.frame.size.width+buttonD.frame.origin.x+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
            [buttonE addTarget:self action:@selector(buttonEAction:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *labelE = [[UILabel alloc]initWithFrame:CGRectMake(buttonE.frame.origin.x+ButtonGap+ButtonWidth, ButtonOffsetY, ButtonWidth, ButtonHeight)];
            [labelE setBackgroundColor:[UIColor clearColor]];
            [labelE setText:@"E"];
            [buttonE setSelected:NO];
            [containerView addSubview:buttonE];
            [containerView addSubview:labelE];
            labelE = nil;
            
            buttonArray  = @[buttonA,buttonB,buttonC,buttonD,buttonE];
            buttonA = nil;
            buttonB = nil;
            buttonC = nil;
            buttonD = nil;
            buttonE = nil;
        }
        break;
            
        default:
        {
            buttonArray  = @[buttonA,buttonB,buttonC,buttonD];
            buttonA = nil;
            buttonB = nil;
            buttonC = nil;
            buttonD = nil;
        }
        break;
    }


    [self addSubview:containerView];
    containerView = nil;
    // Initialization code
    buttonAState = NO;
    buttonBState = NO;
    buttonCState = NO;
    buttonDState = NO;
}


-(void)calculateButtonRect
{
    switch (self.paperType) {

        case 5:
        {
            //AF多选题
            
        }
        break;
        case 6:
        {
            //AE多选题
        }
        break;
        default:
        {
            ButtonOffsetX = 30;
            ButtonOffsetY = 10;
            ButtonWidth = 30;
            ButtonHeight = 30;
            ButtonGap = 10;
        }
        break;
    }
}


-(void)PaperTypeOpinionButtons
{
    NSInteger ButtonWidthL = 30;
    NSInteger ButtonHeightL = 30;
    
    NSInteger originX = 120;
    UIButton *buttonA = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonA setBackgroundColor:[UIColor clearColor]];
    buttonA.tag = 1;
    [buttonA setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose3"] forState:UIControlStateNormal];
    [buttonA setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose1"] forState:UIControlStateSelected];
    [buttonA setFrame:CGRectMake(originX, 10, ButtonWidthL, ButtonHeightL)];
    [buttonA addTarget:self action:@selector(buttonAAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *labelA = [[UILabel alloc]initWithFrame:CGRectMake(originX+ButtonWidthL, 10, ButtonWidthL, ButtonHeightL)];
    [labelA setBackgroundColor:[UIColor clearColor]];
    [labelA setText:@"√"];
    
    
    UIButton *buttonB = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonB setBackgroundColor:[UIColor clearColor]];
    [buttonB setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose3"] forState:UIControlStateNormal];
    [buttonB setBackgroundImage:[UIImage imageNamed:@"Exercise_Model_Button_Choose1"] forState:UIControlStateSelected];
    buttonB.tag = 2;
    [buttonB setFrame:CGRectMake(labelA.frame.origin.x+ButtonWidthL+ButtonGap, 10, ButtonWidthL, ButtonHeightL)];
    [buttonB addTarget:self action:@selector(buttonBAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *labelB = [[UILabel alloc]initWithFrame:CGRectMake(buttonB.frame.origin.x+ButtonWidthL, 10, ButtonWidthL, ButtonHeightL)];
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

-(void)setSelectButonStatus:(NSString *)str
{
    if (self.paperType == PaperTypeOpinion) {
        for (int i =0;i< [alphabetAryM count];i++) {
            NSString *tempStr  = [alphabetAryM objectAtIndex:i];
            if ([tempStr isEqualToString:str]) {
                for (UIButton *btn in buttonArray) {
                    if (btn.tag == i+1) {
                        [btn setSelected:YES];
                    }
                }
            }
        }
    }else
    {
        for (int i =0;i< [alphabetAryS count];i++) {
            NSString *tempStr  = [alphabetAryS objectAtIndex:i];
            if ([tempStr isEqualToString:str]) {
                for (UIButton *btn in buttonArray) {
                    if (btn.tag == i+1) {
                        [btn setSelected:YES];
                    }
                }
            }
        }

    }
}


-(void)buttonAAction:(id)sender
{
    UIButton *btn = sender;
    [self buttonAction:@"A" withBtn:btn];
    NSLog(@"%s",__func__);
}

-(void)buttonBAction:(id)sender
{
    UIButton *btn = sender;
    [self buttonAction:@"B" withBtn:btn];
    NSLog(@"%s",__func__);
}
-(void)buttonCAction:(id)sender
{
    UIButton *btn = sender;
    [self buttonAction:@"C" withBtn:btn];
    NSLog(@"%s",__func__);
}
-(void)buttonDAction:(id)sender
{
    UIButton *btn = sender;
   [self buttonAction:@"D" withBtn:btn];
    NSLog(@"%s",__func__);
}

-(void)buttonEAction:(id)sender
{
    UIButton *btn = sender;
    [self buttonAction:@"E" withBtn:btn];
    NSLog(@"%s",__func__);
}

-(void)buttonFAction:(id)sender
{
    UIButton *btn = sender;
    [self buttonAction:@"F" withBtn:btn];
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

-(void)buttonAction:(NSString *)alphabet withBtn:(UIButton *)btn
{
    if (self.paperType == PaperTypeMutiChooseAD ||self.paperType == PaperTypeMutiChooseAE||self.paperType == PaperTypeMutiChooseAF) {
        buttonAState = !buttonAState;
        if ([mutiAnswer count]) {
            BOOL isAlreadyHasAlphabet = NO;
            NSString *sendStr = nil;
            for (NSString * str  in mutiAnswer) {
                if ([str isEqualToString:alphabet]) {
                    isAlreadyHasAlphabet = YES;
                    [mutiAnswer removeObject:str];
                    break;
                }
            }
            if (!isAlreadyHasAlphabet) {
                [mutiAnswer addObject:alphabet];
            }
            for (NSString * str in mutiAnswer) {

                if (sendStr==nil) {
                    sendStr = str;
                }else
                {
                    sendStr = [sendStr stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
                }
            }
            self.block(sendStr,self.itemIndex);
        }else
        {
            [mutiAnswer addObject:alphabet];
            self.block(alphabet,self.itemIndex);
        }
        
        
        if (buttonAState) {
            self.block(alphabet,self.itemIndex);
        }else
        {
            self.block(@"",self.itemIndex);
        }
        [btn setSelected:!btn.selected];
    }else
    {
        [self resetButtonStatus:btn.tag];
        if (self.block) {
            //如果是判断题的话
            if (self.paperType == PaperTypeOpinion) {
                if (btn.tag == 1) {
                    self.block(@"Y",self.itemIndex);
                }else
                {
                    self.block(@"N",self.itemIndex);
                }
                return;
            }
            //选择题
            self.block(alphabet,self.itemIndex);
        }
        
    }

}
@end
