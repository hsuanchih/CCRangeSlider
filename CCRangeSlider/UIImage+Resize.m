//
//  UIImage+Resize.m
//  CCRangeSliderDemo
//
//  Created by Chuang HsuanChih on 4/10/15.
//  Copyright (c) 2015 Hsuan-Chih Chuang. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage*) scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
