//
//  QuestionView.m
//  YouLeXue
//
//  Created by vedon on 13/11/13.
//  Copyright (c) 2013 Carl. All rights reserved.
//

#import "QuestionView.h"

@implementation QuestionView
@synthesize quesTextView;
@synthesize answerStr;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        rect = frame;
        rect.origin.x = 0;
        self.quesTextView = [[UIWebView alloc]initWithFrame:rect];
        self.quesTextView.dataDetectorTypes = UIDataDetectorTypeNone;
        [self addSubview:self.quesTextView];

        // Initialization code
    }
    return self;
}

-(void)initWebView:(NSString *)str
{
    self.quesTextView = [[UIWebView alloc]initWithFrame:rect];
    self.quesTextView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.quesTextView loadHTMLString:str baseURL:nil];
//    self.quesTextView.delegate = self;
    [self addSubview:self.quesTextView];

}

-(void)setTextViewText:(NSString *)textViewText
{
    _textViewText = textViewText;
    NSError * error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a href=\"[^\"]+\">([^<]+)</a>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:textViewText options:0 range:NSMakeRange(0, [textViewText length]) withTemplate:@"$1"];
    NSString *css =[NSString stringWithFormat:@"<html> \n"
                   "<head> \n"
                    "<style type=\"text/css\"> \n"
                    "a{-text-decoration: none;-webkit-touch-callout: none;-webkit-user-select: none;\n}"
                    "</style> \n"
                    "</head> \n"
                    "<body>%@</body> \n"
                    "</html>",modifiedString];

    [self.quesTextView loadHTMLString:css baseURL:nil];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    return NO;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
     [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'black'"];
//    NSString * jsCallBack = @"window.getSelection().removeAllRanges();";
//    [webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

@end
