//
//  OTPItineraryTableViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 10/1/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPItineraryTableViewController.h"
#import "PPRevealSideViewController.h"
#import "UIView+Origami.h"

@interface OTPItineraryTableViewController ()
{
    BOOL mapShowing;
}
@end

@implementation OTPItineraryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.clipsToBounds = NO;
    self.tableView.layer.masksToBounds = NO;
    self.tableView.layer.shadowColor = CGColorRetain([UIColor blackColor].CGColor);
    self.tableView.layer.shadowOpacity = 0.3;
    self.tableView.layer.shadowRadius = 5;
    self.tableView.layer.shadowOffset = CGSizeMake(-5, 0);
    self.tableView.layer.zPosition = 1000;
    self.mapView.layer.zPosition = 1;
    
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
    
    UISwipeGestureRecognizer *swipeGestureObjectImg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftTableView:)];//yourSlideOpen_Clicked is method name where you doing something
    swipeGestureObjectImg.numberOfTouchesRequired = 1;
    swipeGestureObjectImg.direction = (UISwipeGestureRecognizerDirectionLeft);
    [self.tableView addGestureRecognizer:swipeGestureObjectImg];
    
    UISwipeGestureRecognizer *swipeGestureRightObjectImg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightTableView:)];//yourSlideClose_Clicked is method name where you doing something
    swipeGestureRightObjectImg.numberOfTouchesRequired = 1;
    swipeGestureRightObjectImg.direction = (UISwipeGestureRecognizerDirectionRight);
    [self.tableView addGestureRecognizer:swipeGestureRightObjectImg];
    
    [self displayItinerary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.itinerary.legs.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"OverviewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        cell.backgroundColor = [UIColor blueColor];
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"LegCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        cell.backgroundColor = [UIColor redColor];
        
        return cell;
    }
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (mapShowing) {
        if (indexPath.row == 0) {
            [self displayItineraryOverview];
        } else {
            [self displayLeg:[self.itinerary.legs objectAtIndex:indexPath.row - 1]];
        }
    } else {
        [self.tableView showOrigamiTransitionWith:self.mapView NumberOfFolds:3 Duration:0.3 Direction:XYOrigamiDirectionFromLeft completion:^(BOOL finished) {
            if (indexPath.row == 0) {
                [self displayItineraryOverview];
            } else {
                [self displayLeg:[self.itinerary.legs objectAtIndex:indexPath.row - 1]];
            }
        }];
        mapShowing = YES;
    }
}

- (void) displayItinerary
{
    [self.mapView removeAllAnnotations];
    
    int legCounter = 0;
    for (Leg* leg in self.itinerary.legs) {
        if (legCounter == 0) {
            RMAnnotation* startAnnotation = [RMAnnotation
                                             annotationWithMapView:self.mapView
                                             coordinate:CLLocationCoordinate2DMake(leg.from.lat.floatValue, leg.from.lon.floatValue)
                                             andTitle:leg.from.name];
            RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:nil tintColor:[UIColor greenColor]];
            marker.zPosition = 10;
            startAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [startAnnotation.userInfo setObject:marker forKey:@"layer"];
            [self.mapView addAnnotation:startAnnotation];
        } else if (legCounter == self.itinerary.legs.count - 1) {
            RMAnnotation* endAnnotation = [RMAnnotation
                                           annotationWithMapView:self.mapView
                                           coordinate:CLLocationCoordinate2DMake(leg.to.lat.floatValue, leg.to.lon.floatValue)
                                           andTitle:leg.from.name];
            RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:nil tintColor:[UIColor redColor]];
            marker.zPosition = 10;
            endAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [endAnnotation.userInfo setObject:marker forKey:@"layer"];
            [self.mapView addAnnotation:endAnnotation];
        }
        
        RMShape *polyline = [[RMShape alloc] initWithView:self.mapView];
        polyline.lineColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
        polyline.lineWidth = 6;
        polyline.lineCap = kCALineCapRound;
        polyline.lineJoin = kCALineJoinRound;
        polyline.zPosition = 0;
        
        int counter = 0;
        
        for (CLLocation *loc in leg.decodedLegGeometry) {
            if (counter == 0) {
                [polyline moveToCoordinate:loc.coordinate];
            } else {
                [polyline addLineToCoordinate:loc.coordinate];
            }
            counter++;
        }
        
        RMAnnotation *polylineAnnotation = [[RMAnnotation alloc] init];
        [polylineAnnotation setMapView:self.mapView];
        polylineAnnotation.coordinate = ((CLLocation*)[leg.decodedLegGeometry objectAtIndex:0]).coordinate;
        [polylineAnnotation setBoundingBoxFromLocations:leg.decodedLegGeometry];
        polylineAnnotation.userInfo = [[NSMutableDictionary alloc] init];
        [polylineAnnotation.userInfo setObject:polyline forKey:@"layer"];
        [self.mapView addAnnotation:polylineAnnotation];
        
        legCounter++;
    }
}

- (void)displayItineraryOverview
{
    [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:self.itinerary.bounds.swCorner northEast:self.itinerary.bounds.neCorner animated:YES];
}

- (void)displayLeg:(Leg *)leg
{
    [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:leg.bounds.swCorner northEast:leg.bounds.neCorner animated:YES];
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    return [annotation.userInfo objectForKey:@"layer"];
}

- (void)swipeLeftTableView:(id)sender
{
    [self.tableView hideOrigamiTransitionWith:self.mapView NumberOfFolds:3 Duration:0.3 Direction:XYOrigamiDirectionFromLeft completion:^(BOOL finished) {
        
    }];
    mapShowing = NO;
}

- (void)swipeRightTableView:(id)sender
{
    [self.tableView showOrigamiTransitionWith:self.mapView NumberOfFolds:3 Duration:0.3 Direction:XYOrigamiDirectionFromLeft completion:^(BOOL finished) {
        
    }];
    mapShowing = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tableView hideOrigamiTransitionWith:self.mapView NumberOfFolds:3 Duration:0.0 Direction:XYOrigamiDirectionFromLeft completion:^(BOOL finished) {
            
    }];
    mapShowing = NO;
}

@end
