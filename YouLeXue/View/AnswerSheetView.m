//
//  AnswerSheetView.m
//  YouLeXue
//
//  Created by vedon on 17/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//
#define RowHeight  25
#define RowOffsetX 60
#define OffsetX    0
#define OffsetY    0
#define AnswerSheetWidth 300

#import "AnswerSheetView.h"
#import <QuartzCore/QuartzCore.h>
@implementation AnswerSheetView
@synthesize answerCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)tapGesture:(UIGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:gesture.view];
    int x = ceil(location.x- OffsetX)/RowOffsetX;
    int y = ceil(location.y - OffsetY)/RowHeight;
    [self getGridNumWithX:x Y:y];
}

-(NSInteger)getGridNumWithX:(int)x  Y:(int)y
{
    
    NSInteger columnY = y*5;
    NSInteger rowX = (x+1);
    NSInteger index = columnY + rowX;
    NSLog(@"%d",index);
    return index;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    UITapGestureRecognizer * gesutre = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:gesutre];
    gesutre  = nil;
    NSInteger height = RowHeight * floor(answerCount/5.0);
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGFloat black[4] = {0, 0,
        0, 1};
    CGContextSetStrokeColor(context, black);
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, .3f);
    CGContextMoveToPoint(context, OffsetX, OffsetY);
    CGContextSaveGState(context);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetShadowWithColor(context, CGSizeMake(2, -2), 1.6, [[UIColor blackColor]CGColor]);
    CGContextAddLineToPoint(context, OffsetX+AnswerSheetWidth, OffsetY);
    CGContextAddLineToPoint(context, OffsetX+AnswerSheetWidth, height);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    CGContextMoveToPoint(context, AnswerSheetWidth+OffsetX, height);
    CGContextAddLineToPoint(context, OffsetX, height);
    CGContextAddLineToPoint(context, OffsetX, OffsetY);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
    for (int i =0; i< floor(answerCount/5.0); i++) {
        for (int j =0; j < 5; j++) {
            //Draw BackGround
            for (NSString *str in self.alreadyAnswerTitle) {
                if ([self shouldDrawBackgroundWithNum:[str integerValue] X:i Y:j]) {
                    CGContextSaveGState(context);
                    CGContextSetRGBFillColor(context, 66.0/255.0, 183.0/255.0, 201.0/255.0, 1.0);
                    CGContextFillRect(context, CGRectMake((RowOffsetX)*j, RowHeight*(i), RowOffsetX-1, RowHeight-1));
                    CGContextRestoreGState(context);
                }

            }
           
            
            //Draw Text
//            CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
//            CGContextSelectFont(context, "Helvetica", 18, kCGEncodingMacRoman);
//            CGContextSetFillColorWithColor(context, [[UIColor blackColor]CGColor]);
//            CGContextShowTextAtPoint(context, 5+(OffsetX)*(j+1)+(RowOffsetX)*j, (OffsetY-5)+RowHeight*(i+1), [self getTextOnSheetWithX:i Y:j], 2);
            
            //CGContextShowTextAtPoint 不能画中文，所以采用以下方法
            CGContextRef textureContext = UIGraphicsGetCurrentContext();
            UIGraphicsPushContext(textureContext);
            [[self getTextOnSheetWithX:i Y:j] drawAtPoint:CGPointMake(5+(OffsetX)*(j+1)+(RowOffsetX)*j, (OffsetY+5)+RowHeight*(i)) withFont:[UIFont systemFontOfSize:15]];
            UIGraphicsPopContext();
        }
        CGContextSetLineWidth(context, .1f);
        CGContextMoveToPoint(context, OffsetX, OffsetY+RowHeight*i);
        CGContextAddLineToPoint(context, OffsetX+AnswerSheetWidth, OffsetY+RowHeight*i);
    }
    for (int i =0; i< 4; i++) {
        CGContextSetLineWidth(context, .1f);
        CGContextMoveToPoint(context, OffsetX+AnswerSheetWidth/5.0*(i+1), OffsetY);
        CGContextAddLineToPoint(context,OffsetX+AnswerSheetWidth/5.0*(i+1), height);
    }
    CGContextStrokePath(context);

}

-(BOOL)shouldDrawBackgroundWithNum:(NSInteger)num X:(NSInteger)x Y:(NSInteger)y
{
    int row = ceil(num/5);
    int column = num - (row*5);
    if (x==row && y+1 == column) {
        NSLog(@"%d,%d",row,column);
        return YES;
    }
    return  NO;
}
-(NSString *)getTextOnSheetWithX:(NSInteger)x Y:(NSInteger)y
{
    int row = x;
    int column = y+1;
    NSInteger index = row*5 + column;
    NSString * str = [self.titleDataSourece objectAtIndex:index-1];
    return str;
}
@end
