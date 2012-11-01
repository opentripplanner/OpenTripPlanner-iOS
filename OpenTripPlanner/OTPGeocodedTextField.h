//
//  OTPGeocodedTextField.h
//  OpenTripPlanner
//
//  Created by asutula on 9/11/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface OTPGeocodedTextField : UITextField

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) OTPGeocodedTextField *otherTextField;

- (void)setText:(NSString *)text andLocation:(CLLocation *)location;
- (void)switchValuesWithOther;
- (BOOL)isGeocoded;
- (BOOL)isCurrentLocation;
- (BOOL)isDroppedPin;

@end
