//
//  OTPItineraryViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 9/14/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "RouteMe.h"
#import "Itinerary.h"
#import "OTPItineraryTableViewController.h"
#import "OTPItineraryMapViewController.h"
#import "OTPGeocodedTextField.h"
#import "ZUUIRevealController.h"
#import "OTPItineraryOverlayViewController.h"

@interface OTPItineraryViewController : ZUUIRevealController <ZUUIRevealControllerDelegate, UITableViewDataSource, UITableViewDelegate, RMMapViewDelegate, MFMailComposeViewControllerDelegate, OTPItineraryOverlayViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) Itinerary *itinerary;
@property (nonatomic, strong) OTPItineraryTableViewController *itineraryTableViewController;
@property (nonatomic, strong) OTPItineraryMapViewController *itineraryMapViewController;
@property (nonatomic, strong) OTPGeocodedTextField *fromTextField;
@property (nonatomic, strong) OTPGeocodedTextField *toTextField;
@property (nonatomic) BOOL mapShowedUserLocation;


- (void)presentFeedbackView;
- (IBAction)done:(UIBarButtonItem *)sender;

@end
