//
//  OTPGeocodedTextField.m
//  OpenTripPlanner
//
//  Created by asutula on 9/11/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPGeocodedTextField.h"

@implementation OTPGeocodedTextField

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    if (!self.isGeocoded) {
        [self setText:text andLocation:nil];
    }
}

- (void)setText:(NSString *)text andLocation:(CLLocation *)location
{
    if (text.length == 0) {
        // Reset
        [super setText:nil];
        [self setLocation:nil];
    } else if (text.length > 0 && location != nil) {
        // Valid text and location
        [super setText:text];
        [self setLocation:location];
    } else if (text.length > 0 && location == nil) {
        // Invalid location for text
        [super setText:text];
        [self setLocation:nil];
    }
}

- (void)setLocation:(CLLocation *)location
{
    if (self.text.length > 0 && location != nil) {
        self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick-00b0d8.png"]];
    } else if (self.text.length > 0 && location == nil) {
        self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross.png"]];
    } else if (location == nil) {
        self.rightView = nil;
    }
    _location = location;
}

- (void)switchValuesWithOther
{
    NSString *tmpText = self.text;
    CLLocation *tmpLocation = self.location;
    
    [self setText:self.otherTextField.text andLocation:self.otherTextField.location];
    
    [self.otherTextField setText:tmpText andLocation:tmpLocation];
}

- (BOOL)isGeocoded
{
    return self.location != nil && self.text.length > 0;
    return NO;
}

- (BOOL)isCurrentLocation
{
    if ([self.text isEqualToString:@"Current Location"] && self.location != nil) {
        return YES;
    }
    return NO;
}

- (BOOL)isDroppedPin
{
    if ([self.text hasPrefix:@"Dropped Pin"] && self.location != nil) {
        return YES;
    }
    return NO;
}

@end
