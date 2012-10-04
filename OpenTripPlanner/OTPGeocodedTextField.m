//
//  OTPGeocodedTextField.m
//  OpenTripPlanner
//
//  Created by asutula on 9/11/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPGeocodedTextField.h"

@implementation OTPGeocodedTextField

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

- (void)setText:(NSString *)text andLocation:(CLLocation *)location
{
    if ([text isEqualToString:@""] || text == nil) {
        // Reset
        self.text = nil;
        _location = nil;
        self.rightView = nil;
    } else if (![text isEqualToString:@""] && text != nil && location != nil) {
        // Valid text and location
        self.text = text;
        _location = location;
        self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
    } else if (![text isEqualToString:@""] && text != nil && location == nil) {
        // Invalid location for text
        self.text = text;
        _location = nil;
        self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x.png"]];
    }
}

- (void)switchValuesWithOther
{
    NSString *tmpText = self.text;
    CLLocation *tmpLocation = self.location;
    BOOL tmpIsDirty = self.isDirty;
    
    [self setText:self.otherTextField.text andLocation:self.otherTextField.location];
    self.isDirty = self.otherTextField.isDirty;
    
    [self.otherTextField setText:tmpText andLocation:tmpLocation];
    self.otherTextField.isDirty = tmpIsDirty;
}

- (BOOL)isGeocoded
{
    if (self.location != nil && self.text != nil && ![self.text isEqualToString:@""]) {
        return YES;
    }
    return NO;
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
