//
//  OTPItineraryCell.m
//  OpenTripPlanner
//
//  Created by aogle on 10/11/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OTPItineraryCell.h"
#import "OTPGraphicsCommon.h"

@implementation OTPItineraryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    self.timesView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.timesView.layer.shadowOpacity = 0.2;
    self.timesView.layer.shadowRadius = 3;
    self.timesView.layer.shadowOffset = CGSizeMake(0, 0);
    self.timesView.layer.cornerRadius = 5;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef startColor = CGColorRetain([UIColor colorWithRed:219.0/255.0 green:240.0/255.0 blue:246.0/255.0 alpha:1.0].CGColor);
    CGColorRef endColor = CGColorRetain([UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor);
    
    CGRect paperRect = self.bounds;
    
    drawLinearGradient(context, paperRect, startColor, endColor);
    
    if (self.tag != 0) {
        draw1PxStroke(context, self.bounds.origin, CGPointMake(self.bounds.size.width, 0), [UIColor whiteColor].CGColor);
    }
    draw1PxStroke(context, CGPointMake(0, self.bounds.size.height-1), CGPointMake(self.bounds.size.width, self.bounds.size.height-1), [UIColor colorWithWhite:0.824 alpha:1.000].CGColor);
}

@end
