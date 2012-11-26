//
//  OTPItineraryCell.m
//  OpenTripPlanner
//
//  Created by aogle on 10/11/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

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
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef startColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0].CGColor;
    CGColorRef endColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor;
    
    CGRect paperRect = self.bounds;
    
    drawLinearGradient(context, paperRect, startColor, endColor);
}

@end
