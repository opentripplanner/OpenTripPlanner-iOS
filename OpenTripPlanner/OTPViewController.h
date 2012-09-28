//
//  OTPViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 8/30/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RouteMe.h"

#import "OTPDirectionsInputViewController.h"
#import "OTPSearchBarWithActivity.h"

@interface OTPViewController : UIViewController <RMMapViewDelegate, UISearchBarDelegate>
{
    RMMapView* _mapView;
    OTPSearchBarWithActivity *_searchBar;
    RMUserLocation* _userLocation;
}

@property (nonatomic, strong) IBOutlet RMMapView* mapView;
@property (nonatomic, strong) IBOutlet OTPSearchBarWithActivity *searchBar;
@property (nonatomic, strong) RMUserLocation* userLocation;

@end
