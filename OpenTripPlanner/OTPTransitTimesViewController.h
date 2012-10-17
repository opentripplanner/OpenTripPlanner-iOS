//
//  OTPTransitTimesViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 9/6/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTPGeocodedTextField.h"

@interface OTPTransitTimesViewController : UITableViewController

@property (nonatomic, strong) NSArray *itineraries;
@property (nonatomic, strong) OTPGeocodedTextField *fromTextField;
@property (nonatomic, strong) OTPGeocodedTextField *toTextField;

- (IBAction)dismiss:(id)sender;

@end
