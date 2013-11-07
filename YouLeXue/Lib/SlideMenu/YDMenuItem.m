//
//  YDMenuItem.m
//  SideMenuDemo
//
//  Created by Peter van de Put on 12/09/2013.
//  Copyright (c) 2013 Peter van de Put. All rights reserved.
//

#import "YDMenuItem.h"
 
@implementation YDMenuItem

@synthesize menuTitle,backgroundColorHexString,textColorHexString,controllerTAG,imageName;

-(id)initWithTitle:(NSString *)title backgroundColorHexString:(NSString *)bgColorHexString textColorHexString:(NSString *)txtColorHexString viewControllerTAG:(NSString *)tag  imageName:(NSString *)image
{self = [super init];
	if ( self != nil)
	{
        menuTitle=title;
        backgroundColorHexString=bgColorHexString;
        textColorHexString=txtColorHexString;
        controllerTAG=tag;
        imageName=image;
	}
	return self;
}
@end
