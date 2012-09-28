//
//  OTPVerticalGradientView.m
//  OpenTripPlanner
//
//  Created by asutula on 9/25/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPVerticalGradientView.h"
#import "OTPGraphicsCommon.h"

@implementation OTPVerticalGradientView

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
    
    CGColorRef startColor = CGColorRetain([UIColor colorWithRed:161.0/255.0 green:177.0/255.0 blue:203.0/255.0 alpha:1.0].CGColor);
    CGColorRef endColor = CGColorRetain([UIColor colorWithRed:72.0/255.0 green:94.0/255.0 blue:136.0/255.0 alpha:1.0].CGColor);
    CGColorRef redColor = CGColorRetain([UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0].CGColor);
    CGColorRef highlightColor1 = CGColorRetain([UIColor colorWithRed:60.0/255.0 green:77.0/255.0 blue:107.0/255.0 alpha:1.0].CGColor);
    CGColorRef highlightColor2 = CGColorRetain([UIColor colorWithRed:101.0/255.0 green:115.0/255.0 blue:148.0/255.0 alpha:1.0].CGColor);
    CGColorRef highlightColor3 = CGColorRetain([UIColor colorWithRed:119.0/255.0 green:133.0/255.0 blue:168.0/255.0 alpha:1.0].CGColor);
    CGColorRef shadowColor = CGColorRetain([UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5].CGColor);
    
    CGRect paperRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height - 5);
    
    drawLinearGradient(context, paperRect, startColor, endColor);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor);
    CGPoint startPoint = CGPointMake(paperRect.origin.x, paperRect.origin.y + paperRect.size.height - 1);
    CGPoint endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1, paperRect.origin.y + paperRect.size.height - 1);
    draw1PxStroke(context, startPoint, endPoint, highlightColor2);
    CGContextRestoreGState(context);
    
    startPoint = CGPointMake(paperRect.origin.x, paperRect.origin.y + paperRect.size.height - 2);
    endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1, paperRect.origin.y + paperRect.size.height - 2);
    draw1PxStroke(context, startPoint, endPoint, highlightColor3);
    
    startPoint = CGPointMake(paperRect.origin.x, paperRect.origin.y + paperRect.size.height - 3);
    endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1, paperRect.origin.y + paperRect.size.height - 3);
    //draw1PxStroke(context, startPoint, endPoint, highlightColor3);
    
    
}

@end
