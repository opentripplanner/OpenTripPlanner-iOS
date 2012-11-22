//
//  OTPGeocodeDisambigationViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 11/16/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol OTPGeocodeDisambigationViewControllerDelegate;

@interface OTPGeocodeDisambigationViewController : UITableViewController

@property(nonatomic, strong) NSArray* placemarks;
@property(nonatomic, strong) NSObject<OTPGeocodeDisambigationViewControllerDelegate> *delegate;

- (IBAction)cancel:(id)sender;

@end

@protocol OTPGeocodeDisambigationViewControllerDelegate <NSObject>

- (void)userSelectedPlacemark:(CLPlacemark *)placemark;
- (void)userCanceledDisambiguation;

@end
