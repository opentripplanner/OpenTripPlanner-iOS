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
    @"WALK",
    @"BIKE"
};

@interface OTPDirectionsInputViewController ()

- (void)switchFromAndTo:(id)sender;
- (void)geocodeStringInTextField:(OTPGeocodedTextField *)textField;
- (void)didShowKeyboard:(NSNotification *)notification;
- (void)willHideKeyboard:(NSNotification *)notification;

@end

@implementation OTPDirectionsInputViewController

@synthesize modeControl = _modeControl;
@synthesize textFieldContainer = _textFieldContainer;
@synthesize fromTextField = _fromTextField;
@synthesize toTextField = _toTextField;
@synthesize dummyField = _dummyField;
@synthesize switchFromAndToButton = _switchFromAndToButton;
@synthesize mapView = _mapView;
@synthesize userLocation = _userLocation;

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
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    geocoder = [[CLGeocoder alloc] init];
    
    self.dummyField.hidden = YES;
    
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
    
    self.textFieldContainer.layer.shadowOffset = CGSizeMake(0, 2);
    self.textFieldContainer.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.textFieldContainer.layer.shadowRadius = 3.0;
    self.textFieldContainer.layer.shadowOpacity = 0.8;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.fromTextField becomeFirstResponder];
}

- (void)didShowKeyboard:(NSNotification *)notification
{
    NSLog(@"Did show keyboard");
    if (!topOfKeyboard) {
        CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        topOfKeyboard = keyboardRect.origin.y - keyboardRect.size.height;
    }
//    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    CGRect currentMapFrame = self.mapView.frame;
//    CGFloat newMapHeight = currentMapFrame.size.height - keyboardRect.size.height;
//    CGRect newMapFrame = CGRectMake(currentMapFrame.origin.x, currentMapFrame.origin.y, currentMapFrame.size.width, newMapHeight);
//    self.mapView.frame = newMapFrame;
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
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeString = [dateFormatter stringFromDate:now];
    
    NSString *fromString = [NSString stringWithFormat:@"%f,%f", startPoint.latitude, startPoint.longitude];
    NSString *toString = [NSString stringWithFormat:@"%f,%f", endPoint.latitude, endPoint.longitude];
    
    
    NSDictionary* params = [NSDictionary dictionaryWithKeysAndObjects:
                            @"optimize", @"QUICK",
                            @"time", timeString,
                            @"arriveBy", @"false",
                            @"routerId", @"req-241",
                            @"maxWalkDistance", @"840",
                            @"fromPlace", fromString,
                            @"toPlace", toString,
                            @"date", dateString,
                            @"mode", @"TRANSIT,WALK",
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
    textField.isDirty = NO;
    textField.placemark = nil;
    textField.returnKeyType = UIReturnKeyNext;
    self.dummyField.returnKeyType = UIReturnKeyNext;
    [textField reloadInputViews];
    [self.dummyField reloadInputViews];
    
    [geocoder geocodeAddressString:textField.text inRegion:nil completionHandler:^(NSArray* placemarks, NSError* error) {
        if (placemarks.count == 0) {
            // no results
            textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x.png"]];
        } else if (placemarks.count > 1) {
            // TODO: disambigate
            UILabel *l = [[UILabel alloc] init];
            l.text = @"?";
            textField.rightView = l;
        } else {
            // Got one result, process it.
            CLPlacemark *result = [placemarks objectAtIndex:0];
            
            RMAnnotation* placeAnnotation = [RMAnnotation
                                             annotationWithMapView:self.mapView
                                             coordinate:result.location.coordinate
                                             andTitle:@"Dropped Pin"];
            
            RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:nil tintColor:[UIColor blueColor]];
            marker.zPosition = 10;
            
            SMCalloutView *calloutView = [[SMCalloutView alloc] init];
            calloutView.title = @"Dropped Pin";
            
            OTPCallout *callout = [[OTPCallout alloc] initWithCallout:calloutView forMarker:marker inMap:self.mapView];
            
            marker.label = callout;
            
            placeAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [placeAnnotation.userInfo setObject:marker forKey:@"layer"];
            
            [self.mapView setZoom:13];
            [self.mapView setCenterCoordinate:result.location.coordinate animated:YES];
            
            [self.mapView addAnnotation:placeAnnotation];
            [callout toggle];
            
            textField.placemark = result;
            textField.text = [(NSArray *)[result.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
            
            if (textField.otherTextField.placemark != nil && textField.otherTextField.text != nil && ![textField.otherTextField.text isEqualToString:@""]) {
                textField.returnKeyType = UIReturnKeyRoute;
                textField.otherTextField.returnKeyType = UIReturnKeyRoute;
                self.dummyField.returnKeyType = UIReturnKeyRoute;
                [textField reloadInputViews];
                [textField.otherTextField reloadInputViews];
                [self.dummyField reloadInputViews];
            }
        }
    }];
    
}

- (void)switchFromAndTo:(id)sender
{
    NSString *tmpText = self.fromTextField.text;
    CLPlacemark *tmpPlacemark = self.fromTextField.placemark;
    UIView *tmpView = self.fromTextField.rightView;
    BOOL tmpIsDirty = self.fromTextField.isDirty;
    
    self.fromTextField.text = self.toTextField.text;
    self.fromTextField.placemark = self.toTextField.placemark;
    self.fromTextField.rightView = self.toTextField.rightView;
    self.fromTextField.isDirty = self.toTextField.isDirty;
    
    self.toTextField.text = tmpText;
    self.toTextField.placemark = tmpPlacemark;
    self.toTextField.rightView = tmpView;
    self.toTextField.isDirty = tmpIsDirty;
    
    [self.fromTextField reloadInputViews];
    [self.toTextField reloadInputViews];
}

- (void)updatedTextField:(id)sender
{
    NSLog(@"updated text field");
    OTPGeocodedTextField *textField = (OTPGeocodedTextField *)sender;
    textField.isDirty = YES;
    textField.rightView = nil;
    textField.returnKeyType = UIReturnKeyNext;
    textField.otherTextField.returnKeyType = UIReturnKeyNext;
    self.dummyField.returnKeyType = UIReturnKeyNext;
    [textField reloadInputViews];
    [textField.otherTextField reloadInputViews];
    [self.dummyField reloadInputViews];
}

- (void)doneEditingTextField:(id)sender
{
    OTPGeocodedTextField *textField = (OTPGeocodedTextField *)sender;
    if ([textField isDirty] && ![textField.text isEqualToString:@""]) {
        [self geocodeStringInTextField:(OTPGeocodedTextField *)sender];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    OTPGeocodedTextField *field = (OTPGeocodedTextField *)textField;
    
    // If the user is submitting a route query, don't do anything other than launch the query
    if (field.returnKeyType == UIReturnKeyRoute) {
        // Launch the route query
        [self planTripFrom:self.fromTextField.placemark.location.coordinate to:self.toTextField.placemark.location.coordinate];
        [self.fromTextField resignFirstResponder];
        [self.toTextField resignFirstResponder];
        [self.dummyField resignFirstResponder];
        return NO;
    }
    // If the other text field has valid geocoded data, we don't need to do anything
    if (field.otherTextField.placemark != nil && field.otherTextField.text != nil && ![field.otherTextField.text isEqualToString:@""]) {
        [self.dummyField becomeFirstResponder];
        return YES;
    }
    // The other text field needs input so make it the first responder
    [((OTPGeocodedTextField *)textField).otherTextField becomeFirstResponder];
    return YES;
}

#pragma mark RMMapViewDelegate methods

- (void)mapView:(RMMapView *)mapView didUpdateUserLocation:(RMUserLocation *)userLocation
{
    
}

- (void)mapView:(RMMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    // Alert user that location couldn't be detirmined.
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    return [annotation.userInfo objectForKey:@"layer"];
}

- (void)longSingleTapOnMap:(RMMapView *)map at:(CGPoint)point
{

}

- (void)tapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{

}

- (void)mapViewRegionDidChange:(RMMapView *)mapView
{
    
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    NSLog(@"Loaded plan: %@", objects);
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
    ((OTPTransitTimesViewController*)((UINavigationController*)segue.destinationViewController).topViewController).itineraries = currentPlan.itineraries;
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

@end
