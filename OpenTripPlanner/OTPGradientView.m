//
//  OTPTimePickerView.m
//  OpenTripPlanner
//
//  Created by asutula on 10/22/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPGradientView.h"
#import "OTPGraphicsCommon.h"

@implementation OTPGradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef startColor = CGColorRetain(self.startColor.CGColor);
    CGColorRef endColor = CGColorRetain(self.endColor.CGColor);
    
    drawLinearGradient(context, rect, startColor, endColor);
}

@end
