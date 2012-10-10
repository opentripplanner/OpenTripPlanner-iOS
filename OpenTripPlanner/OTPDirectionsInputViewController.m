//
//  OTPDirectionsInputViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 9/10/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "Plan.h"
#import "OTPDirectionsInputViewController.h"
#import "OTPTransitTimesViewController.h"
#import "OTPCallout.h"
#import "SMCalloutView.h"

NSString * const kTransitModeTypeArray[] = {
    @"WALK,TRANSIT",
    @"BIKE,TRANSIT",
    @"BIKE",
    @"WALK"
};

NSString * const kArriveByArray[] = {
    @"false",
    @"true"
};

@interface OTPDirectionsInputViewController ()
{
    RMAnnotation *fromAnnotation;
    RMAnnotation *toAnnotation;
}

- (void)switchFromAndTo:(id)sender;
- (void)geocodeStringInTextField:(OTPGeocodedTextField *)textField;
- (void)didShowKeyboard:(NSNotification *)notification;
- (void)willHideKeyboard:(NSNotification *)notification;
- (void)updateViewsForCurrentUserLocation;

@end

@implementation OTPDirectionsInputViewController

CLGeocoder *geocoder;
CLPlacemark *fromPlacemark;
CLPlacemark *toPlacemark;
CGFloat topOfKeyboard;

Plan *currentPlan;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.goButton.enabled = NO;
    
    [self modeChanged:self.modeControl];
    
    self.arriveOrDepartByIndex = [NSNumber numberWithInt:0];
    self.modeControl.selectedSegmentIndex = 0;
    self.date = [[NSDate alloc] init];
    
    self.navBar.topItem.titleView = self.modeControl;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    geocoder = [[CLGeocoder alloc] init];
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    NSString *mapUrl = nil;
    if (scale == 1) {
        mapUrl = @"http://a.tiles.mapbox.com/v3/openplans.map-ky03eiac.jsonp";
    } else {
        mapUrl = @"http://a.tiles.mapbox.com/v3/openplans.map-pq6tfzg7.jsonp";
    }
    RMMapBoxSource* source = [[RMMapBoxSource alloc] initWithReferenceURL:[NSURL URLWithString:mapUrl]];
    self.mapView.adjustTilesForRetinaDisplay = NO;
    self.mapView.tileSource = source;
    self.mapView.delegate = self;
	
    self.switchFromAndToButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"S", nil]];
    self.switchFromAndToButton.segmentedControlStyle = UISegmentedControlStyleBar;
    CGRect controlFrame = self.switchFromAndToButton.frame;
    controlFrame.size.height = 40.f;
    controlFrame.size.width = 40.f;
    
    self.switchFromAndToButton.frame = controlFrame;
    self.switchFromAndToButton.momentary = YES;
    self.switchFromAndToButton.center = CGPointMake(26, 40);
    [self.switchFromAndToButton addTarget:self action:@selector(switchFromAndTo:) forControlEvents:UIControlEventAllEvents];
    
    [self.textFieldContainer addSubview:self.switchFromAndToButton];
    
    UILabel *fromLabel = [[UILabel alloc] init];
    fromLabel.textColor = [UIColor grayColor];
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.font = [UIFont systemFontOfSize:14];
    fromLabel.text = @"From: ";
    [fromLabel sizeToFit];
    
    self.fromTextField.leftViewMode = UITextFieldViewModeAlways;
    self.fromTextField.leftView = fromLabel;
    
    UILabel *toLabel = [[UILabel alloc] init];
    toLabel.textColor = [UIColor grayColor];
    toLabel.backgroundColor = [UIColor clearColor];
    toLabel.font = [UIFont systemFontOfSize:14];
    toLabel.text = @"To: ";
    [toLabel sizeToFit];
    
    self.toTextField.leftViewMode = UITextFieldViewModeAlways;
    self.toTextField.leftView = toLabel;
    
    self.fromTextField.otherTextField = self.toTextField;
    self.toTextField.otherTextField = self.fromTextField;
    
    self.fromTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
    self.toTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self.fromTextField becomeFirstResponder];
}

- (void)go:(id)sender
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.labelText = @"Routing";
	HUD.dimBackground = YES;
    HUD.removeFromSuperViewOnHide = YES;
	[HUD show:YES];
    
    [self planTripFrom:self.fromTextField.location.coordinate to:self.toTextField.location.coordinate];
    [self.fromTextField resignFirstResponder];
    [self.toTextField resignFirstResponder];
}

- (void)didShowKeyboard:(NSNotification *)notification
{
    NSLog(@"Did show keyboard");
    if (!topOfKeyboard) {
        CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        topOfKeyboard = keyboardRect.origin.y - keyboardRect.size.height;
    }
}

- (void)willHideKeyboard:(NSNotification *)notification
{
    NSLog(@"Will hide keyboard");
//    CGFloat newMapHeight = self.mapView.superview.bounds.size.height - self.mapView.frame.origin.y;
//    CGRect newMapFrame = CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, newMapHeight);
//    self.mapView.frame = newMapFrame;
}


#pragma mark OTP methods

- (void)planTripFrom:(CLLocationCoordinate2D)startPoint to:(CLLocationCoordinate2D)endPoint
{
    // TODO: Look at how time zone plays into all this.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:self.date];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeString = [dateFormatter stringFromDate:self.date];
    
    NSString *fromString = [NSString stringWithFormat:@"%f,%f", startPoint.latitude, startPoint.longitude];
    NSString *toString = [NSString stringWithFormat:@"%f,%f", endPoint.latitude, endPoint.longitude];
    
    NSString *mode = kTransitModeTypeArray[self.modeControl.selectedSegmentIndex];
    NSString *arriveBy = kArriveByArray[self.arriveOrDepartByIndex.intValue];
    
    
    NSDictionary* params = [NSDictionary dictionaryWithKeysAndObjects:
                            @"optimize", @"QUICK",
                            @"time", timeString,
                            @"arriveBy", arriveBy,
                            @"routerId", @"req-241",
                            @"maxWalkDistance", @"840",
                            @"fromPlace", fromString,
                            @"toPlace", toString,
                            @"date", dateString,
                            @"mode", mode,
                            nil];
    
    NSString* resourcePath = [@"/plan" stringByAppendingQueryParameters: params];
    
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

//- (void)planTripFromCurrentLocationTo:(CLLocationCoordinate2D)endPoint
//{
//    if (self.userLocation == nil) {
//        needsRouting = YES;
//        currentLocationRoutingSelector = @selector(planTripFromCurrentLocationTo:);
//        currentLocationToOrFromPoint = endPoint;
//        [self showUserLocation];
//    } else {
//        [self planTripFrom:self.userLocation.coordinate to:endPoint];
//    }
//}
//
//- (void)planTripToCurrentLocationFrom:(CLLocationCoordinate2D)startPoint
//{
//    if (self.userLocation == nil) {
//        needsRouting = YES;
//        currentLocationRoutingSelector = @selector(planTripToCurrentLocationFrom:);
//        currentLocationToOrFromPoint = startPoint;
//        [self showUserLocation];
//    } else {
//        [self planTripFrom:startPoint to:self.userLocation.coordinate];
//    }
//}

- (void)geocodeStringInTextField:(OTPGeocodedTextField *)textField
{
    // TODO: If we want to pass a region to the geocoder, we should have a coordinate property on this thing
    // that the parent view controller can optionally set using the user's location or map center.
//    CLLocationCoordinate2D regionCoordinate;
//    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:regionCoordinate radius:2000 identifier:@"test"];
    
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator startAnimating];
    textField.rightView = loadingIndicator;
    
    self.goButton.enabled = NO;
    
    [geocoder geocodeAddressString:textField.text inRegion:nil completionHandler:^(NSArray* placemarks, NSError* error) {
        if (placemarks.count == 0) {
            // no results
            [textField setText:textField.text andLocation:nil];
        } else if (placemarks.count > 1) {
            // TODO: disambigate
        } else {
            // Got one result, process it.
            CLPlacemark *result = [placemarks objectAtIndex:0];
            
            [self.mapView removeAllAnnotations];
            
            RMAnnotation* placeAnnotation = [RMAnnotation
                                             annotationWithMapView:self.mapView
                                             coordinate:result.location.coordinate
                                             andTitle:@"Dropped Pin"];
            
            RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:nil tintColor:[UIColor blueColor]];
            marker.zPosition = 10;
            
            SMCalloutView *calloutView = [[SMCalloutView alloc] init];
            calloutView.title = [(NSArray *)[result.addressDictionary objectForKey:@"FormattedAddressLines"] objectAtIndex:0];
            
            OTPCallout *callout = [[OTPCallout alloc] initWithCallout:calloutView forMarker:marker inMap:self.mapView];
            
            marker.label = callout;
            
            placeAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [placeAnnotation.userInfo setObject:marker forKey:@"layer"];
            
            [self.mapView setZoom:13];
            
            CGPoint mapCenterScreen = [self.view convertPoint:self.mapView.center toView:nil];
            CGFloat shift = mapCenterScreen.y - topOfKeyboard + 10;
            
            RMProjectedPoint projectedLocation = [self.mapView coordinateToProjectedPoint:result.location.coordinate];
            projectedLocation.y = projectedLocation.y - shift * self.mapView.metersPerPixel;
            
            [self.mapView addAnnotation:placeAnnotation];
            
            [self.mapView setCenterProjectedPoint:projectedLocation animated:YES];
            
            [textField setText:[(NSArray *)[result.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "] andLocation:result.location];
            
            if (textField.otherTextField.isGeocoded) {
                self.goButton.enabled = YES;
            }
        }
    }];
    
}

- (void)switchFromAndTo:(id)sender
{
    [self.fromTextField switchValuesWithOther];
}

- (IBAction)modeChanged:(id)sender {
    if (((UISegmentedControl *)sender).selectedSegmentIndex < 2) {
        self.timeButton.enabled = YES;
    } else {
        self.timeButton.enabled = NO;
    }
}

- (void)updatedTextField:(id)sender
{
    self.goButton.enabled = NO;
    OTPGeocodedTextField *textField = (OTPGeocodedTextField *)sender;
    [textField setText:textField.text andLocation:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    OTPGeocodedTextField *field = (OTPGeocodedTextField *)textField;
    if (!field.isGeocoded && field.text.length > 0) {
        [self geocodeStringInTextField:field];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    OTPGeocodedTextField *field = (OTPGeocodedTextField *)textField;
    
    // If the other text field has valid geocoded data, we don't need to do anything
    if ([field.otherTextField isGeocoded]) {
        [textField resignFirstResponder];
        return YES;
    }
    // The other text field needs input so make it the first responder
    [((OTPGeocodedTextField *)textField).otherTextField becomeFirstResponder];
    return YES;
}

- (void)showUserLocation:(id)sender
{
    if (self.userLocation) {
        [self updateViewsForCurrentUserLocation];
    }
    self.needsPanToUserLocation = YES;
    self.mapView.showsUserLocation = YES;
}

- (void)updateViewsForCurrentUserLocation
{
    if (self.userLocation == nil) {
        return;
    }
    // Show user location on the map
    [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:self.userLocation.coordinate northEast:self.mapView.userLocation.coordinate animated:YES];
    
    // Set the from or to textfields to user location
    if (![self.fromTextField isGeocoded] && ![self.toTextField isCurrentLocation]) {
        [self.fromTextField setText:@"Current Location" andLocation:self.userLocation.location];
    } else if (![self.toTextField isGeocoded] && ![self.fromTextField isCurrentLocation]) {
        [self.toTextField setText:@"Current Location" andLocation:self.userLocation.location];
    }
    
    if (self.fromTextField.isGeocoded && self.toTextField.isGeocoded) {
        self.goButton.enabled = YES;
    }
    
    self.needsPanToUserLocation = NO;
}

#pragma mark RMMapViewDelegate methods

- (void)mapView:(RMMapView *)mapView didUpdateUserLocation:(RMUserLocation *)userLocation
{
    self.userLocation = userLocation;
    if (self.needsPanToUserLocation) {
        [self updateViewsForCurrentUserLocation];
    }
}

- (void)mapView:(RMMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    // Alert user that location couldn't be detirmined.
}

- (void)singleTapOnMap:(RMMapView *)map at:(CGPoint)point
{
    [self.view endEditing:YES];
}

- (void)longSingleTapOnMap:(RMMapView *)map at:(CGPoint)point
{
    RMAnnotation *pin = [[RMAnnotation alloc] initWithMapView:self.mapView coordinate:[self.mapView pixelToCoordinate:point] andTitle:@"pin"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    RMMarker *layer = [[RMMarker alloc] initWithMapBoxMarkerImage:nil tintColor:[UIColor redColor]];
    [userInfo setObject:layer forKey:@"layer"];
    pin.userInfo = userInfo;
    [self.mapView addAnnotation:pin];
}

- (void)tapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{

}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    return [annotation.userInfo objectForKey:@"layer"];
}

- (void)afterMapMove:(RMMapView *)map byUser:(BOOL)wasUserAction
{
    if (!wasUserAction && self.mapView.annotations.count > 0) {
        RMAnnotation *annotation = [self.mapView.annotations objectAtIndex:0];
        RMMarker* marker = [[annotation userInfo] objectForKey:@"layer"];
        [((OTPCallout *)marker.label) toggle];
    }
}

#pragma mark OTPTransitTimeViewControllerDelegate methods

- (void)transitTimeViewController:(OTPTransitTimeViewController *)transitTimeViewController didChooseArrivingOrDepartingIndex:(NSNumber *)arrivingOrDepartingIndex atTime:(NSDate *)time
{
    self.arriveOrDepartByIndex = arrivingOrDepartingIndex;
    self.date = time;
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    NSLog(@"Loaded plan: %@", objects);
    [HUD hide:YES];
    currentPlan = (Plan*)[objects objectAtIndex:0];
    //[self displayItinerary:[currentPlan.itineraries objectAtIndex:0]];
    [self performSegueWithIdentifier:@"ExploreItineraries" sender:self];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // pass itineraries to next view controller
    if ([segue.identifier isEqualToString:@"ExploreItineraries"]) {
        ((OTPTransitTimesViewController*)((UINavigationController*)segue.destinationViewController).topViewController).itineraries = currentPlan.itineraries;
    } else if ([segue.identifier isEqualToString:@"TransitTimes"]) {
        OTPTransitTimeViewController *vc = (OTPTransitTimeViewController *)segue.destinationViewController;
        vc.delegate = self;
        vc.date = [[NSDate alloc] init];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// A method to convert an enum to string
-(NSString*) transitModeTypeEnumToString:(kTransitModeType)enumVal
{
    return kTransitModeTypeArray[enumVal];
}

// A method to retrieve the int value from the C array of NSStrings
-(kTransitModeType) transitModeTypeStringToEnum:(NSString*)strVal
{
    int retVal;
    for(int i=0; i < sizeof(kTransitModeTypeArray)-1; i++)
    {
        if([(NSString*)kTransitModeTypeArray[i] isEqual:strVal])
        {
            retVal = i;
            break;
        }
    }
    return (kTransitModeType)retVal;
}

- (void)viewDidUnload {
    [self setTimeButton:nil];
    [super viewDidUnload];
}
@end
