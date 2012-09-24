//
//  OTPViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 8/30/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OTPDirectionsInputViewController.h"
#import "OTPSearchBarWithActivity.h"
#import "RouteMe.h"

@interface OTPViewController : UIViewController <RMMapViewDelegate, UISearchBarDelegate>
{
    RMMapView* _mapView;
    OTPSearchBarWithActivity *_searchBar;
    RMUserLocation* _userLocation;
}

@property (nonatomic, retain) IBOutlet RMMapView* mapView;
@property (nonatomic, retain) IBOutlet OTPSearchBarWithActivity *searchBar;
@property (nonatomic, retain) RMUserLocation* userLocation;

@end
