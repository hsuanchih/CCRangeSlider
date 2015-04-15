//
//  ViewController.m
//  CCRangeSliderDemo
//
//  Created by Chuang HsuanChih on 4/9/15.
//  Copyright (c) 2015 Hsuan-Chih Chuang. All rights reserved.
//

#import "ViewController.h"
#import "CCRangeSlider.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIView *sliderView;
@property (nonatomic, strong) CCRangeSlider *rangeSlider;
@property (nonatomic, strong) NSMutableArray *sliderLabels;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     *  Config rangeSlider
     */
    self.rangeSlider.minValue = 0.0;
    self.rangeSlider.maxValue = 10.0;
    self.rangeSlider.stepSize = 0.1;
    self.rangeSlider.lowerValue = 3.2;
    self.rangeSlider.upperValue = 8.7;
    
    [self.rangeSlider addTarget:self
                         action:@selector(updateSliderLabel:)
               forControlEvents:UIControlEventValueChanged];
    
    /*
     *  Add rangeSlider to view
     */
    [self.sliderView addSubview:self.rangeSlider];
    
    /*
     *  Add labels to show current lower & upper values
     */
    for ( UILabel *label in self.sliderLabels )
    {
        [self.sliderView addSubview:label];
        CGRect bounds = label.bounds;
        bounds.size.width = 40.0;
        bounds.size.height = 20.0;
        label.bounds = bounds;
    }
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    /*
     *  Update label positions
     */
    [self updateSliderLabel:self.rangeSlider];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /*
     *  Update rangeSlider's frame
     */
    self.rangeSlider.frame = self.sliderView.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private utility methods

- (void) updateSliderLabel:(CCRangeSlider*)rangeSlider
{
    for ( NSUInteger i = 0; i < self.sliderLabels.count; i++ )
    {
        UILabel *label = [self.sliderLabels objectAtIndex:i];
        CGPoint center;
        center.y = rangeSlider.center.y - rangeSlider.handleSize.height/2.0 - CGRectGetHeight(label.bounds)/2.0 - 2.0;
        
        if ( i == 0 )
        {
            center.x = rangeSlider.lowerHandleCenter.x + rangeSlider.frame.origin.x;
            label.text = [self sliderLabelTextForValue:rangeSlider.lowerValue];
        }
        else
        {
            center.x = rangeSlider.upperHandleCenter.x + rangeSlider.frame.origin.x;
            label.text = [self sliderLabelTextForValue:rangeSlider.upperValue];
        }
        label.center = center;
    }
}

- (NSString*) sliderLabelTextForValue:(CGFloat)value
{
    return [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:roundf(value / self.rangeSlider.stepSize) * self.rangeSlider.stepSize]];
}


#pragma mark - Property accessor methods

- (CCRangeSlider*) rangeSlider
{
    if (!_rangeSlider)
    {
        _rangeSlider = [[CCRangeSlider alloc] init];
    }
    return _rangeSlider;
}

- (NSMutableArray*) sliderLabels
{
    if (_sliderLabels == nil)
    {
        _sliderLabels = [NSMutableArray arrayWithCapacity:2];
        for ( NSUInteger i = 0; i < 2; i++ )
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.font = [UIFont boldSystemFontOfSize:12.0f];
            label.textColor = [UIColor darkGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            [_sliderLabels addObject:label];
        }
    }
    return _sliderLabels;
}

@end
