//
//  OTPItineraryMapViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 10/1/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OTPItineraryMapViewController.h"

@interface OTPItineraryMapViewController ()

@end

@implementation OTPItineraryMapViewController

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
    
    self.instructionLabel.clipsToBounds = NO;
    self.instructionLabel.layer.cornerRadius = 5;
    self.instructionLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.instructionLabel.layer.shadowOpacity = 0.5;
    self.instructionLabel.layer.shadowRadius = 5.0;
    self.instructionLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    
    self.instructionLabel.insets = UIEdgeInsetsMake(7, 10, 7, 10);
}

- (void)panToUserLocation:(id)sender
{
    self.needsPanToUserLocation = YES;
    [self enableUserLocation];
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
    
    // Show user location on the map
    if (self.needsPanToUserLocation) {
        CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(self.userLocation.location.coordinate.latitude - 0.0085, self.userLocation.location.coordinate.longitude - 0.005);
        CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(self.userLocation.location.coordinate.latitude + 0.0085, self.userLocation.location.coordinate.longitude + 0.005);
        [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:YES];
        self.needsPanToUserLocation = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
