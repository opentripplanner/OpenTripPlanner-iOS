//
//  OTPViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 8/30/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

#import "OTPDirectionsInputViewController.h"
#import "RouteMe.h"
#import "Itinerary.h"
#import "Leg.h"

@interface OTPViewController : UIViewController <RKObjectLoaderDelegate, RMMapViewDelegate, UISearchBarDelegate, OTPDirectionsInputViewControllerDelegate>
{
    RMMapView* _mapView;
    UISearchBar *_searchBar;
    UIToolbar *_toolbar;
    UIView *_infoView;
    UILabel *_infoLabel;
    Itinerary* _currentItinerary;
    Leg* _currentLeg;
    RMUserLocation* _userLocation;
}

- (void) planTripFrom:(CLLocationCoordinate2D)startPoint to:(CLLocationCoordinate2D)endPoint;
- (void) planTripFromCurrentLocationTo:(CLLocationCoordinate2D)endPoint;
- (void) planTripToCurrentLocationFrom:(CLLocationCoordinate2D)startPoint;
- (IBAction) showSearchBar:(id)sender;

@property (nonatomic, retain) IBOutlet RMMapView* mapView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIView *infoView;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel;
@property (nonatomic, retain) Itinerary* currentItinerary;
@property (nonatomic, retain) Leg* currentLeg;
@property (nonatomic, retain) RMUserLocation* userLocation;

@end
