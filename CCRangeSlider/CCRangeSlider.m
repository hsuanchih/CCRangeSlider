//
//  CCRangeSlider.m
//  CCRangeSliderDemo
//
//  Created by Chuang HsuanChih on 4/9/15.
//  Copyright (c) 2015 Hsuan-Chih Chuang. All rights reserved.
//

#import "CCRangeSlider.h"
#import "UIImage+Resize.h"

@interface CCRangeSlider()
{
    CGFloat __stepSize;
    CGPoint _lastTouchPoint;
}
@property (nonatomic, strong) UIImageView *lowerHandle, *upperHandle;
@property (nonatomic, strong) NSArray *handles;
@property (nonatomic, strong) UIView *trackView, *trackHighlightView;
@property (nonatomic, strong) UIImageView *trackImageView, *trackHighlightImageView;
@end


@implementation CCRangeSlider


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        [self setDefaults];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setDefaults];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setDefaults];
    }
    return self;
}

- (void) layoutSubviews
{
    if (![self.subviews containsObject:self.trackView])
    {
        [self addSubview:self.trackView];
        self.trackView.frame = CGRectMake(CGRectGetMinX(self.bounds) + CGRectGetWidth(self.lowerHandle.bounds)/2.0,
                                          (CGRectGetHeight(self.bounds) - _trackHeight)/2.0,
                                          CGRectGetWidth(self.bounds) - CGRectGetWidth(self.lowerHandle.bounds),
                                          _trackHeight);
        
        [self.trackView addSubview:self.trackImageView];
        self.trackImageView.frame = self.trackView.bounds;
        
        [self.trackView insertSubview:self.trackHighlightView aboveSubview:self.trackImageView];
        self.trackHighlightView.frame = self.trackView.bounds;
        
        [self.trackHighlightView addSubview:self.trackHighlightImageView];
        self.trackHighlightImageView.frame = self.trackHighlightView.bounds;
    }
    
    if (![self.subviews containsObject:self.lowerHandle])
    {
        [self addSubview:self.lowerHandle];
    }
    
    if (![self.subviews containsObject:self.upperHandle])
    {
        [self addSubview:self.upperHandle];
    }
    
    [self setLowerValue:self.lowerValue];
    [self setUpperValue:self.upperValue];
    
}



#pragma mark - Private utility methods

- (void) setDefaults
{
    [self setTrackDefaults];
    [self setHandleDefaults];
    [self setValueDefaults];
}

- (void) setHandleDefaults
{
    UIImage *handleImage = [UIImage imageNamed:@"UISliderHandleDefault.png"];
    [self setHandleImage:handleImage
                withSize:CGSizeMake(handleImage.size.width/handleImage.size.height*40.0,
                                    40.0)];
}

- (void) setTrackDefaults
{
    self.trackHeight = 2.0;
    self.trackCornerRadius = 3.0;
    self.trackColor = [UIColor lightGrayColor];
    self.trackHighlightColor = [UIColor colorWithRed:59/255.0
                                               green:153/255.0
                                                blue:251/255.0
                                               alpha:1.0];
}

- (void) setValueDefaults
{
    __stepSize = self.stepSize = 1.0;
    _minValue = 0.0;
    _maxValue = 100.0;
    _lowerValue = _minValue;
    _upperValue = _maxValue;
}

- (void) updateHandleImageView
{
    for (UIImageView *handle in self.handles)
    {
        handle.image = _handleImage;
        CGRect bounds = handle.bounds;
        bounds.size = _handleImage.size;
        handle.bounds = bounds;
    }
}

- (CGFloat) positionForValue:(CGFloat)value
{
    if ( value < self.minValue )
    {
        return CGRectGetMinX(self.trackView.bounds);
    }
    else if ( value > self.maxValue )
    {
        return CGRectGetMaxX(self.trackView.bounds);
    }
    
    return CGRectGetWidth(self.trackView.bounds) * (value - self.minValue) /
    (self.maxValue - self.minValue) + (self.handleImage.size.width / 2);
}



#pragma mark - Touch handlers

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    if(CGRectContainsPoint(self.lowerHandle.frame, touchPoint))
    {
        self.lowerHandle.highlighted = YES;
    }
    else if(CGRectContainsPoint(self.upperHandle.frame, touchPoint))
    {
        self.upperHandle.highlighted = YES;
    }
    _lastTouchPoint = touchPoint;
    
    return self.lowerHandle.highlighted || self.upperHandle.highlighted;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat delta =
    (self.maxValue - self.minValue) * (touchPoint.x - _lastTouchPoint.x) / CGRectGetWidth(self.trackView.bounds);
    
    if ( self.lowerHandle.highlighted )
    {
        self.lowerValue = MIN(MAX(self.lowerValue+delta, self.minValue), self.upperValue);
        [self setLowerValue:self.lowerValue];
        [self setUpperValue:self.upperValue];
    }
    
    if ( self.upperHandle.highlighted )
    {
        self.upperValue = MIN(MAX(self.upperValue+delta, self.lowerValue), self.maxValue);
        [self setLowerValue:self.lowerValue];
        [self setUpperValue:self.upperValue];
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.lowerHandle.highlighted = NO;
    self.upperHandle.highlighted = NO;
    
    if ( self.stepSize > 0 )
    {
        __stepSize = self.stepSize;
    }
    [self setLowerValue:self.lowerValue];
    [self setUpperValue:self.upperValue];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}



#pragma mark - Property accessor methods (public)

- (void) setMinValue:(CGFloat)minValue
{
    _minValue = minValue;
    self.lowerValue = MAX(_minValue, _lowerValue);
}

- (void) setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    self.upperValue = MIN(_maxValue, _upperValue);
}

- (void) setLowerValue:(CGFloat)lowerValue
{
    _lowerValue = MAX(roundf(lowerValue / __stepSize) * __stepSize, self.minValue);
    if ( !CGSizeEqualToSize(self.frame.size, CGSizeZero) )
    {
        self.lowerHandle.center = CGPointMake([self positionForValue:_lowerValue], CGRectGetHeight(self.bounds)/2.0);
        CGRect frame = self.trackHighlightView.frame;
        frame.origin.x = [self convertPoint:self.lowerHandle.center toView:self.trackView].x;
        self.trackHighlightView.frame = frame;
    }
}

- (void) setUpperValue:(CGFloat)upperValue
{
    _upperValue = MIN(roundf(upperValue / __stepSize) * __stepSize, self.maxValue);
    if ( !CGSizeEqualToSize(self.frame.size, CGSizeZero) )
    {
        self.upperHandle.center = CGPointMake([self positionForValue:_upperValue], CGRectGetHeight(self.bounds)/2.0);
        CGRect frame = self.trackHighlightView.frame;
        frame.size.width = self.upperHandle.center.x - self.lowerHandle.center.x;
        self.trackHighlightView.frame = frame;
    }
}

- (void) setHandleImage:(UIImage *)handleImage
{
    _handleImage = handleImage;
    [self updateHandleImageView];
}

- (void) setHandleSize:(CGSize)handleSize
{
    _handleSize = handleSize;
    _handleImage = [_handleImage scaleToSize:_handleSize];
    [self updateHandleImageView];
}

- (void) setHandleImage:(UIImage *)handleImage withSize:(CGSize)size
{
    _handleSize = size;
    _handleImage = [handleImage scaleToSize:_handleSize];
    [self updateHandleImageView];
}

- (void) setTrackColor:(UIColor *)trackColor
{
    _trackColor = trackColor;
    self.trackView.backgroundColor = _trackColor;
}

- (void) setTrackHighlightColor:(UIColor *)trackHighlightColor
{
    _trackHighlightColor = trackHighlightColor;
    self.trackHighlightView.backgroundColor = _trackHighlightColor;
}

- (void) setTrackImage:(UIImage *)trackImage
{
    _trackImage = trackImage;
    self.trackImageView.image = _trackImage;
}

- (void) setTrackHighlightImage:(UIImage *)trackHighlightImage
{
    _trackHighlightImage = trackHighlightImage;
    self.trackHighlightImageView.image = _trackHighlightImage;
}

- (void) setTrackHeight:(CGFloat)trackHeight
{
    _trackHeight = trackHeight;
    
    CGRect bounds = self.trackView.bounds;
    bounds.size.height = _trackHeight;
    self.trackView.bounds = bounds;
}

- (void) setTrackCornerRadius:(CGFloat)trackCornerRadius
{
    _trackCornerRadius = trackCornerRadius;
    self.trackView.layer.cornerRadius = _trackCornerRadius;
}

- (CGPoint) lowerHandleCenter
{
    return self.lowerHandle.center;
}

- (CGPoint) upperHandleCenter
{
    return self.upperHandle.center;
}


#pragma mark - Property accessor methods (private)

- (UIImageView*) lowerHandle
{
    if (_lowerHandle == nil)
    {
        _lowerHandle = [[UIImageView alloc] initWithImage:_handleImage
                                         highlightedImage:_handleHighlightedImage];
        _lowerHandle.contentMode = UIViewContentModeScaleToFill;
    }
    return _lowerHandle;
}

- (UIImageView*) upperHandle
{
    if (_upperHandle == nil)
    {
        _upperHandle = [[UIImageView alloc] initWithImage:_handleImage
                                         highlightedImage:_handleHighlightedImage];
        _lowerHandle.contentMode = UIViewContentModeScaleToFill;
    }
    return _upperHandle;
}

- (NSArray*) handles
{
    if (_handles == nil)
    {
        _handles = @[self.lowerHandle, self.upperHandle];
    }
    return _handles;
}

- (UIView*) trackView
{
    if (_trackView == nil)
    {
        _trackView = [[UIView alloc] initWithFrame:CGRectZero];
        _trackView.clipsToBounds = YES;
        _trackView.userInteractionEnabled = NO;
    }
    return _trackView;
}

- (UIView*) trackHighlightView
{
    if (_trackHighlightView == nil)
    {
        _trackHighlightView = [[UIView alloc] initWithFrame:CGRectZero];
        _trackHighlightView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _trackHighlightView.clipsToBounds = YES;
        _trackHighlightView.userInteractionEnabled = NO;
    }
    return _trackHighlightView;
}

- (UIImageView*) trackImageView
{
    if (_trackImageView == nil)
    {
        _trackImageView = [[UIImageView alloc] initWithImage:_trackImage];
        _trackImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _trackImageView.contentMode = UIViewContentModeScaleAspectFill;
        _trackImageView.userInteractionEnabled = NO;
    }
    return _trackImageView;
}

- (UIImageView*) trackHighlightImageView
{
    if (_trackHighlightImageView == nil)
    {
        _trackHighlightImageView = [[UIImageView alloc] initWithImage:_trackHighlightImage];
        _trackHighlightImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _trackHighlightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _trackHighlightImageView.userInteractionEnabled = NO;
    }
    return _trackHighlightImageView;
}

@end
