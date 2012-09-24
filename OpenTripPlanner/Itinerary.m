//
//  Itinerary.m
//  Open Trip Planner
//
//  Created by asutula on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "Itinerary.h"

@implementation Itinerary

@synthesize duration = _duration;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize walkTime = _walkTime;
@synthesize transitTime = _transitTime;
@synthesize waitingTime = _waitingTime;
@synthesize walkDistance = _walkDistance;
@synthesize elevationLost = _elevationLost;
@synthesize elevationGained = _elevationGained;
@synthesize transfers = _transfers;
@synthesize legs = _legs;
@synthesize bounds = _bounds;

- (void)setLegs:(NSArray *)legs
{
    _legs = legs;
    
    CLLocationCoordinate2D northEastPoint;
    CLLocationCoordinate2D southWestPoint;
    
    int legCounter = 0;
    for (Leg* leg in _legs) {
        if (legCounter == 0) {
            northEastPoint = leg.bounds.neCorner;
            southWestPoint = leg.bounds.swCorner;
        } else {
            if (leg.bounds.neCorner.longitude > northEastPoint.longitude)
                northEastPoint.longitude = leg.bounds.neCorner.longitude;
            if(leg.bounds.neCorner.latitude > northEastPoint.latitude)
                northEastPoint.latitude = leg.bounds.neCorner.latitude;
            if (leg.bounds.swCorner.longitude < southWestPoint.longitude)
                southWestPoint.longitude = leg.bounds.swCorner.longitude;
            if (leg.bounds.swCorner.latitude < southWestPoint.latitude)
                southWestPoint.latitude = leg.bounds.swCorner.latitude;
        }
        legCounter++;
    }
    
    _bounds.swCorner = southWestPoint;
    _bounds.neCorner = northEastPoint;
}

@end
