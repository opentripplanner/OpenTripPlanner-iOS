//
//  OTPDirectionsInputViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 9/10/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

#import "RouteMe.h"

#import "OTPTransitTimeViewController.h"
#import "OTPGeocodeDisambigationViewController.h"
#import "OTPGeocodedTextField.h"
#import "MBProgressHUD.h"

typedef enum {
    WALK_TRANSIT,
    BIKE_TRANSIT,
    WALK,
    BIKE
} kTransitModeType;

@protocol OTPDirectionsInputViewControllerDelegate;

@interface OTPDirectionsInputViewController : UIViewController <RKObjectLoaderDelegate, UITextFieldDelegate, RMMapViewDelegate, OTPTransitTimeViewControllerDelegate, OTPGeocodeDisambigationViewControllerDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) IBOutlet UISegmentedControl *modeControl;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *goButton;
@property (nonatomic, strong) IBOutlet UIView *textFieldContainer;
@property (nonatomic, strong) IBOutlet OTPGeocodedTextField *fromTextField;
@property (nonatomic, strong) IBOutlet OTPGeocodedTextField *toTextField;
@property (nonatomic, strong) UISegmentedControl *switchFromAndToButton;
@property (nonatomic, strong) IBOutlet RMMapView *mapView;
@property (nonatomic, strong) IBOutlet UIButton *userLocationButton;
@property (nonatomic, strong) NSNumber *arriveOrDepartByIndex;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) RMUserLocation *userLocation;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *timeButton;
@property (nonatomic) BOOL needsPanToUserLocation;
@property (nonatomic) BOOL needsShowFromAndToLocations;

- (void) planTripFrom:(CLLocationCoordinate2D)startPoint to:(CLLocationCoordinate2D)endPoint;

- (IBAction)go:(id)sender;
- (IBAction)updatedTextField:(id)sender;
- (IBAction)modeChanged:(id)sender;
- (IBAction)panToUserLocation:(id)sender;
- (IBAction)touchAboutButton:(id)sender;
- (void)enableUserLocation;
- (void)showFromAndToLocations;

- (void)updateTextField:(OTPGeocodedTextField*)textFiled withText:(NSString*)text andLocation:(CLLocation*)location;

@end