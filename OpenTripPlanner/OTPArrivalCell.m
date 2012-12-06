//
//  OTPArrivalCell.m
//  OpenTripPlanner
//
//  Created by eshon on 11/2/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPArrivalCell.h"

@implementation OTPArrivalCell

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.destinationText resizeHeightToFitText];
    self.destinationText.center = CGPointMake(self.destinationText.center.x, self.bounds.size.height/2);
    self.icon.center = CGPointMake(self.icon.center.x, self.bounds.size.height/2);
}

@end
