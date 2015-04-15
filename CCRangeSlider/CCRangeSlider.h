//
//  CCRangeSlider.h
//  CCRangeSliderDemo
//
//  Created by Chuang HsuanChih on 4/9/15.
//  Copyright (c) 2015 Hsuan-Chih Chuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCRangeSlider : UIControl

/*
 *  Slider range
 */
@property (nonatomic, assign) CGFloat minValue, maxValue;

/*
 *  Handle positions
 */
@property (nonatomic, assign) CGFloat lowerValue, upperValue;
@property (nonatomic, readonly) CGPoint lowerHandleCenter, upperHandleCenter;

/*
 *  Step size
 */
@property (nonatomic, assign) CGFloat stepSize;

/*
 *  Slider Handle customisation
 */
@property (nonatomic, strong) UIImage *handleImage;
@property (nonatomic, strong) UIImage *handleHighlightedImage;
@property (nonatomic, assign) CGSize  handleSize;
- (void) setHandleImage:(UIImage *)handleImage withSize:(CGSize)size;

/*
 *  Track customisations
 */
@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *trackHighlightColor;
@property (nonatomic, strong) UIImage *trackImage;
@property (nonatomic, strong) UIImage *trackHighlightImage;
@property (nonatomic, assign) CGFloat trackHeight;
@property (nonatomic, assign) CGFloat trackCornerRadius;

@end
