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
{
    CLPlacemark *_placemark;

    OTPGeocodedTextField *_otherTextField;
    BOOL _isDirty;
}

@property (nonatomic, retain) CLPlacemark *placemark;
@property (nonatomic, retain) OTPGeocodedTextField *otherTextField;
@property BOOL isDirty;

@end
