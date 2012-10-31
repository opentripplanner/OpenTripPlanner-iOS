//
//  OTPSelectedSegment.m
//  OpenTripPlanner
//
//  Created by Aaron Sutula on 10/31/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPSelectedSegment.h"
#import "OTPGraphicsCommon.h"

@implementation OTPSelectedSegment

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

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
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:1 alpha:1].CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 20, 0);
    CGContextAddLineToPoint(context, 0, 20);
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    CGContextSetShadow(context, CGSizeMake(0, 0), 3);
    CGContextMoveToPoint(context, 0, -1);
    CGContextAddLineToPoint(context, 20, -1);
    CGContextAddLineToPoint(context, 0, 20);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.1 green:0.1 blue:1 alpha:1].CGColor);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
