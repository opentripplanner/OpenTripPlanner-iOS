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

@interface OTPItineraryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RMMapViewDelegate>

@property (nonatomic, strong) Itinerary *itinerary;
@property (nonatomic, strong) PaperFoldView *paperFoldView;
@property (nonatomic, strong) RMMapView *mapView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
