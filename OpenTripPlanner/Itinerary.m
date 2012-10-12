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

- (void)setEpochStartTime:(NSNumber *)epochStartTime
{
    _epochStartTime = epochStartTime;
    self.startTime = [NSDate dateWithTimeIntervalSince1970:epochStartTime.floatValue/1000];
}

- (void)setEpochEndTime:(NSNumber *)epochEndTime
{
    _epochEndTime = epochEndTime;
    self.endTime = [NSDate dateWithTimeIntervalSince1970:epochEndTime.floatValue/1000];
}

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
