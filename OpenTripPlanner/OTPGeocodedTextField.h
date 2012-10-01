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

@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) OTPGeocodedTextField *otherTextField;
@property BOOL isDirty;

@end
