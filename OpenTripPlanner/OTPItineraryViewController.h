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
{
    Itinerary *_itinerary;
    PaperFoldView *_paperFoldView;
    RMMapView *_mapView;
    UITableView *_tableView;
}

@property (nonatomic, retain) Itinerary *itinerary;
@property (nonatomic, retain) PaperFoldView *paperFoldView;
@property (nonatomic, retain) RMMapView *mapView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
