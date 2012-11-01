//
//  OTPItineraryTableViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 10/1/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPItineraryTableViewController.h"
#import "OTPStopBasedLegCell.h"
#import "OTPDistanceBasedLegCell.h"
#import "OTPItineraryOverviewCell.h"
#import "OTPStepCell.h"
#import "OTPTransferCell.h"
#import "PPRevealSideViewController.h"
#import "UIView+Origami.h"
#import "OTPUnitData.h"
#import "OTPUnitFormatter.h"
#import "OTPSelectedSegment.h"

@interface OTPItineraryTableViewController ()
{
    BOOL mapShowing;
    NSArray *_distanceBasedModes;
    NSArray *_stopBasedModes;
    NSArray *_transferModes;
    NSDictionary *_modeDisplayStrings;
    NSDictionary *_relativeDirectionDisplayStrings;
    NSDictionary *_relativeDirectionIcons;
    NSDictionary *_absoluteDirectionDisplayStrings;
    NSDictionary *_modeIcons;
    NSMutableArray *_shapesForLegs;
    NSDictionary *_popuprModeIcons;
    NSIndexPath *_selectedIndexPath;
}

- (void)resetLegsWithColor:(UIColor *)color;
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
    
    // WALK, BICYCLE, CAR, TRAM, SUBWAY, RAIL, BUS, FERRY, CABLE_CAR, GONDOLA, FUNICULAR, TRANSFER
    
    _distanceBasedModes = @[@"WALK", @"BICYCLE", @"CAR"];
    _stopBasedModes = @[@"TRAM", @"SUBWAY", @"RAIL", @"BUS", @"FERRY", @"CABLE_CAR", @"GONDOLA", @"FUNICULAR"];
    _transferModes = @[@"TRANSFER"];
    
    _modeIcons = @{
    @"WALK" : [UIImage imageNamed:@"walk_52.png"],
    @"BICYCLE" : [UIImage imageNamed:@"bike_52.png"],
    @"CAR" : [UIImage imageNamed:@"car_52.png"],
    @"TRAM" : [UIImage imageNamed:@"gondola_52.png"],
    @"SUBWAY" : [UIImage imageNamed:@"train_52.png"],
    @"RAIL" : [UIImage imageNamed:@"train_52.png"],
    @"BUS" : [UIImage imageNamed:@"bus_52.png"],
    @"FERRY" : [UIImage imageNamed:@"ferry_52.png"],
    @"CABLE_CAR" : [UIImage imageNamed:@"cable-car_52.png"],
    @"GONDOLA" : [UIImage imageNamed:@"gondola_52.png"],
    @"TRANSFER" : [UIImage imageNamed:@"transfer_52.png"],
    @"FUNICULAR" : [UIImage imageNamed:@"funicular_52.png"]
    };
    
    _modeDisplayStrings = @{
    @"WALK" : @"Walk",
    @"BICYCLE" : @"Bike",
    @"CAR" : @"Drive",
    @"TRAM" : @"Tram",
    @"SUBWAY" : @"Subway",
    @"RAIL" : @"Train",
    @"BUS" : @"Bus",
    @"FERRY" : @"Ferry",
    @"CABLE_CAR" : @"Cable car",
    @"GONDOLA" : @"Gondola",
    @"FUNICULAR" : @"Funicular",
    @"TRANSFER" : @"Transfer"
    };
    
    _relativeDirectionIcons = @{
    @"HARD_LEFT" : [UIImage imageNamed:@"hard-left_52.png"],
    @"LEFT" : [UIImage imageNamed:@"hard-left_52.png"],
    @"SLIGHTLY_LEFT" : [UIImage imageNamed:@"slight-left_52.png"],
    @"CONTINUE" : [UIImage imageNamed:@"continue_52.png"],
    @"SLIGHTLY_RIGHT" : [UIImage imageNamed:@"slight-right_52.png"],
    @"RIGHT" : [UIImage imageNamed:@"hard-right_52.png"],
    @"HARD_RIGHT" : [UIImage imageNamed:@"hard-right_52.png"],
    @"CIRCLE_CLOCKWISE" : [UIImage imageNamed:@"clockwise_52.png"],
    @"CIRCLE_COUNTERCLOCKWISE" : [UIImage imageNamed:@"counterclockwise_52.png"],
    @"ELEVATOR" : [UIImage imageNamed:@"elevator_52.png"]
    };
    
    _relativeDirectionDisplayStrings = @{
    @"HARD_LEFT" : @"Hard left",
    @"LEFT" : @"Left",
    @"SLIGHTLY_LEFT" : @"Slight left",
    @"CONTINUE" : @"Continue",
    @"SLIGHTLY_RIGHT" : @"Slight right",
    @"RIGHT" : @"Right",
    @"HARD_RIGHT" : @"Hard right",
    @"CIRCLE_CLOCKWISE" : @"Circle clockwise",
    @"CIRCLE_COUNTERCLOCKWISE" : @"Circle counterclockwise",
    @"ELEVATOR" : @"Elevator"
    };
    
    _absoluteDirectionDisplayStrings = @{
    @"NORTH" : @"north",
    @"NORTHEAST" : @"northeast",
    @"EAST" : @"east",
    @"SOUTHEAST" : @"southeast",
    @"SOUTH" : @"south",
    @"SOUTHWEST" : @"southwest",
    @"WEST" : @"west",
    @"NORTHWEST" : @"northwest"
    };
    
    _popuprModeIcons = @{
    @"WALK" : [UIImage imageNamed:@"popup-walk.png"],
    @"BICYCLE" : [UIImage imageNamed:@"popup-bike.png"],
    @"CAR" : [UIImage imageNamed:@"popup-car.png"],
    @"TRAM" : [UIImage imageNamed:@"popup-gondola.png"],
    @"SUBWAY" : [UIImage imageNamed:@"popup-train.png"],
    @"RAIL" : [UIImage imageNamed:@"popup-train.png"],
    @"BUS" : [UIImage imageNamed:@"popup-bus.png"],
    @"FERRY" : [UIImage imageNamed:@"popup-ferry.png"],
    @"CABLE_CAR" : [UIImage imageNamed:@"popup-cable-car.png"],
    @"GONDOLA" : [UIImage imageNamed:@"popup-gondola.png"],
    @"TRANSFER" : [UIImage imageNamed:@"popup-transfer.png"],
    @"FUNICULAR" : [UIImage imageNamed:@"popup-funicular.png"]
    };

    
    _shapesForLegs = [[NSMutableArray alloc] init];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.itineraryMapViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"ItineraryMapViewController"];
    [self.revealSideViewController preloadViewController:self.itineraryMapViewController forSide:PPRevealSideDirectionLeft];
    [self.itineraryMapViewController.mapView setDelegate:self];
    self.itineraryMapViewController.mapView.topPadding = 100;
    self.itineraryMapViewController.instructionLabel.hidden = YES;
    
    [self displayItinerary];
    [self displayItineraryOverview];
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
    // If we have a single leg with steps, it's a walk, bike, or drive itinierary
    if (self.itinerary.legs.count == 1 && ((Leg *)[self.itinerary.legs objectAtIndex:0]).steps.count > 0) {
        return ((Leg *)[self.itinerary.legs objectAtIndex:0]).steps.count + 1;
    }
    return self.itinerary.legs.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"h:mm a";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"OverviewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        ((OTPItineraryOverviewCell *)cell).fromLabel.text = self.fromTextField.text;
        ((OTPItineraryOverviewCell *)cell).toLabel.text = self.toTextField.text;
        
        // Set start and end times
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        ((OTPItineraryOverviewCell *)cell).departTime.text = [formatter stringFromDate:self.itinerary.startTime];
        ((OTPItineraryOverviewCell *)cell).arriveTime.text = [formatter stringFromDate:self.itinerary.endTime];
        
    } else {
        
        if (self.itinerary.legs.count == 1 && ((Leg *)[self.itinerary.legs objectAtIndex:0]).steps.count > 0) {
            Leg *leg = [self.itinerary.legs objectAtIndex:0];
            Step *step = [leg.steps objectAtIndex:indexPath.row-1];
            cell = [tableView dequeueReusableCellWithIdentifier:@"StepCell"];
            NSString *instruction;
            if (indexPath.row == 1) {
                instruction = [NSString stringWithFormat:@"%@ %@ on %@",
                               [_modeDisplayStrings objectForKey:leg.mode],
                               [_absoluteDirectionDisplayStrings objectForKey:step.absoluteDirection],
                               step.streetName];
                ((OTPStepCell *)cell).iconView.image = [_modeIcons objectForKey:leg.mode];
            } else {
                instruction = [NSString stringWithFormat:@"%@ on %@",
                               [_relativeDirectionDisplayStrings objectForKey:step.relativeDirection],
                               step.streetName];
                ((OTPStepCell *)cell).iconView.image = [_relativeDirectionIcons objectForKey:step.relativeDirection];
            }
            ((OTPStepCell *)cell).instructionLabel.text = instruction;
        } else {
            Leg *leg = [self.itinerary.legs objectAtIndex:indexPath.row-1];
            
            if ([_distanceBasedModes containsObject:leg.mode]) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"DistanceBasedLegCell"];
                
                ((OTPDistanceBasedLegCell *)cell).iconView.image = [_modeIcons objectForKey:leg.mode];
                
                ((OTPDistanceBasedLegCell *)cell).instructionLabel.text = [NSString stringWithFormat:@"%@ to %@", [_modeDisplayStrings objectForKey:leg.mode], leg.to.name.capitalizedString];
                
                NSNumber *duration = [NSNumber numberWithFloat:roundf(leg.duration.floatValue/1000/60)];
                NSString *unitLabel = duration.intValue == 1 ? @"minute" : @"minutes";
                ((OTPDistanceBasedLegCell *)cell).timeLabel.text = [NSString stringWithFormat:@"%i %@", duration.intValue, unitLabel];
                
                OTPUnitFormatter *unitFormatter = [[OTPUnitFormatter alloc] init];
                unitFormatter.cutoffMultiplier = @3.28084F;
                unitFormatter.unitData = @[
                [OTPUnitData unitDataWithCutoff:@100 multiplier:@3.28084F roundingIncrement:@10 singularLabel:@"foot" pluralLabel:@"feet"],
                [OTPUnitData unitDataWithCutoff:@528 multiplier:@3.28084F roundingIncrement:@100 singularLabel:@"foot" pluralLabel:@"feet"],
                [OTPUnitData unitDataWithCutoff:@INT_MAX multiplier:@0.000621371F roundingIncrement:@0.1F singularLabel:@"mile" pluralLabel:@"miles"]
                ];
                
                ((OTPDistanceBasedLegCell *)cell).distanceLabel.text = [unitFormatter numberToString:leg.distance];
            } else if ([_stopBasedModes containsObject:leg.mode]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"StopBasedLegCell"];
                
                ((OTPStopBasedLegCell *)cell).iconView.image = [_modeIcons objectForKey:leg.mode];
                
                ((OTPStopBasedLegCell *)cell).iconLabel.text = leg.route.capitalizedString;
                ((OTPStopBasedLegCell *)cell).instructionLabel.text = [NSString stringWithFormat: @"%@ twds %@", [_modeDisplayStrings objectForKey:leg.mode] , leg.headsign.capitalizedString];
                ((OTPStopBasedLegCell *)cell).departureTimeLabel.text = [NSString stringWithFormat:@"Departs %@", [dateFormatter stringFromDate:leg.startTime]];
                
                int intermediateStops = leg.intermediateStops.count + 1;
                NSString *stopUnitLabel = intermediateStops == 1 ? @"stop" : @"stops";
                ((OTPStopBasedLegCell *)cell).stopsLabel.text = [NSString stringWithFormat:@"%u %@", intermediateStops, stopUnitLabel];
                
                ((OTPStopBasedLegCell *)cell).toLabel.text = [NSString stringWithFormat:@"Get off at %@ stop", leg.to.name.capitalizedString];
            } else if ([_transferModes containsObject:leg.mode]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"TransfereBasedLegCell"];
                ((OTPTransferCell *)cell).iconView.image = [_modeIcons objectForKey:leg.mode];
                Leg *nextLeg = [self.itinerary.legs objectAtIndex:indexPath.row];
                ((OTPTransferCell *)cell).instructionLabel.text = [NSString stringWithFormat:@"Transfer to the %@", nextLeg.route.capitalizedString];
            }
        }
    }
    OTPSelectedSegment *selectedView = [[OTPSelectedSegment alloc] init];
    cell.selectedBackgroundView = selectedView;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    
    if (self.itinerary.legs.count == 1 && ((Leg *)[self.itinerary.legs objectAtIndex:0]).steps.count > 0) {
        return 60;
    }
    
    Leg *leg = [self.itinerary.legs objectAtIndex:indexPath.row - 1];
    
    if ([_distanceBasedModes containsObject:leg.mode]) {
        return 60;
    } else if ([_stopBasedModes containsObject:leg.mode]) {
        return 80;
    } else if ([_transferModes containsObject:leg.mode]) {
        return 40;
    }
    return 44;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    
    if (!mapShowing) {
        [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft withOffset:60 animated:YES];
    }
    
    if (indexPath.row == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.itineraryMapViewController.instructionLabel.center = CGPointMake(self.itineraryMapViewController.instructionLabel.center.x, self.itineraryMapViewController.instructionLabel.center.y - self.itineraryMapViewController.instructionLabel.bounds.size.height);
        } completion:^(BOOL finished) {
            self.itineraryMapViewController.instructionLabel.hidden = YES;
        }];
        self.itineraryMapViewController.mapView.topPadding = 0;
        [self resetLegsWithColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.5]];
        [self displayItineraryOverview];
    } else if (self.itinerary.legs.count == 1 && ((Leg *)[self.itinerary.legs objectAtIndex:0]).steps.count > 0) {
        Leg *leg = [self.itinerary.legs objectAtIndex:0];
        Step *step = [leg.steps objectAtIndex:indexPath.row-1];
        
        NSString *instruction;
        if (indexPath.row == 1) {
            instruction = [NSString stringWithFormat:@"%@ %@ on %@.",
                           [_modeDisplayStrings objectForKey:leg.mode],
                           [_absoluteDirectionDisplayStrings objectForKey:step.absoluteDirection],
                           step.streetName];
        } else {
            instruction = [NSString stringWithFormat:@"%@ on %@.",
                           [_relativeDirectionDisplayStrings objectForKey:step.relativeDirection],
                           step.streetName];
        }
        self.itineraryMapViewController.instructionLabel.text = instruction;
        
        // TODO: Fix duplicate code.
        [self.itineraryMapViewController.instructionLabel resizeHeightToFitText];
        if (self.itineraryMapViewController.instructionLabel.isHidden) {
            self.itineraryMapViewController.instructionLabel.center = CGPointMake(self.itineraryMapViewController.instructionLabel.center.x, self.itineraryMapViewController.instructionLabel.center.y - self.itineraryMapViewController.instructionLabel.bounds.size.height);
            self.itineraryMapViewController.instructionLabel.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.itineraryMapViewController.instructionLabel.center = CGPointMake(self.itineraryMapViewController.instructionLabel.center.x, self.itineraryMapViewController.instructionLabel.center.y + self.itineraryMapViewController.instructionLabel.bounds.size.height);
            }];
        }
        
        self.itineraryMapViewController.mapView.topPadding = self.itineraryMapViewController.instructionLabel.bounds.size.height;
        
        [self.itineraryMapViewController.mapView setZoom:16];
        [self.itineraryMapViewController.mapView setCenterCoordinate:CLLocationCoordinate2DMake(step.lat.doubleValue, step.lon.doubleValue) animated:YES];
    } else {
        [self resetLegsWithColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5]];
        RMShape *shape = [_shapesForLegs objectAtIndex:indexPath.row - 1];
        shape.lineColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
        
        Leg *leg = [self.itinerary.legs objectAtIndex:indexPath.row - 1];
        
        if ([_distanceBasedModes containsObject:leg.mode]) {
            self.itineraryMapViewController.instructionLabel.text = [NSString stringWithFormat:@"%@ to %@.", [_modeDisplayStrings objectForKey:leg.mode], leg.to.name.capitalizedString];
        } else if ([_stopBasedModes containsObject:leg.mode]) {
            self.itineraryMapViewController.instructionLabel.text = [NSString stringWithFormat: @"Take the %@ %@ towards %@ and get off at %@.", leg.route.capitalizedString, ((NSString*)[_modeDisplayStrings objectForKey:leg.mode]).lowercaseString, leg.headsign.capitalizedString, leg.to.name.capitalizedString];
        } else if ([_transferModes containsObject:leg.mode]) {
            Leg *nextLeg = [self.itinerary.legs objectAtIndex:indexPath.row];
            self.itineraryMapViewController.instructionLabel.text = [NSString stringWithFormat:@"Transfer to the %@ %@.", nextLeg.route.capitalizedString, [_modeDisplayStrings objectForKey:nextLeg.mode]];
        }
        
        [self.itineraryMapViewController.instructionLabel resizeHeightToFitText];
        if (self.itineraryMapViewController.instructionLabel.isHidden) {
            self.itineraryMapViewController.instructionLabel.center = CGPointMake(self.itineraryMapViewController.instructionLabel.center.x, self.itineraryMapViewController.instructionLabel.center.y - self.itineraryMapViewController.instructionLabel.bounds.size.height);
            self.itineraryMapViewController.instructionLabel.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.itineraryMapViewController.instructionLabel.center = CGPointMake(self.itineraryMapViewController.instructionLabel.center.x, self.itineraryMapViewController.instructionLabel.center.y + self.itineraryMapViewController.instructionLabel.bounds.size.height);
            }];
        }
        
        self.itineraryMapViewController.mapView.topPadding = self.itineraryMapViewController.instructionLabel.bounds.size.height;
        
        [self displayLeg:leg];
    }
}

- (void)pprevealSideViewController:(PPRevealSideViewController *)controller didPushController:(UIViewController *)pushedController
{
    mapShowing = YES;
    if (_selectedIndexPath == nil) {
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    [self.tableView selectRowAtIndexPath:_selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)pprevealSideViewController:(PPRevealSideViewController *)controller didPopToController:(UIViewController *)centerController
{
    mapShowing = NO;
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (BOOL)pprevealSideViewController:(PPRevealSideViewController *)controller shouldDeactivateGesture:(UIGestureRecognizer *)gesture forView:(UIView *)view
{
    CGPoint velocity = [(UIPanGestureRecognizer *)gesture velocityInView:view];
    if (fabsf(velocity.y) > fabsf(velocity.x) || (mapShowing == YES && fabsf(velocity.x) > fabsf(velocity.y) && velocity.x > 0)) {
        return YES;
    }
    return NO;
}

- (void) displayItinerary
{
    [self.itineraryMapViewController.mapView removeAllAnnotations];
    
    int legCounter = 0;
    for (Leg* leg in self.itinerary.legs) {
        if (legCounter == 0) {
            // start marker:
            RMAnnotation* startAnnotation = [RMAnnotation
                                             annotationWithMapView:self.itineraryMapViewController.mapView
                                             coordinate:CLLocationCoordinate2DMake(leg.from.lat.floatValue, leg.from.lon.floatValue)
                                             andTitle:nil];
            RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"marker-start.png"]];
            startAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [startAnnotation.userInfo setObject:marker forKey:@"layer"];
            [self.itineraryMapViewController.mapView addAnnotation:startAnnotation];
            
        } else if (legCounter == self.itinerary.legs.count - 1) {
            // map mode popup for last leg:
            RMAnnotation* modeAnnotation = [RMAnnotation
                                            annotationWithMapView:self.itineraryMapViewController.mapView
                                            coordinate:CLLocationCoordinate2DMake(leg.from.lat.floatValue, leg.from.lon.floatValue)
                                            andTitle:leg.mode];
            RMMarker *popupMarker = [[RMMarker alloc] initWithUIImage:[_popuprModeIcons objectForKey:leg.mode]];
            modeAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [modeAnnotation.userInfo setObject:popupMarker forKey:@"layer"];
            [self.itineraryMapViewController.mapView addAnnotation:modeAnnotation];
            
            // end marker:
            RMAnnotation* endAnnotation = [RMAnnotation
                                           annotationWithMapView:self.itineraryMapViewController.mapView
                                           coordinate:CLLocationCoordinate2DMake(leg.to.lat.floatValue, leg.to.lon.floatValue)
                                           andTitle:leg.from.name];
            RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"marker-end.png"]];
            endAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [endAnnotation.userInfo setObject:marker forKey:@"layer"];
            [self.itineraryMapViewController.mapView addAnnotation:endAnnotation];
            
        } else {
            // map mode popup:            
            RMAnnotation* modeAnnotation = [RMAnnotation
                                                annotationWithMapView:self.itineraryMapViewController.mapView
                                                coordinate:CLLocationCoordinate2DMake(leg.from.lat.floatValue, leg.from.lon.floatValue)
                                                andTitle:leg.mode];
                    
            RMMarker *popupMarker = [[RMMarker alloc] initWithUIImage:[_popuprModeIcons objectForKey:leg.mode]];
            modeAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [modeAnnotation.userInfo setObject:popupMarker forKey:@"layer"];
            [self.itineraryMapViewController.mapView addAnnotation:modeAnnotation];
        }
        
        
        RMShape *polyline = [[RMShape alloc] initWithView:self.itineraryMapViewController.mapView];
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
        
        [_shapesForLegs addObject:polyline];
        
        RMAnnotation *polylineAnnotation = [[RMAnnotation alloc] init];
        [polylineAnnotation setMapView:self.itineraryMapViewController.mapView];
        polylineAnnotation.coordinate = ((CLLocation*)[leg.decodedLegGeometry objectAtIndex:0]).coordinate;
        [polylineAnnotation setBoundingBoxFromLocations:leg.decodedLegGeometry];
        polylineAnnotation.userInfo = [[NSMutableDictionary alloc] init];
        [polylineAnnotation.userInfo setObject:polyline forKey:@"layer"];
        [self.itineraryMapViewController.mapView addAnnotation:polylineAnnotation];
        
        
//        RMShape *bbox = [[RMShape alloc] initWithView:self.itineraryMapViewController.mapView];
//        bbox.lineColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//        bbox.lineWidth = 2;
//        bbox.lineCap = kCALineCapRound;
//        bbox.lineJoin = kCALineJoinRound;
//        bbox.zPosition = 0;
//        
//        [bbox moveToCoordinate:leg.bounds.swCorner];
//        [bbox addLineToCoordinate:CLLocationCoordinate2DMake(leg.bounds.swCorner.latitude, leg.bounds.neCorner.longitude)];
//        [bbox addLineToCoordinate:leg.bounds.neCorner];
//        [bbox addLineToCoordinate:CLLocationCoordinate2DMake(leg.bounds.neCorner.latitude, leg.bounds.swCorner.longitude)];
//        [bbox closePath];
//        
//        RMAnnotation *bboxAnnotation = [[RMAnnotation alloc] init];
//        [bboxAnnotation setMapView:self.itineraryMapViewController.mapView];
//        bboxAnnotation.coordinate = leg.bounds.swCorner;
//        [bboxAnnotation setBoundingBoxFromLocations:leg.decodedLegGeometry];
//        bboxAnnotation.userInfo = [[NSMutableDictionary alloc] init];
//        [bboxAnnotation.userInfo setObject:bbox forKey:@"layer"];
//        [self.itineraryMapViewController.mapView addAnnotation:bboxAnnotation];
        
        legCounter++;
    }
}

- (void)displayItineraryOverview
{
    [self.itineraryMapViewController.mapView zoomWithLatitudeLongitudeBoundsSouthWest:self.itinerary.bounds.swCorner northEast:self.itinerary.bounds.neCorner animated:YES];
}

- (void)displayLeg:(Leg *)leg
{
    [self.itineraryMapViewController.mapView zoomWithLatitudeLongitudeBoundsSouthWest:leg.bounds.swCorner northEast:leg.bounds.neCorner animated:YES];
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    return [annotation.userInfo objectForKey:@"layer"];
}

- (void)resetLegsWithColor:(UIColor *)color
{
    for (RMShape *shape in _shapesForLegs) {
        shape.lineColor = color;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    mapShowing = NO;
}

@end
