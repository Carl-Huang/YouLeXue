//
//  VDAlertView.h
//  CustomiseAlertViewForIos7
//
//  Created by vedon on 21/10/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
	VDAlertViewButtonLayoutNormal,
	VDAlertViewButtonLayoutStacked
	
} VDAlertViewButtonLayout;

typedef enum
{
	VDAlertViewStyleNormal,
	VDAlertViewStyleInput,
	
} VDAlertViewStyle;
@class VDViewController;
@class VDAlertView;

@protocol VDAlertViewDelegate <NSObject>
@optional

- (void)alertView:(VDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)alertViewCancel:(VDAlertView *)alertView;

- (void)willPresentAlertView:(VDAlertView *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(VDAlertView *)alertView;  // after animation

- (void)alertView:(VDAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(VDAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

- (void)touchAlertScreen:(VDAlertView *)alertView;

@end

@interface VDAlertView : UIView
{
    UIImage*				_backgroundImage;
	UILabel*				_titleLabel;
	UILabel*				_messageLabel;
	UITextView*				_messageTextView;
	UIImageView*			_messageTextViewMaskImageView;
	UITextField*			_inputTextField;
	NSMutableArray*			_buttons;

}
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, assign) id<VDAlertViewDelegate> delegate;
@property(nonatomic) NSInteger cancelButtonIndex;
@property(nonatomic, readonly) NSInteger firstOtherButtonIndex;
@property(nonatomic, readonly) NSInteger numberOfButtons;
@property(nonatomic, readonly, getter=isVisible) BOOL visible;

@property(nonatomic, assign) UIView *customSubview;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat maxHeight;
@property(nonatomic, assign) BOOL usesMessageTextView;
@property(nonatomic, retain) UIImage* backgroundImage;
@property(nonatomic, readonly) UITextField* inputTextField;
@property(nonatomic, assign) VDAlertViewButtonLayout buttonLayout;
@property(nonatomic, assign) VDAlertViewStyle style;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (NSInteger)addButtonWithTitle:(NSString *)title;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
- (void)show;


@end
