//
//  OTPItineraryTableViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 10/1/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Itinerary.h"
#import "OTPItineraryMapViewController.h"
#import "RouteMe.h"
#import "PPRevealSideViewController.h"

@interface OTPItineraryTableViewController : UITableViewController <RMMapViewDelegate, PPRevealSideViewControllerDelegate>

@property(strong, nonatomic) Itinerary *itinerary;
@property (nonatomic, strong) OTPItineraryMapViewController *itineraryMapViewController;

- (void)displayItinerary;
- (void)displayItineraryOverview;
- (void)displayLeg:(Leg*)leg;
- (IBAction)swipeRightTableView:(id)sender;
- (IBAction)swipeLeftTableView:(id)sender;

@end
