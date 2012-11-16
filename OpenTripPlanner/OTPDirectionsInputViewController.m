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
#import "NSString+HMAC.h"

NSString * const kTransitModeTypeArray[] = {
    @"WALK,TRANSIT",
    @"BICYCLE,TRANSIT",
    @"BICYCLE",
    @"WALK"
};

NSString * const kArriveByArray[] = {
    @"false",
    @"true"
};

@interface OTPDirectionsInputViewController ()
{
    RMAnnotation *_fromAnnotation;
    RMAnnotation *_toAnnotation;
    OTPGeocodedTextField *_textFieldToDisambiguate;
    NSArray *_placemarksToDisambiguate;
    UIImage *_fromPinImage;
    UIImage *_toPinImage;
    int _dragOffset;
}

- (void)switchFromAndTo:(id)sender;
- (void)geocodeStringInTextField:(OTPGeocodedTextField *)textField;
- (void)willShowKeyboard:(NSNotification *)notification;
- (void)willHideKeyboard:(NSNotification *)notification;
- (void)panMapToCurrentGeocodedTextField;
- (void)updateViewsForCurrentUserLocation;
- (RMProjectedPoint)adjustPointForKeyboard:(CLLocationCoordinate2D)coordinate;

@end

@implementation OTPDirectionsInputViewController

CLGeocoder *geocoder;
CLPlacemark *fromPlacemark;
CLPlacemark *toPlacemark;
NSNumber *topOfKeyboard;

Plan *currentPlan;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _fromPinImage = [UIImage imageNamed:@"marker-start.png"];
    _toPinImage = [UIImage imageNamed:@"marker-end.png"];
    
    _dragOffset = 0;
    
    self.goButton.enabled = NO;
    
    [self modeChanged:self.modeControl];
    
    self.arriveOrDepartByIndex = [NSNumber numberWithInt:0];
    self.modeControl.selectedSegmentIndex = 0;
    self.date = [[NSDate alloc] init];
    
    self.navBar.topItem.titleView = self.modeControl;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
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
    [self.mapView setConstraintsSouthWest:CLLocationCoordinate2DMake(20, -130) northEast:CLLocationCoordinate2DMake(53, -57)];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(40, -95)];
    [self.mapView setZoom:4];
	
    self.switchFromAndToButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[UIImage imageNamed:@"swap-addresses.png"], nil]];
    self.switchFromAndToButton.segmentedControlStyle = UISegmentedControlStyleBar;
    self.switchFromAndToButton.tintColor = [UIColor blackColor];
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

- (void)go:(id)sender
{
    [TestFlight passCheckpoint:@"DIRECTIONS_GO"];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.labelText = @"Routing";
	HUD.dimBackground = NO;
    HUD.removeFromSuperViewOnHide = YES;
	[HUD show:YES];
    
    [self planTripFrom:self.fromTextField.location.coordinate to:self.toTextField.location.coordinate];
    [self.fromTextField resignFirstResponder];
    [self.toTextField resignFirstResponder];
}

- (void)willShowKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    topOfKeyboard = [NSNumber numberWithFloat:keyboardRect.origin.y - keyboardRect.size.height];
    
    [self panMapToCurrentGeocodedTextField];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.userLocationButton.center = CGPointMake(self.userLocationButton.center.x, self.userLocationButton.center.y - keyboardRect.size.height);
    }];
}

- (void)willHideKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    topOfKeyboard = nil;
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.5 animations:^{
        self.userLocationButton.center = CGPointMake(self.userLocationButton.center.x, self.userLocationButton.center.y + keyboardRect.size.height);
    }];
}

- (void)updateTextField:(OTPGeocodedTextField *)textField withText:(NSString *)text andLocation:(CLLocation *)location
{
    // Set the text field properties so its views reflect current data
    [textField setText:text andLocation:location];
    
    // Enable/disable go button
    if (textField.isGeocoded && textField.otherTextField.isGeocoded) {
        self.goButton.enabled = YES;
    } else {
        self.goButton.enabled = NO;
    }
    
    // Manage map annotations
    // If we are not geocoded, check if any corresponding map annotations exist and remove them
    if (!textField.isGeocoded) {
        // If the text field is associated with a pin, remove it from the map
        if (textField == self.fromTextField && _fromAnnotation != nil) {
            [self.mapView removeAnnotation:_fromAnnotation];
            _fromAnnotation = nil;
        } else if (textField == self.toTextField && _toAnnotation != nil) {
            [self.mapView removeAnnotation:_toAnnotation];
            _toAnnotation = nil;
        }
    } else {
        if (!textField.isCurrentLocation) {
            // We are geocoded and user location, so add an annotation to the map
            RMAnnotation* placeAnnotation = [RMAnnotation
                                             annotationWithMapView:self.mapView
                                             coordinate:location.coordinate
                                             andTitle:nil];
            
            if (textField == self.fromTextField) {
                _fromAnnotation = placeAnnotation;
            } else {
                _toAnnotation = placeAnnotation;
            }
            
            [self.mapView addAnnotation:placeAnnotation];
            
            if (_fromTextField.isGeocoded && _toTextField.isGeocoded && ![placeAnnotation isAnnotationWithinBounds:self.mapView.bounds]) {
                [self showFromAndToLocations];
            }
        }
        if (self.fromTextField.isFirstResponder || self.toTextField.isFirstResponder) {
            //if ((!textField.otherTextField.isGeocoded && textField.otherTextField.isFirstResponder) || !textField.otherTextField.isFirstResponder) {
                //[self.mapView setCenterProjectedPoint:[self adjustPointForKeyboard:location.coordinate] animated:YES];
            //}
        }
    }
}


#pragma mark OTP methods

- (void)planTripFrom:(CLLocationCoordinate2D)startPoint to:(CLLocationCoordinate2D)endPoint
{
    // TODO: Look at how time zone plays into all this.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    // If the tracked date is before now, set the tracked date to now.
    self.date = [[[NSDate alloc] init] laterDate:self.date];
    NSString *dateString = [dateFormatter stringFromDate:self.date];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeString = [dateFormatter stringFromDate:self.date];
    
    NSString *fromString = [NSString stringWithFormat:@"%f,%f", startPoint.latitude, startPoint.longitude];
    NSString *toString = [NSString stringWithFormat:@"%f,%f", endPoint.latitude, endPoint.longitude];
    
    NSString *mode = kTransitModeTypeArray[self.modeControl.selectedSegmentIndex];
    NSString *arriveBy = kArriveByArray[self.arriveOrDepartByIndex.intValue];
    
    NSString *secret = @"8AcRe4usPEpEThuW";
    NSString *apiKey = @"joyride";
    NSString *signature = [[[apiKey stringByAppendingString:fromString] stringByAppendingString:toString] HMACWithSecret:secret];
    
    NSDictionary* params = [NSDictionary dictionaryWithKeysAndObjects:
                            @"optimize", @"QUICK",
                            @"time", timeString,
                            @"arriveBy", arriveBy,
                            //@"routerId", @"req-241",
                            //@"routerId", @"req-92",
                            @"maxWalkDistance", @"2000",
                            @"fromPlace", fromString,
                            @"toPlace", toString,
                            @"date", dateString,
                            @"mode", mode,
                            @"showIntermediateStops", @"true",
                            @"apiKey", apiKey,
                            @"signature", signature,
                            nil];
    
    NSString* resourcePath = [@"/plan" stringByAppendingQueryParameters: params];
    
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

- (void)geocodeStringInTextField:(OTPGeocodedTextField *)textField
{
    // Create a region based on either the user's current location or the map center
    // using a width of the larger of the width of the displayed map area or 200km.
    CLLocationCoordinate2D regionCoordinate;
    if (self.userLocation != nil && self.mapView.showsUserLocation) {
        regionCoordinate = self.userLocation.location.coordinate;
    } else {
        regionCoordinate = self.mapView.centerCoordinate;
    }
    double radius = MAX(self.mapView.projectedViewSize.width/2, 100000);
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:regionCoordinate radius:radius identifier:@"GEOCODE_REGION"];
    
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator startAnimating];
    textField.rightView = loadingIndicator;
    
    [geocoder geocodeAddressString:textField.text inRegion:region completionHandler:^(NSArray* placemarks, NSError* error) {
        if (placemarks.count == 0) {
            // no results
            [textField setText:textField.text andLocation:nil];
        } else if (placemarks.count > 1) {
            // TODO: disambigate
            _textFieldToDisambiguate = textField;
            _placemarksToDisambiguate = placemarks;
            [self performSegueWithIdentifier:@"DisambiguateGeocode" sender:self];
        } else {
            // Got one result, process it.
            CLPlacemark *result = [placemarks objectAtIndex:0];
            
            // Filter out the country
            NSArray *formattedAddressLines = (NSArray *)[result.addressDictionary objectForKey:@"FormattedAddressLines"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != %@", result.country];
            NSArray *filteredAddressLines = [formattedAddressLines filteredArrayUsingPredicate:predicate];

            [self updateTextField:textField withText:[filteredAddressLines componentsJoinedByString:@", "] andLocation:result.location];
        }
    }];
    
}

- (void)switchFromAndTo:(id)sender
{
    [TestFlight passCheckpoint:@"DIRECTIONS_SWITCH_FROM_TO"];
    
    [self.fromTextField switchValuesWithOther];
    
    RMAnnotation *tmpAnnotation = _fromAnnotation;
    _fromAnnotation = _toAnnotation;
    _toAnnotation = tmpAnnotation;
    
    [(RMMarker*)_fromAnnotation.layer replaceUIImage:_fromPinImage];
    [(RMMarker*)_toAnnotation.layer replaceUIImage:_toPinImage];
    
    [self panMapToCurrentGeocodedTextField];
}

- (IBAction)modeChanged:(id)sender {
    [TestFlight passCheckpoint:@"DIRECTIONS_CHANGE_MODE"];
    if (((UISegmentedControl *)sender).selectedSegmentIndex < 2) {
        self.timeButton.enabled = YES;
    } else {
        self.timeButton.enabled = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [TestFlight passCheckpoint:@"DIRECTIONS_DID_TYPE_INTO_TEXTFIELD"];
    [self panMapToCurrentGeocodedTextField];
}

- (void)updatedTextField:(id)sender
{
    OTPGeocodedTextField *textField = (OTPGeocodedTextField *)sender;
    
    if (textField.otherTextField.isDroppedPin) {
        textField.otherTextField.text = @"Dropped Pin";
    }
    
    [self updateTextField:textField withText:textField.text andLocation:nil];
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

- (void)panToUserLocation:(id)sender
{
    [TestFlight passCheckpoint:@"DIRECTIONS_PAN_TO_USER_LOCATION"];
    self.needsPanToUserLocation = YES;
    [self enableUserLocation];
}

- (IBAction)touchAboutButton:(id)sender
{
    [self performSegueWithIdentifier:@"showAbout" sender:self];    
}

- (void)enableUserLocation
{
    self.mapView.showsUserLocation = YES;
    [self updateViewsForCurrentUserLocation];
}

- (void)updateViewsForCurrentUserLocation
{
    if (self.userLocation == nil) {
        return;
    }
    
    // Set the from or to textfields to user location
    OTPGeocodedTextField *textField;
    if (![self.fromTextField isGeocoded] && ![self.toTextField isCurrentLocation]) {
        textField = self.fromTextField;
    } else if (![self.toTextField isGeocoded] && ![self.fromTextField isCurrentLocation]) {
        textField = self.toTextField;
    }
    if (textField != nil) {
        [self updateTextField:textField withText:@"Current Location" andLocation:self.userLocation.location];
    }
    
    // Show user location on the map
    if (self.needsPanToUserLocation) {
        CLLocationCoordinate2D adjustedCoord = [self.mapView projectedPointToCoordinate:[self adjustPointForKeyboard:self.userLocation.coordinate]];
        CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(adjustedCoord.latitude - 0.0085, adjustedCoord.longitude - 0.005);
        CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(adjustedCoord.latitude + 0.0085, adjustedCoord.longitude + 0.005);
        [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:YES];
        self.needsPanToUserLocation = NO;
    } else if (self.needsShowFromAndToLocations) {
        [self showFromAndToLocations];
        self.needsShowFromAndToLocations = NO;
    }
}

#pragma mark RMMapViewDelegate methods

- (void)mapView:(RMMapView *)mapView didUpdateUserLocation:(RMUserLocation *)userLocation
{
    self.userLocation = userLocation;
    // Keep any current location input field up to date
    if (self.fromTextField.isCurrentLocation) {
        [self.fromTextField setText:self.fromTextField.text andLocation:userLocation.location];
    } else if (self.toTextField.isCurrentLocation) {
        [self.toTextField setText:self.toTextField.text andLocation:userLocation.location];
    }
    if (self.needsPanToUserLocation || self.needsShowFromAndToLocations) {
        [self updateViewsForCurrentUserLocation];
    }
}

- (void)mapView:(RMMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    // Alert user that location couldn't be detirmined.
    [TestFlight passCheckpoint:@"DIRECTIONS_FAILED_TO_LOCATE_USER"];
}

- (void)singleTapOnMap:(RMMapView *)map at:(CGPoint)point
{
    if ((self.fromTextField.isFirstResponder || self.toTextField.isFirstResponder) && self.fromTextField.isGeocoded && self.toTextField.isGeocoded) {
        [self showFromAndToLocations];
    }
    [self.view endEditing:YES];
}

- (void)longSingleTapOnMap:(RMMapView *)map at:(CGPoint)point
{
    CLLocationCoordinate2D coord = [self.mapView pixelToCoordinate:point];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    OTPGeocodedTextField *textField;
    if (!self.fromTextField.isGeocoded) {
        textField = self.fromTextField;
    } else if (!self.toTextField.isGeocoded) {
        textField = self.toTextField;
    } else {
        [TestFlight passCheckpoint:@"DIRECTIONS_LONG_TAP_NO_PIN_ALLOWED"];
        return;
    }
    [TestFlight passCheckpoint:@"DIRECTIONS_LONG_TAP_DROP_PIN"];
    [self updateTextField:textField withText:@"Dropped Pin" andLocation:location];
}

- (void)tapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{

}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    UIImage *image;
    if (annotation == _fromAnnotation) {
        image = _fromPinImage;
    } else if (annotation == _toAnnotation) {
        image = _toPinImage;
    } else {
        return nil;
    }
    RMMarker *marker = [[RMMarker alloc] initWithUIImage:image];
    marker.enableDragging = YES;
    marker.zPosition = 10;
    
    if ([annotation isAnnotationWithinBounds:self.mapView.bounds]) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(annotation.position.x, 0)];
        animation.toValue = [NSValue valueWithCGPoint:annotation.position];
        animation.duration = 0.2;
        animation.delegate = self;
        [marker addAnimation:animation forKey:@"position"];
    }
    return marker;
}

- (BOOL)mapView:(RMMapView *)map shouldDragAnnotation:(RMAnnotation *)annotation
{
    return YES;
}

- (void)mapView:(RMMapView *)map didDragAnnotation:(RMAnnotation *)annotation withDelta:(CGPoint)delta
{
    if (_dragOffset < 10) {
        delta.y = delta.y + _dragOffset;
    }
    annotation.position = CGPointMake(annotation.position.x - delta.x, annotation.position.y - delta.y);
    _dragOffset++;
}

- (void)mapView:(RMMapView *)map didEndDragAnnotation:(RMAnnotation *)annotation
{
    [TestFlight passCheckpoint:@"DIRECTIONS_DRAGGED_PIN"];
    annotation.coordinate = [map pixelToCoordinate:annotation.position];
    _dragOffset = 0;
    
    OTPGeocodedTextField *textField;
    if (annotation == _fromAnnotation) {
        textField = self.fromTextField;
    } else {
        textField = self.toTextField;
    }
    textField.text = @"Dropped Pin";
    textField.location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_fromTextField.isGeocoded && _toTextField.isGeocoded) {
        [self showFromAndToLocations];
    }
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

#pragma mark OTPGeocodeDisambigationViewControllerDelegate methods
- (void)userSelectedPlacemark:(CLPlacemark *)placemark
{
    // Filter out the country
    NSArray *formattedAddressLines = (NSArray *)[placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != %@", placemark.country];
    NSArray *filteredAddressLines = [formattedAddressLines filteredArrayUsingPredicate:predicate];
    
    [self updateTextField:_textFieldToDisambiguate withText:[filteredAddressLines componentsJoinedByString:@", "] andLocation:placemark.location];
}

- (void)userCanceledDisambiguation
{
    [self updateTextField:_textFieldToDisambiguate withText:nil andLocation:nil];
}

#pragma mark RKObjectLoaderDelegate methods

RKResponse* _OTPResponse = nil;

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    [TestFlight passCheckpoint:@"DIRECTIONS_RECEIVED_RESPONSE_FROM_API"];
    //NSLog(@"Loaded payload: %@", [response bodyAsString]);
    _OTPResponse = response;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    [TestFlight passCheckpoint:@"DIRECTIONS_LOADED_PLAN_FROM_API_RESPONSE"];
    //NSLog(@"Loaded plan: %@", objects);
    [HUD hide:YES];

    currentPlan = (Plan*)[objects objectAtIndex:0];
    [self performSegueWithIdentifier:@"ExploreItineraries" sender:self];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    //NSLog(@"Hit error: %@", error);
    [TestFlight passCheckpoint:@"DIRECTIONS_RECEIVED_ERROR_FROM_API"];
    [HUD hide:YES];

    if(_OTPResponse != nil) {
        NSString *OTPError = [_OTPResponse bodyAsString];
        OTPError = [OTPError stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                              
        if([OTPError hasSuffix:@"is out of range"]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"We're not yet able to plan trips across cities. Try a trip completely within your start or ending city." delegate:nil cancelButtonTitle:@"Got It" otherButtonTitles:nil];
            [alert show];
        }        
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // pass itineraries to next view controller
    if ([segue.identifier isEqualToString:@"ExploreItineraries"]) {
        OTPTransitTimesViewController *vc = ((OTPTransitTimesViewController*)((UINavigationController*)segue.destinationViewController).topViewController);
        vc.itineraries = currentPlan.itineraries;
        vc.fromTextField = self.fromTextField;
        vc.toTextField = self.toTextField;
        if (self.mapView.showsUserLocation) {
            vc.mapShowedUserLocation = YES;
        } else {
            vc.mapShowedUserLocation = NO;
        }
    } else if ([segue.identifier isEqualToString:@"TransitTimes"]) {
        OTPTransitTimeViewController *vc = (OTPTransitTimeViewController *)segue.destinationViewController;
        vc.delegate = self;
        vc.date = self.date;
        vc.selectedSegment = self.arriveOrDepartByIndex;
    } else if ([segue.identifier isEqualToString:@"DisambiguateGeocode"]) {
        UINavigationController *vc = (UINavigationController *)segue.destinationViewController;
        ((OTPGeocodeDisambigationViewController *)vc.topViewController).placemarks = _placemarksToDisambiguate;
        ((OTPGeocodeDisambigationViewController *)vc.topViewController).delegate = self;
    }
    
}

- (void)panMapToCurrentGeocodedTextField
{
    OTPGeocodedTextField *field;
    if (self.fromTextField.isFirstResponder) {
        field = self.fromTextField;
    } else if (self.toTextField.isFirstResponder) {
        field = self.toTextField;
    }
    if (field && field.isGeocoded) {
        CLLocationCoordinate2D adjustedCoord = [self.mapView projectedPointToCoordinate:[self adjustPointForKeyboard:field.location.coordinate]];
        CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(adjustedCoord.latitude - 0.0085, adjustedCoord.longitude - 0.005);
        CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(adjustedCoord.latitude + 0.0085, adjustedCoord.longitude + 0.005);
        [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:YES];
    }
}

- (void)showFromAndToLocations
{
    NSMutableArray *validLocations = [[NSMutableArray alloc] init];
    if (self.fromTextField.location.coordinate.latitude != 0.0 && self.fromTextField.location.coordinate.latitude != 0.0) {
        [validLocations addObject:self.fromTextField.location];
    }
    if (self.toTextField.location.coordinate.latitude != 0.0 && self.toTextField.location.coordinate.latitude != 0.0) {
        [validLocations addObject:self.toTextField.location];
    }
    if (validLocations.count == 0) {
        return;
    }
    CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(1000, 1000);
    CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(-1000, -1000);
    for (CLLocation *location in validLocations) {
        sw.latitude = MIN(sw.latitude, location.coordinate.latitude);
        sw.longitude = MIN(sw.longitude, location.coordinate.longitude);
        ne.latitude = MAX(ne.latitude, location.coordinate.latitude);
        ne.longitude = MAX(ne.longitude, location.coordinate.longitude);
    }
    [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:YES];
}

- (RMProjectedPoint)adjustPointForKeyboard:(CLLocationCoordinate2D)coordinate
{
    RMProjectedPoint projectedLocation = [self.mapView coordinateToProjectedPoint:coordinate];
    
    if (!topOfKeyboard) {
        return projectedLocation;
    }
    
    CGPoint mapCenterScreen = [self.view convertPoint:self.mapView.center toView:nil];
    CGRect mapRectScreen = [self.view convertRect:self.mapView.frame toView:nil];
    CGFloat shift = mapCenterScreen.y - topOfKeyboard.floatValue + ((topOfKeyboard.floatValue - mapRectScreen.origin.y) * 0.4);
    
    projectedLocation.y = projectedLocation.y - shift * self.mapView.metersPerPixel;
    
    return projectedLocation;
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
