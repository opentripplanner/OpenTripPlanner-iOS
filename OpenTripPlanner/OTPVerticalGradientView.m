//
//  OTPVerticalGradientView.m
//  OpenTripPlanner
//
//  Created by asutula on 9/25/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OTPVerticalGradientView.h"
#import "OTPGraphicsCommon.h"

@implementation OTPVerticalGradientView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef highlightColor = self.highlightColor.CGColor;
    CGRect paperRect = self.bounds;
    CGPoint startPoint = CGPointMake(paperRect.origin.x, paperRect.origin.y + paperRect.size.height - 1);
    CGPoint endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1, paperRect.origin.y + paperRect.size.height - 1);
    draw1PxStroke(context, startPoint, endPoint, highlightColor);
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeMake(0, 3);    
}

@end
