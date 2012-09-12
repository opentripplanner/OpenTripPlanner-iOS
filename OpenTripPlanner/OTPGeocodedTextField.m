//
//  OTPGeocodedTextField.m
//  OpenTripPlanner
//
//  Created by asutula on 9/11/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPGeocodedTextField.h"

@implementation OTPGeocodedTextField

@synthesize placemark = _placemark;
@synthesize otherTextField = _otherTextField;
@synthesize isDirty = _isDirty;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isDirty = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
