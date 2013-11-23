//
//  UIImage+SaveToLocal.m
//  YouLeXue
//
//  Created by vedon on 20/11/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//




#import "UIImage+SaveToLocal.h"

@implementation UIImage (SaveToLocal)
+(BOOL)saveImage:(UIImage *)image name:(NSString *)name
{
    NSData *imageData = UIImagePNGRepresentation(image);
    if ([imageData writeToFile:[[self getFolderName] stringByAppendingPathComponent:name] atomically:YES]) {
        NSLog(@"successfully write image to local disk");
        return YES;
    }else
    {
        NSLog(@"Failed to write image to locatl");
        return NO;
    }
}

+(UIImage *)readImageWithName:(NSString *)name
{
    NSString *pathName = [[self getFolderName]stringByAppendingPathComponent:name];
    NSData *data = [[NSData alloc]initWithContentsOfFile:pathName];
    if (data) {
        UIImage * image = [[UIImage alloc]initWithData:data];
        return image;
    }
    return nil;
}

//创建本地图片目录
+(NSString *)getFolderName
{
    NSFileManager * defaultManager = [NSFileManager defaultManager];
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileDirectory = [path stringByAppendingPathComponent:@"PicFolder"];
    
    if (![defaultManager fileExistsAtPath:fileDirectory]) {
        [defaultManager createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }else
    {
        NSLog(@"Directory already exists");
    }
    return fileDirectory;
}


@end
