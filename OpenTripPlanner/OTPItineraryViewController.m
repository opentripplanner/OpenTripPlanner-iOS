//
//  OTPItineraryViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 9/14/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPItineraryViewController.h"
#import "UIView+Origami.h"
#import "OTPShadow.h"
#import "Leg.h"

@interface OTPItineraryViewController ()

- (void)displayItinerary:(Itinerary*)itinerary;
- (void)displayItineraryOverview:(Itinerary*)itinerary;
- (void)displayLeg:(Leg*)leg;

@end

@implementation OTPItineraryViewController

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
    
    self.paperFoldView = [[PaperFoldView alloc] initWithFrame:CGRectMake(0,0,320,416)];
    [self.paperFoldView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:self.paperFoldView];
    
    //self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,100,[self.view bounds].size.height)];
    //[self.paperFoldView setLeftFoldContentView:self.leftTableView];
    
    self.mapView = [[RMMapView alloc] initWithFrame:CGRectMake(0,0,250,416)];
    self.mapView.delegate = self;
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
    
    //UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0,0,230,416)];
    //aView.backgroundColor = [UIColor yellowColor];
    //[self.paperFoldView setRightFoldContentView:self.mapView rightViewFoldCount:3 rightViewPullFactor:0.9];
    [self.paperFoldView setLeftFoldContentView:self.mapView];
    
    //self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
    [self.paperFoldView setCenterContentView:self.tableView];
    
    //[self.paperFoldView setPaperFoldState:PaperFoldStateRightUnfolded];
    
    OTPShadow *shadow = [[OTPShadow alloc] initWithFrame:CGRectMake(self.mapView.bounds.size.width-20, 0, 20, 416)];
    //shadow.backgroundColor = [UIColor yellowColor];
    [self.mapView addSubview:shadow];
    
    [self displayItinerary:self.itinerary];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.paperFoldView setPaperFoldState:PaperFoldStateLeftUnfolded];
    if (indexPath.row == 0) {
        [self displayItineraryOverview:self.itinerary];
    } else {
        [self displayLeg:[self.itinerary.legs objectAtIndex:indexPath.row - 1]];
    }
}

- (void) displayItinerary: (Itinerary*)itinerary
{
    [self.mapView removeAllAnnotations];
    
    int legCounter = 0;
    for (Leg* leg in itinerary.legs) {
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
        } else if (legCounter == itinerary.legs.count - 1) {
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

- (void)displayItineraryOverview:(Itinerary *)itinerary
{
    [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:itinerary.bounds.swCorner northEast:itinerary.bounds.neCorner animated:YES];
}

- (void)displayLeg:(Leg *)leg
{
    [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:leg.bounds.swCorner northEast:leg.bounds.neCorner animated:YES];
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    return [annotation.userInfo objectForKey:@"layer"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
