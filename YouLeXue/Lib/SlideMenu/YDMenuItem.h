//
//  YDMenuItem.h
//  SideMenuDemo
//
//  Created by Peter van de Put on 12/09/2013.
//  Copyright (c) 2013 Peter van de Put. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDMenuItem : NSObject
{
    NSString* menuTitle;
    NSString* backgroundColorHexString;
    NSString* textColorHexString;
    NSString* controllerTAG;
    NSString* imageName;
}
@property (nonatomic, retain) NSString *menuTitle;
@property (nonatomic, retain) NSString *backgroundColorHexString;
@property (nonatomic, retain) NSString *textColorHexString;
@property (nonatomic, retain) NSString* controllerTAG;
@property (nonatomic, retain) NSString* imageName;
-(id)initWithTitle:(NSString *)title backgroundColorHexString:(NSString *)bgColorHexString textColorHexString:(NSString *)txtColorHexString viewControllerTAG:(NSString *)tag imageName:(NSString *)image;
@end
