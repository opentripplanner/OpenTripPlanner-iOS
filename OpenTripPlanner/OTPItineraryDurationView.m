//
//  OTPItineraryDurationView.m
//  OpenTripPlanner
//
//  Created by asutula on 10/19/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPItineraryDurationView.h"
#import "OTPGraphicsCommon.h"

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
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGColorRef startColor = CGColorRetain([UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor);
//    CGColorRef endColor = CGColorRetain([UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor);
////    CGColorRef highlightColor = CGColorRetain([UIColor colorWithRed:50.0/255.0 green:71.0/255.0 blue:110.0/255.0 alpha:1.0].CGColor);
//    
//    CGRect paperRect = self.bounds;
//    
//    drawLinearGradient(context, paperRect, startColor, endColor);
//    
////    CGPoint startPoint = CGPointMake(paperRect.origin.x, paperRect.origin.y + paperRect.size.height - 1);
////    CGPoint endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1, paperRect.origin.y + paperRect.size.height - 1);
////    draw1PxStroke(context, startPoint, endPoint, highlightColor);
//    
////    self.layer.shadowColor = CGColorRetain([UIColor blackColor].CGColor);
////    self.layer.shadowOpacity = 0.3;
////    self.layer.shadowRadius = 3;
////    self.layer.shadowOffset = CGSizeMake(0, 3);
//}

@end
