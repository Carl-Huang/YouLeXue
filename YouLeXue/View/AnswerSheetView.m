//
//  AnswerSheetView.m
//  YouLeXue
//
//  Created by vedon on 17/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//
#define RowHeight  30
#define RowOffsetX 35
#define OffsetX    20
#define OffsetY    5
#define AnswerSheetWidth 280

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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSInteger height = RowHeight * (answerCount/5.0);
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
    for (int i =0; i< 18; i++) {
        for (int j =0; j < 5; j++) {
            //Draw BackGround
            CGContextSaveGState(context);
            CGContextSetRGBFillColor(context, 66.0/255.0, 183.0/255.0, 201.0/255.0, 1.0);
            CGContextRestoreGState(context);
            //Draw Text
            CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
            CGContextSelectFont(context, "Helvetica", 18, kCGEncodingMacRoman);
            CGContextSetFillColorWithColor(context, [[UIColor blackColor]CGColor]);
            CGContextShowTextAtPoint(context, 5+(OffsetX)*(j+1)+(RowOffsetX)*j, (OffsetY-5)+RowHeight*(i+1), "hello", 5);
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


@end
