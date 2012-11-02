//
//  OTPViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 8/30/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPViewController.h"
#import "OTPTransitTimesViewController.h"
#import "OTPCallout.h"
#import "Plan.h"
#import "SMCalloutView.h"

@interface OTPViewController ()

- (void)showUserLocation;

@end

@implementation OTPViewController

OTPDirectionsInputViewController *directionsInputViewController;
CLLocationCoordinate2D currentLocationToOrFromPoint;
SEL currentLocationRoutingSelector;
BOOL needsRouting = NO;

- (void)showUserLocation
{
    self.mapView.userTrackingMode = RMUserTrackingModeNone;
    self.mapView.showsUserLocation = YES;
}

#pragma mark UISearchBarDelegate methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    searchBar.text = nil;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.mapView removeAllAnnotations];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    CLLocationCoordinate2D regionCoordinate;
    if (self.userLocation != nil) {
        regionCoordinate = self.userLocation.coordinate;
    } else {
        regionCoordinate = self.mapView.centerCoordinate;
    }
    
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:regionCoordinate radius:2000 identifier:@"test"];
    
    [self.searchBar startActivity];
    
    [geocoder geocodeAddressString:searchBar.text inRegion:region completionHandler:^(NSArray* placemarks, NSError* error) {
        [self.searchBar finishActivity];
        
        int counter = 0;
        CLLocationCoordinate2D northEastPoint;
        CLLocationCoordinate2D southWestPoint;
        
        for (CLPlacemark* aPlacemark in placemarks) {
            RMAnnotation* placeAnnotation = [RMAnnotation
                                             annotationWithMapView:self.mapView
                                             coordinate:aPlacemark.location.coordinate
                                             andTitle:aPlacemark.name];
            RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:nil tintColor:[UIColor blueColor]];
            marker.zPosition = 10;
            placeAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [placeAnnotation.userInfo setObject:marker forKey:@"layer"];
            [self.mapView addAnnotation:placeAnnotation];
            
            if (counter == 0) {
                northEastPoint = aPlacemark.location.coordinate;
                southWestPoint = aPlacemark.location.coordinate;
            } else {
                if (aPlacemark.location.coordinate.longitude > northEastPoint.longitude)
                    northEastPoint.longitude = aPlacemark.location.coordinate.longitude;
                if(aPlacemark.location.coordinate.latitude > northEastPoint.latitude)
                    northEastPoint.latitude = aPlacemark.location.coordinate.latitude;
                if (aPlacemark.location.coordinate.longitude < southWestPoint.longitude)
                    southWestPoint.longitude = aPlacemark.location.coordinate.longitude;
                if (aPlacemark.location.coordinate.latitude < southWestPoint.latitude)
                    southWestPoint.latitude = aPlacemark.location.coordinate.latitude;
            }
            counter++;
        }
        if (placemarks.count > 0) {
            if (placemarks.count == 1) {
                CLPlacemark *result = [placemarks objectAtIndex:0];
                self.searchBar.text = [(NSArray *)[result.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            }
            [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:southWestPoint northEast:northEastPoint animated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No search results." message:@"Try providing a more specific query." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

#pragma mark RMMapViewDelegate methods

- (void)mapView:(RMMapView *)mapView didUpdateUserLocation:(RMUserLocation *)userLocation
{
    self.userLocation = userLocation;
    
    if (needsRouting) {
        //[self performSelector:currentLocationRoutingSelector withObject:currentLocationToOrFromPoint];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[OTPViewController instanceMethodSignatureForSelector:currentLocationRoutingSelector]];
        [invocation setSelector:currentLocationRoutingSelector];
        [invocation setTarget:self];
        [invocation setArgument:&currentLocationToOrFromPoint atIndex:2];
        [invocation performSelector:@selector(invoke)];
        needsRouting = NO;
    }
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
    NSLog(@"Long tap.");
    [self.mapView removeAllAnnotations];
    self.searchBar.text = nil;
    
    RMAnnotation* placeAnnotation = [RMAnnotation
                                     annotationWithMapView:self.mapView
                                     coordinate:[self.mapView pixelToCoordinate:point]
                                     andTitle:@"Dropped Pin"];
    
    RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:nil tintColor:[UIColor blueColor]];
    marker.zPosition = 10;
    
    SMCalloutView *calloutView = [[SMCalloutView alloc] init];
    calloutView.title = @"Dropped Pin";
    
    OTPCallout *callout = [[OTPCallout alloc] initWithCallout:calloutView forMarker:marker inMap:self.mapView];
    
    marker.label = callout;
    
    placeAnnotation.userInfo = [[NSMutableDictionary alloc] init];
    [placeAnnotation.userInfo setObject:marker forKey:@"layer"];
    [self.mapView addAnnotation:placeAnnotation];
    [self tapOnAnnotation:placeAnnotation onMap:self.mapView];
}

- (void)tapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    NSLog(@"Tapped on annotation");
    RMMarker* marker = [[annotation userInfo] objectForKey:@"layer"];
    [((OTPCallout *)marker.label) toggle];
}

#pragma mark segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark UIViewController methods

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
    
	// Do any additional setup after loading the view.
    
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
    
    self.navigationItem.titleView = self.searchBar;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
