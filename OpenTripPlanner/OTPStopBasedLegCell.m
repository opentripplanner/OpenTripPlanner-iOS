//
//  OTPTransitLegCell.m
//  OpenTripPlanner
//
//  Created by asutula on 10/11/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPStopBasedLegCell.h"

@implementation OTPStopBasedLegCell

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
    [self.instructionLabel sizeToFit];
    [self.toLabel sizeToFit];
    CGRect newFrame = self.toLabel.frame;
    newFrame.origin = CGPointMake(newFrame.origin.x, self.instructionLabel.frame.origin.y + self.instructionLabel.frame.size.height + 10);
    self.toLabel.frame = newFrame;
}

@end
