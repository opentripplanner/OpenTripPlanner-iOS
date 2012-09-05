//
//  OTPViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 8/30/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPViewController.h"
#import "Plan.h"

@interface OTPViewController ()

- (void)displayItinerary:(Itinerary*)itinerary;
- (void)showUserLocation;
- (NSMutableArray *)decodePolyLine:(NSString *)encodedStr;

@end

@implementation OTPViewController

@synthesize mapView = _mapView;
@synthesize currentItinerary = _currentItinerary;
@synthesize currentLeg = _currentLeg;
@synthesize userLocation = _userLocation;

CLLocationCoordinate2D currentLocationToOrFromPoint;
SEL currentLocationRoutingSelector;
BOOL needsRouting = NO;

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

- (void)planTripFromCurrentLocationTo:(CLLocationCoordinate2D)endPoint
{
    if (self.userLocation == nil) {
        needsRouting = YES;
        currentLocationRoutingSelector = @selector(planTripFromCurrentLocationTo:);
        currentLocationToOrFromPoint = endPoint;
        [self showUserLocation];
    } else {
        [self planTripFrom:self.userLocation.coordinate to:endPoint];
    }
}

- (void)planTripToCurrentLocationFrom:(CLLocationCoordinate2D)startPoint
{
    if (self.userLocation == nil) {
        needsRouting = YES;
        currentLocationRoutingSelector = @selector(planTripToCurrentLocationFrom:);
        currentLocationToOrFromPoint = startPoint;
        [self showUserLocation];
    } else {
        [self planTripFrom:startPoint to:self.userLocation.coordinate];
    }
}

- (void)showUserLocation
{
    self.mapView.userTrackingMode = RMUserTrackingModeFollowWithHeading;
    self.mapView.showsUserLocation = YES;
}

- (void) displayItinerary: (Itinerary*)itinerary
{
    [self.mapView removeAllAnnotations];
    
    CLLocationCoordinate2D northEastPoint;
    CLLocationCoordinate2D southWestPoint;
    
    int legCounter = 0;
    for (Leg* leg in itinerary.legs) {
        if (legCounter == 0) {
            RMAnnotation* startAnnotation = [RMAnnotation
                                             annotationWithMapView:self.mapView
                                             coordinate:CLLocationCoordinate2DMake(leg.from.lat.floatValue, leg.from.lon.floatValue)
                                             andTitle:leg.from.name];
            RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:nil tintColor:[UIColor greenColor]];
            startAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [startAnnotation.userInfo setObject:marker forKey:@"layer"];
            [self.mapView addAnnotation:startAnnotation];
        } else if (legCounter == itinerary.legs.count - 1) {
            RMAnnotation* endAnnotation = [RMAnnotation
                                             annotationWithMapView:self.mapView
                                             coordinate:CLLocationCoordinate2DMake(leg.from.lat.floatValue, leg.from.lon.floatValue)
                                             andTitle:leg.from.name];
            RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:nil tintColor:[UIColor redColor]];
            endAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [endAnnotation.userInfo setObject:marker forKey:@"layer"];
            [self.mapView addAnnotation:endAnnotation];
        }
        
        NSMutableArray* decodedPoints = [self decodePolyLine:leg.legGeometry.points];
        
        RMShape *polyline = [[RMShape alloc] initWithView:self.mapView];
        polyline.lineColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
        polyline.lineWidth = 6;
        polyline.lineCap = kCALineCapRound;
        polyline.lineJoin = kCALineJoinRound;
        
        int counter = 0;
        
        for (CLLocation *loc in decodedPoints) {
            if (counter == 0) {
                [polyline moveToCoordinate:loc.coordinate];
            } else {
                [polyline addLineToCoordinate:loc.coordinate];
            }
            
            CLLocationCoordinate2D point = loc.coordinate;
            
            if (legCounter == 0) {
                northEastPoint = point;
                southWestPoint = point;
            } else {
                if (point.longitude > northEastPoint.longitude)
                    northEastPoint.longitude = point.longitude;
                if(point.latitude > northEastPoint.latitude)
                    northEastPoint.latitude = point.latitude;
                if (point.longitude < southWestPoint.longitude)
                    southWestPoint.longitude = point.longitude;
                if (point.latitude < southWestPoint.latitude)
                    southWestPoint.latitude = point.latitude;
            }
            counter++;
        }
        
        RMAnnotation *polylineAnnotation = [[RMAnnotation alloc] init];
        [polylineAnnotation setMapView:self.mapView];
        polylineAnnotation.coordinate = ((CLLocation*)[decodedPoints objectAtIndex:0]).coordinate;
        [polylineAnnotation setBoundingBoxFromLocations:decodedPoints];
        polylineAnnotation.userInfo = [[NSMutableDictionary alloc] init];
        [polylineAnnotation.userInfo setObject:polyline forKey:@"layer"];
        [self.mapView addAnnotation:polylineAnnotation];
        
        legCounter++;
    }
    
    [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:southWestPoint northEast:northEastPoint animated:YES];
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

// http://code.google.com/apis/maps/documentation/utilities/polylinealgorithm.html
-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr
{
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    [encoded appendString:encodedStr];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        //          printf("[%f,", [latitude doubleValue]);
        //          printf("%f]", [longitude doubleValue]);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:loc];
    }
    return array;
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    NSLog(@"Loaded plan: %@", objects);
    Plan* plan = (Plan*)[objects objectAtIndex:0];
    [self displayItinerary:[plan.itineraries objectAtIndex:0]];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
}

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
    
//    NSDictionary* params = [NSDictionary dictionaryWithKeysAndObjects:
//                            @"optimize", @"QUICK",
//                            @"time", @"11:41 am",
//                            @"arriveBy", @"false",
//                            @"routerId", @"req-91",
//                            @"maxWalkDistance", @"840",
//                            @"fromPlace", @"40.731007,-73.957879",
//                            @"toPlace", @"40.719591,-73.999614",
//                            @"date", @"2012-07-13",
//                            @"mode", @"TRANSIT,WALK",
//                            nil];
//    
//    NSString* resourcePath = [@"/plan" stringByAppendingQueryParameters: params];
//    
//    RKObjectManager* objectManager = [RKObjectManager sharedManager];
//    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
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
