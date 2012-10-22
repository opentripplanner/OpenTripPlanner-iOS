//
//  OTPItineraryDurationView.m
//  OpenTripPlanner
//
//  Created by asutula on 10/19/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OTPItineraryDurationView.h"

@implementation OTPItineraryDurationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    rect = self.layer.bounds;
    
    self.layer.shadowColor = CGColorRetain([UIColor blackColor].CGColor);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    CALayer *mask = [[CALayer alloc] init];
    mask.backgroundColor = [UIColor blackColor].CGColor;
    mask.frame = CGRectMake(-6, 0.0, self.bounds.size.width + 6, self.bounds.size.height);
    self.layer.mask = mask;
}

@end
