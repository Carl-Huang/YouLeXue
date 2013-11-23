//
//  UIImage+SaveToLocal.h
//  YouLeXue
//
//  Created by vedon on 20/11/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SaveToLocal)
+(BOOL)saveImage:(UIImage *)image name:(NSString *)name;
+(UIImage *)readImageWithName:(NSString *)name;
+(NSString *)getFolderName;
@end
