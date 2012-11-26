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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef startColor = self.startColor.CGColor;
    CGColorRef endColor = self.endColor.CGColor;
    
    drawLinearGradient(context, rect, startColor, endColor);
}

@end
