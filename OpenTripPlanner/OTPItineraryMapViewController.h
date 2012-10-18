//
//  OTPItineraryMapViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 10/1/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RouteMe.h"
#import "Itinerary.h"

@interface OTPItineraryMapViewController : UIViewController

@property (strong, nonatomic) IBOutlet RMMapView *mapView;

@end
