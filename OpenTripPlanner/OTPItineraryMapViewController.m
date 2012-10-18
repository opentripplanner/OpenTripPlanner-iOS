//
//  OTPItineraryMapViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 10/1/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

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
