//
//  OTPItineraryViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 9/14/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RouteMe.h"
#import "PaperFoldView.h"
#import "Itinerary.h"
#import "PPRevealSideViewController.h"
#import "OTPItineraryTableViewController.h"
#import "OTPItineraryMapViewController.h"

@interface OTPItineraryViewController : UIViewController

@property (nonatomic, strong) Itinerary *itinerary;
@property (nonatomic, strong) PPRevealSideViewController *revealSideViewController;
@property (nonatomic, strong) OTPItineraryTableViewController *itineraryTableViewController;

@end
