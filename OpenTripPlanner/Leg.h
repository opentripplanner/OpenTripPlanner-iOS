//
//  Leg.h
//  Open Trip Planner
//
//  Created by asutula on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "Place.h"
#import "LegGeometry.h"

struct OTPBounds {
    CLLocationCoordinate2D swCorner;
    CLLocationCoordinate2D neCorner;
};

@interface Leg : NSObject

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) Place *from;
@property (nonatomic, strong) Place *to;
@property (nonatomic, strong) NSArray *steps;
@property (nonatomic, strong) LegGeometry *legGeometry;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, readonly) NSArray *decodedLegGeometry;
@property (nonatomic, readonly) struct OTPBounds bounds;

@end
