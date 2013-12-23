//
//  VDAlertView.m
//  CustomiseAlertViewForIos7
//
//  Created by vedon on 21/10/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//
#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)


#import "VDAlertView.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark UIWindow
//*****************************************************
@interface VDAlertOverlayWindow : UIWindow
{
}
@property (nonatomic,retain) UIWindow* oldKeyWindow;
@end

@implementation  VDAlertOverlayWindow
@synthesize oldKeyWindow;

- (void) makeKeyAndVisible
{
	self.oldKeyWindow = [[UIApplication sharedApplication] keyWindow];
	self.windowLevel = UIWindowLevelAlert;
	[super makeKeyAndVisible];
}

- (void) resignKeyWindow
{
	[super resignKeyWindow];
	[self.oldKeyWindow makeKeyWindow];
}

- (void) drawRect: (CGRect) rect
{
//在考试的 app中不需要渐变背景
//	CGFloat width			= self.frame.size.width;
//	CGFloat height			= self.frame.size.height;
//	CGFloat locations[3]	= { 0.0, 0.5, 1.0 	};
//	CGFloat components[12]	= {	1, 1, 1, 0.5,
//		0, 0, 0, 0.5,
//		0, 0, 0, 0.7	};
//	
//	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
//	CGGradientRef backgroundGradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 3);
//	CGColorSpaceRelease(colorspace);
//	
//	CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(),
//								backgroundGradient,
//								CGPointMake(width/2, height/2), 0,
//								CGPointMake(width/2, height/2), width,
//								0);
//	
//	CGGradientRelease(backgroundGradient);
}

- (void) dealloc
{
	self.oldKeyWindow = nil;
	
	NSLog( @"VDAlertView: VDAlertOverlayWindow dealloc" );
	
	[super dealloc];
}

@end


//*****************************************************
#pragma mark VDViewController
@interface VDViewController : UIViewController
{
}
@end
@implementation VDViewController
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	VDAlertView* av = [self.view.subviews lastObject];
	if (!av || ![av isKindOfClass:[VDAlertView class]])
		return;
	// resize the alertview if it wants to make use of any extra space (or needs to contract)
	[UIView animateWithDuration:duration
					 animations:^{
						 [av sizeToFit];
						 av.center = CGPointMake( CGRectGetMidX( self.view.bounds ), CGRectGetMidY( self.view.bounds ) );;
						 av.frame = CGRectIntegral( av.frame );
					 }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    VDAlertView* av = [self.view.subviews lastObject];
	if (!av || ![av isKindOfClass:[VDAlertView class]]) return;
    if ([av.delegate respondsToSelector:@selector(touchAlertScreen:)]) {
        [av.delegate touchAlertScreen:av];
    }
}

- (void) dealloc
{
	NSLog( @"VDAlertView: VDAlertViewController dealloc" );
	[super dealloc];
}

@end
//*****************************************************
@interface VDAlertView (private)
@property (nonatomic, readonly) NSMutableArray* buttons;
@property (nonatomic, readonly) UILabel* titleLabel;
@property (nonatomic, readonly) UILabel* messageLabel;
@property (nonatomic, readonly) UITextView* messageTextView;
- (void) TSAlertView_commonInit;
- (void) releaseWindow: (int) buttonIndex;
- (void) pulse;
- (CGSize) titleLabelSize;
- (CGSize) messageLabelSize;
- (CGSize) inputTextFieldSize;
- (CGSize) buttonsAreaSize_Stacked;
- (CGSize) buttonsAreaSize_SideBySide;
- (CGSize) recalcSizeAndLayout: (BOOL) layout;
@end

#pragma mark - VDAlertView
@implementation VDAlertView

@synthesize delegate;
@synthesize cancelButtonIndex;
@synthesize firstOtherButtonIndex;
@synthesize buttonLayout;
@synthesize width;
@synthesize maxHeight;
@synthesize usesMessageTextView;
@synthesize backgroundImage = _backgroundImage;
@synthesize style;

const CGFloat kTSAlertView_LeftMargin	= 10.0;
const CGFloat kTSAlertView_TopMargin	= 16.0;
const CGFloat kTSAlertView_BottomMargin = 15.0;
const CGFloat kTSAlertView_RowMargin	= 5.0;
const CGFloat kTSAlertView_ColumnMargin = 10.0;

- (id) init
{
	if ( ( self = [super init] ) )
	{
		[self TSAlertView_commonInit];
	}
	return self;
}

- (id) initWithFrame:(CGRect)frame
{
	if ( ( self = [super initWithFrame: frame] ) )
	{
		[self TSAlertView_commonInit];
		
		if ( !CGRectIsEmpty( frame ) )
		{
			width = frame.size.width;
			maxHeight = frame.size.height;
		}
	}
	return self;
}

- (id) initWithTitle: (NSString *) t message: (NSString *) m delegate: (id) d cancelButtonTitle: (NSString *) cancelButtonTitle otherButtonTitles: (NSString *) otherButtonTitles, ...
{
	if ( (self = [super init] ) )
	{
		self.title = t;
		self.message = m;
		self.delegate = d;
		
		if ( nil != cancelButtonTitle )
		{
			[self addButtonWithTitle: cancelButtonTitle ];
			self.cancelButtonIndex = 0;
		}
		
		if ( nil != otherButtonTitles )
		{
			firstOtherButtonIndex = [self.buttons count];
			[self addButtonWithTitle: otherButtonTitles ];
			
			va_list args;
			va_start(args, otherButtonTitles);
			
			id arg;
			while ( nil != ( arg = va_arg( args, id ) ) )
			{
				if ( ![arg isKindOfClass: [NSString class] ] )
					return nil;
				
				[self addButtonWithTitle: (NSString*)arg ];
			}
		}
	}
	
	return self;
}

- (CGSize) sizeThatFits: (CGSize) unused
{
	CGSize s = [self recalcSizeAndLayout: NO];
	return s;
}

- (void) layoutSubviews
{
	[self recalcSizeAndLayout: YES];
}

- (void) drawRect:(CGRect)rect
{
	[self.backgroundImage drawInRect: rect];
}

-(BOOL)CurrentVersionIsIOS7
{
    return NLSystemVersionGreaterOrEqualThan(7.0);
}

- (void)dealloc
{
	[_backgroundImage release];
	[_buttons release];
	[_titleLabel release];
	[_messageLabel release];
	[_messageTextView release];
	[_messageTextViewMaskImageView release];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self ];
	
	NSLog( @"VDAlertView: VDAlertOverlayWindow dealloc" );
	
    [super dealloc];
}


- (void) TSAlertView_commonInit
{
	self.backgroundColor = [UIColor clearColor];
	self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	
	// defaults:
	style = VDAlertViewStyleNormal;
	self.width = 0; // set to default
	self.maxHeight = 0; // set to default
	buttonLayout = VDAlertViewButtonLayoutNormal;
	cancelButtonIndex = -1;
	firstOtherButtonIndex = -1;
}

- (void) setWidth:(CGFloat) w
{
	if ( w <= 0 )
		w = 284;
	
	width = MAX( w, self.backgroundImage.size.width );
}

- (CGFloat) width
{
	if ( nil == self.superview )
		return width;
	
	CGFloat maxWidth = self.superview.bounds.size.width - 20;
	
	return MIN( width, maxWidth );
}

- (void) setMaxHeight:(CGFloat) h
{
	if ( h <= 0 )
		h = 358;
	
	maxHeight = MAX( h, self.backgroundImage.size.height );
}

- (CGFloat) maxHeight
{
	if ( nil == self.superview )
		return maxHeight;
	
	return MIN( maxHeight, self.superview.bounds.size.height - 20 );
}

- (void) setStyle:(VDAlertViewStyle)newStyle
{
	if ( style != newStyle )
	{
		style = newStyle;
		
		if ( style == VDAlertViewStyleInput )
		{
			// need to watch for keyboard
			[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector( onKeyboardWillShow:) name: UIKeyboardWillShowNotification object: nil];
			[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector( onKeyboardWillHide:) name: UIKeyboardWillHideNotification object: nil];
		}
	}
}

- (void) onKeyboardWillShow: (NSNotification*) note
{
	NSValue* v = [note.userInfo objectForKey: UIKeyboardFrameEndUserInfoKey];
	CGRect kbframe = [v CGRectValue];
	kbframe = [self.superview convertRect: kbframe fromView: nil];
	
	if ( CGRectIntersectsRect( self.frame, kbframe) )
	{
		CGPoint c = self.center;
		
		if ( self.frame.size.height > kbframe.origin.y - 20 )
		{
			self.maxHeight = kbframe.origin.y - 20;
			[self sizeToFit];
			[self layoutSubviews];
		}
		
		c.y = kbframe.origin.y / 2;
		
		[UIView animateWithDuration: 0.2
						 animations: ^{
							 self.center = c;
							 self.frame = CGRectIntegral(self.frame);
						 }];
	}
}

- (void) onKeyboardWillHide: (NSNotification*) note
{
	[UIView animateWithDuration: 0.2
					 animations: ^{
						 self.center = CGPointMake( CGRectGetMidX( self.superview.bounds ), CGRectGetMidY( self.superview.bounds ));
						 self.frame = CGRectIntegral(self.frame);
					 }];
}

- (NSMutableArray*) buttons
{
	if ( _buttons == nil )
	{
		_buttons = [[NSMutableArray arrayWithCapacity:4] retain];
	}
	
	return _buttons;
}


-(void)setCustomSubview:(UIView *)customSubview
{
    _customSubview = customSubview;
    
    [ self addSubview:customSubview ];
}


- (UILabel*) titleLabel
{
	if ( _titleLabel == nil )
	{
		_titleLabel = [[UILabel alloc] init];
		_titleLabel.font = [UIFont boldSystemFontOfSize: 18];
		_titleLabel.backgroundColor = [UIColor clearColor];
        if ([self CurrentVersionIsIOS7]) {
            _titleLabel.textColor = [UIColor blackColor];
        }else
        {
            _titleLabel.textColor = [UIColor whiteColor];
        }
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
		_titleLabel.numberOfLines = 0;
        
        [self addSubview: _titleLabel];
	}
	
	return _titleLabel;
}

- (UILabel*) messageLabel
{
	if ( _messageLabel == nil )
	{
		_messageLabel = [[UILabel alloc] init];
		_messageLabel.font = [UIFont systemFontOfSize: 16];
		_messageLabel.backgroundColor = [UIColor clearColor];
//        if ([self CurrentVersionIsIOS7]) {
//            _messageLabel.textColor = [UIColor blackColor];
//        }else
//        {
//            _messageLabel.textColor = [UIColor whiteColor];
//        }
		_messageLabel.textColor = [UIColor blackColor];
		_messageLabel.textAlignment = NSTextAlignmentCenter;
		_messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
		_messageLabel.numberOfLines = 0;
        
        [self addSubview: _messageLabel];
	}
	
	return _messageLabel;
}

- (UITextView*) messageTextView
{
	if ( _messageTextView == nil )
	{
		_messageTextView = [[UITextView alloc] init];
		_messageTextView.editable = NO;
		_messageTextView.font = [UIFont systemFontOfSize: 16];
		_messageTextView.backgroundColor = [UIColor whiteColor];
		_messageTextView.textColor = [UIColor darkTextColor];
		_messageTextView.textAlignment = NSTextAlignmentLeft;
		_messageTextView.bounces = YES;
		_messageTextView.alwaysBounceVertical = YES;
		_messageTextView.layer.cornerRadius = 5;
        
        [self addSubview: _messageTextView];
	}
	
	return _messageTextView;
}

- (UIImageView*) messageTextViewMaskView
{
	if ( _messageTextViewMaskImageView == nil )
	{
		UIImage* shadowImage = [[UIImage imageNamed:@"VDAlertViewMessageListViewShadow.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:7];
		
		_messageTextViewMaskImageView = [[UIImageView alloc] initWithImage: shadowImage];
		_messageTextViewMaskImageView.userInteractionEnabled = NO;
		_messageTextViewMaskImageView.layer.masksToBounds = YES;
		_messageTextViewMaskImageView.layer.cornerRadius = 6;
        
        [self addSubview: _messageTextViewMaskImageView];
	}
	return _messageTextViewMaskImageView;
}

- (UITextField*) inputTextField
{
	if ( _inputTextField == nil )
	{
		_inputTextField = [[UITextField alloc] init];
		_inputTextField.borderStyle = UITextBorderStyleRoundedRect;
        
        [self addSubview: _inputTextField];
	}
	
	return _inputTextField;
}

- (UIImage*) backgroundImage
{
	if ( _backgroundImage == nil )
	{
        if ([self CurrentVersionIsIOS7]) {
            self.backgroundImage = [[UIImage imageNamed: @"VDAlertViewBackground2.png"] stretchableImageWithLeftCapWidth: 15 topCapHeight: 150];
        }else
        {
            self.backgroundImage = [[UIImage imageNamed: @"VDAlertViewBackground2.png"] stretchableImageWithLeftCapWidth: 15 topCapHeight: 150];
        }
		
	}
	
	return _backgroundImage;
}

- (void) setTitle:(NSString *)t
{
	self.titleLabel.text = t;
}

- (NSString*) title
{
	return self.titleLabel.text;
}

- (void) setMessage:(NSString *)t
{
	self.messageLabel.text = t;
	self.messageTextView.text = t;
}

- (NSString*) message
{
	return self.messageLabel.text;
}

- (NSInteger) numberOfButtons
{
	return [self.buttons count];
}

- (void) setCancelButtonIndex:(NSInteger)buttonIndex
{
	// avoid a NSRange exception
	if ( buttonIndex < 0 || buttonIndex >= [self.buttons count] )
		return;
	
	cancelButtonIndex = buttonIndex;
	
	UIButton* b = [self.buttons objectAtIndex: buttonIndex];
	
	UIImage* buttonBgNormal = [UIImage imageNamed: @"VDAlertViewCancelButtonBackground.png"];
	buttonBgNormal = [buttonBgNormal stretchableImageWithLeftCapWidth: buttonBgNormal.size.width / 2.0 topCapHeight: buttonBgNormal.size.height / 2.0];
	[b setBackgroundImage: buttonBgNormal forState: UIControlStateNormal];
	
	UIImage* buttonBgPressed = [UIImage imageNamed: @"VDAlertViewButtonBackground_Highlighted.png"];
	buttonBgPressed = [buttonBgPressed stretchableImageWithLeftCapWidth: buttonBgPressed.size.width / 2.0 topCapHeight: buttonBgPressed.size.height / 2.0];
	[b setBackgroundImage: buttonBgPressed forState: UIControlStateHighlighted];
}

- (BOOL) isVisible
{
	return self.superview != nil;
}

- (NSInteger) addButtonWithTitle: (NSString *) t
{
	UIButton* b = [UIButton buttonWithType: UIButtonTypeCustom];
	[b setTitle: t forState: UIControlStateNormal];
	
	UIImage* buttonBgNormal = [UIImage imageNamed: @"VDAlertViewCancelButtonBackground.png"];
	buttonBgNormal = [buttonBgNormal stretchableImageWithLeftCapWidth: buttonBgNormal.size.width / 2.0 topCapHeight: buttonBgNormal.size.height / 2.0];
	[b setBackgroundImage: buttonBgNormal forState: UIControlStateNormal];
	
	UIImage* buttonBgPressed = [UIImage imageNamed: @"VDAlertViewButtonBackground_Highlighted.png"];
	buttonBgPressed = [buttonBgPressed stretchableImageWithLeftCapWidth: buttonBgPressed.size.width / 2.0 topCapHeight: buttonBgPressed.size.height / 2.0];
	[b setBackgroundImage: buttonBgPressed forState: UIControlStateHighlighted];
	
	[b addTarget: self action: @selector(onButtonPress:) forControlEvents: UIControlEventTouchUpInside];
	
	[self.buttons addObject: b];
	
    [self addSubview: b];
    
	[self setNeedsLayout];
	
	return self.buttons.count-1;
}

- (NSString *) buttonTitleAtIndex:(NSInteger)buttonIndex
{
	// avoid a NSRange exception
	if ( buttonIndex < 0 || buttonIndex >= [self.buttons count] )
		return nil;
	
	UIButton* b = [self.buttons objectAtIndex: buttonIndex];
	
	return [b titleForState: UIControlStateNormal];
}

- (void) dismissWithClickedButtonIndex: (NSInteger)buttonIndex animated: (BOOL) animated
{
	if ( self.style == VDAlertViewStyleInput && [self.inputTextField isFirstResponder] )
	{
		[self.inputTextField resignFirstResponder];
	}
	
	if ( [self.delegate respondsToSelector: @selector(alertView:willDismissWithButtonIndex:)] )
	{
		[self.delegate alertView: self willDismissWithButtonIndex: buttonIndex ];
	}
	
	if ( animated )
	{
		self.window.backgroundColor = [UIColor clearColor];
		self.window.alpha = 1;
		
		[UIView animateWithDuration: 0.2
						 animations: ^{
							 [self.window resignKeyWindow];
							 self.window.alpha = 0;
						 }
						 completion: ^(BOOL finished) {
							 [self releaseWindow: buttonIndex];
						 }];
		
		[UIView commitAnimations];
	}
	else
	{
		[self.window resignKeyWindow];
		
		[self releaseWindow: buttonIndex];
	}
}

- (void) releaseWindow: (int) buttonIndex
{
	if ( [self.delegate respondsToSelector: @selector(alertView:didDismissWithButtonIndex:)] )
	{
		[self.delegate alertView: self didDismissWithButtonIndex: buttonIndex ];
	}
	
	// the one place we release the window we allocated in "show"
	// this will propogate releases to us (TSAlertView), and our TSAlertViewController
	
	[self.window release];
}

- (void) show
{
	[[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:[NSDate date]];
	
    
    
    
	VDViewController* avc = [[[VDViewController alloc] init] autorelease];
	avc.view.backgroundColor = [UIColor clearColor];
	
	// $important - the window is released only when the user clicks an alert view button
	VDAlertOverlayWindow* ow = [[VDAlertOverlayWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
	ow.alpha = 0.0;
	ow.backgroundColor = [UIColor clearColor];
	ow.rootViewController = avc;
	[ow makeKeyAndVisible];
	
	// fade in the window
	[UIView animateWithDuration: 0.2 animations: ^{
		ow.alpha = 1;
	}];
	
	// add and pulse the alertview
	// add the alertview
	[avc.view addSubview: self];
	[self sizeToFit];
	self.center = CGPointMake( CGRectGetMidX( avc.view.bounds ), CGRectGetMidY( avc.view.bounds ) );;
	self.frame = CGRectIntegral( self.frame );
    
    if ( [self.delegate respondsToSelector: @selector(willPresentAlertView:)] )
    {
        [self.delegate willPresentAlertView: self ];
    }
    
	[self pulse];
	
	if ( self.style == VDAlertViewStyleInput )
	{
		[self layoutSubviews];
		[self.inputTextField becomeFirstResponder];
	}
}

- (void) pulse
{
	// pulse animation thanks to:  http://delackner.com/blog/2009/12/mimicking-uialertviews-animated-transition/
    self.transform = CGAffineTransformMakeScale(0.6, 0.6);
	[UIView animateWithDuration: 0.2
					 animations: ^{
						 self.transform = CGAffineTransformMakeScale(1.1, 1.1);
					 }
					 completion: ^(BOOL finished){
						 [UIView animateWithDuration:1.0/15.0
										  animations: ^{
											  self.transform = CGAffineTransformMakeScale(0.9, 0.9);
										  }
										  completion: ^(BOOL finished){
											  [UIView animateWithDuration:1.0/7.5
															   animations: ^{
																   self.transform = CGAffineTransformIdentity;
                                                                   
                                                                   if ( [self.delegate respondsToSelector: @selector(didPresentAlertView:)] )
                                                                   {
                                                                       [self.delegate didPresentAlertView: self ];
                                                                   }
															   }];
										  }];
					 }];
	
}

- (void) onButtonPress: (id) sender
{
	int buttonIndex = [_buttons indexOfObjectIdenticalTo: sender];
	
	if ( [self.delegate respondsToSelector: @selector(alertView:clickedButtonAtIndex:)] )
	{
		[self.delegate alertView: self clickedButtonAtIndex: buttonIndex ];
	}
	
	if ( buttonIndex == self.cancelButtonIndex )
	{
		if ( [self.delegate respondsToSelector: @selector(alertViewCancel:)] )
		{
			[self.delegate alertViewCancel: self ];
		}
	}
	
	[self dismissWithClickedButtonIndex: buttonIndex  animated: YES];
}

- (CGSize) recalcSizeAndLayout: (BOOL) layout
{
	BOOL	stacked = !(self.buttonLayout == VDAlertViewButtonLayoutNormal && [self.buttons count] == 2 );
	
	CGFloat maxWidth = self.width - (kTSAlertView_LeftMargin * 2);
	
	CGSize  titleLabelSize = [self titleLabelSize];
	CGSize  messageViewSize = [self messageLabelSize];
	CGSize  inputTextFieldSize = [self inputTextFieldSize];
	CGSize  buttonsAreaSize = stacked ? [self buttonsAreaSize_Stacked] : [self buttonsAreaSize_SideBySide];
	CGSize  customSubviewSize = ( self.customSubview ) ? self.customSubview.bounds.size : CGSizeZero;
    
	CGFloat inputRowHeight = self.style == VDAlertViewStyleInput ? inputTextFieldSize.height + kTSAlertView_RowMargin : 0;
	
	CGFloat totalHeight = kTSAlertView_TopMargin + titleLabelSize.height + kTSAlertView_RowMargin + messageViewSize.height + customSubviewSize.height + kTSAlertView_RowMargin + inputRowHeight + kTSAlertView_RowMargin + buttonsAreaSize.height + kTSAlertView_BottomMargin;
	
	if ( totalHeight > self.maxHeight )
	{
		// too tall - we'll condense by using a textView (with scrolling) for the message
		
		totalHeight -= messageViewSize.height;
		//$$what if it's still too tall?
		messageViewSize.height = self.maxHeight - totalHeight;
		
		totalHeight = self.maxHeight;
		
		self.usesMessageTextView = YES;
	}
	
	if ( layout )
	{
		// title
		CGFloat y = kTSAlertView_TopMargin;
		if ( self.title != nil )
		{
			self.titleLabel.frame = CGRectMake( kTSAlertView_LeftMargin, y, titleLabelSize.width, titleLabelSize.height );
			y += titleLabelSize.height + kTSAlertView_RowMargin;
		}
		
		// message
		if ( self.message != nil )
		{
			if ( self.usesMessageTextView )
			{
				self.messageTextView.frame = CGRectMake( kTSAlertView_LeftMargin, y, messageViewSize.width, messageViewSize.height );
				y += messageViewSize.height + kTSAlertView_RowMargin;
				
                
                //添加遮罩，后来发现感觉不好，可以comment out to check out what style it will be
//				UIImageView* maskImageView = [self messageTextViewMaskView];
//				maskImageView.frame = self.messageTextView.frame;
			}
			else
			{
				self.messageLabel.frame = CGRectMake( kTSAlertView_LeftMargin, y, messageViewSize.width, messageViewSize.height );
				y += messageViewSize.height + kTSAlertView_RowMargin;
			}
		}
		
		// input
		if ( self.style == VDAlertViewStyleInput )
		{
			self.inputTextField.frame = CGRectMake( kTSAlertView_LeftMargin, y, inputTextFieldSize.width, inputTextFieldSize.height );
			y += inputTextFieldSize.height + kTSAlertView_RowMargin;
		}
		
        if( self.customSubview )
        {
            self.customSubview.frame = CGRectMake( kTSAlertView_LeftMargin, y, customSubviewSize.width, customSubviewSize.height );
            y += customSubviewSize.height + kTSAlertView_RowMargin;
        }
        
        
		// buttons
        if ([self.buttons count]) {
            CGFloat buttonHeight = [[self.buttons objectAtIndex:0] sizeThatFits: CGSizeZero].height;
            if ( stacked )
            {
                CGFloat buttonWidth = maxWidth;
                NSInteger leftMargin = kTSAlertView_LeftMargin;
                if ([self.buttons count]==1) {
                    buttonWidth = 120;
                    leftMargin = 90;
                }
                
                
                for ( UIButton* b in self.buttons )
                {
                    b.frame = CGRectMake( leftMargin, y, buttonWidth, buttonHeight );
                    y += buttonHeight + kTSAlertView_RowMargin;
                }
            }
            else
            {
                CGFloat buttonWidth = (maxWidth - kTSAlertView_ColumnMargin) / 2.0;
                CGFloat x = kTSAlertView_LeftMargin;
                for ( UIButton* b in self.buttons )
                {
                    b.frame = CGRectMake( x, y, buttonWidth, buttonHeight );
                    x += buttonWidth + kTSAlertView_ColumnMargin;
                }
            }
        }
		
	}
	
	return CGSizeMake( self.width, totalHeight );
}

- (CGSize) titleLabelSize
{
	CGFloat maxWidth = self.width - (kTSAlertView_LeftMargin * 2);
	CGSize s = [self.titleLabel.text sizeWithFont: self.titleLabel.font constrainedToSize: CGSizeMake(maxWidth, 1000) lineBreakMode: self.titleLabel.lineBreakMode];
	if ( s.width < maxWidth )
		s.width = maxWidth;
	
	return s;
}

- (CGSize) messageLabelSize
{
	CGFloat maxWidth = self.width - (kTSAlertView_LeftMargin * 2);
	CGSize s = [self.messageLabel.text sizeWithFont: self.messageLabel.font constrainedToSize: CGSizeMake(maxWidth, 1000) lineBreakMode: self.messageLabel.lineBreakMode];
	if ( s.width < maxWidth )
		s.width = maxWidth;
	
	return s;
}

- (CGSize) inputTextFieldSize
{
	if ( self.style == VDAlertViewStyleNormal)
		return CGSizeZero;
	
	CGFloat maxWidth = self.width - (kTSAlertView_LeftMargin * 2);
	
	CGSize s = [self.inputTextField sizeThatFits: CGSizeZero];
	
	return CGSizeMake( maxWidth, s.height );
}

- (CGSize) buttonsAreaSize_SideBySide
{
	CGFloat maxWidth = self.width - (kTSAlertView_LeftMargin * 2);
	CGSize bs = CGSizeZero;
    if ([self.buttons count]) {
        bs = [[self.buttons objectAtIndex:0] sizeThatFits: CGSizeZero];
    }	
	bs.width = maxWidth;
	
	return bs;
}

- (CGSize) buttonsAreaSize_Stacked
{
	CGFloat maxWidth = self.width - (kTSAlertView_LeftMargin * 2);
	int buttonCount = [self.buttons count];
	CGSize bs = CGSizeZero;
    if ([self.buttons count]) {
        bs = [[self.buttons objectAtIndex:0] sizeThatFits: CGSizeZero];
    }
	
	
	bs.width = maxWidth;
	
	bs.height = (bs.height * buttonCount) + (kTSAlertView_RowMargin * (buttonCount-1));
	
	return bs;
}

@end

#pragma mark - ProcessingView

@interface MProgressview:UIView

@property (nonatomic, retain) UIProgressView* progressView;
@property (nonatomic, retain) UILabel* progressLabel;

@end

@implementation MProgressview
@synthesize progressView;
@synthesize progressLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)initProcessingView
{
    progressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar] autorelease];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    // add progress view
    progressLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)] autorelease];
    progressLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    progressLabel.backgroundColor = [UIColor clearColor];//comment it to look label's position
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.adjustsFontSizeToFitWidth = YES;
}


- (void)setProgress:(float)progress
{
    self.progressView.progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%2.0f%%", progress * 100];
}

- (float)getProgress
{
	return self.progressView.progress;
}

- (void)stepProgress:(float)progress
{
    self.progressView.progress += progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%2.0f%%", self.progressView.progress * 100];
}

@end

