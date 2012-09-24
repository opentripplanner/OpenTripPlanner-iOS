//
//  Leg.h
//  Open Trip Planner
//
//  Created by asutula on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Place.h"
#import "LegGeometry.h"

struct OTPBounds {
    CLLocationCoordinate2D swCorner;
    CLLocationCoordinate2D neCorner;
};

@interface Leg : NSObject {
    NSDate* _startTime;
    NSDate* _endTime;
    NSNumber* _distance;
    Place* _from;
    Place* _to;
    LegGeometry* _legGeometry;
    NSNumber* _duration;
    NSArray *_decodedLegGeometry;
    struct OTPBounds _bounds;
}

@property (nonatomic, retain) NSDate* startTime;
@property (nonatomic, retain) NSDate* endTime;
@property (nonatomic, retain) NSNumber* distance;
@property (nonatomic, retain) Place* from;
@property (nonatomic, retain) Place* to;
@property (nonatomic, retain) LegGeometry* legGeometry;
@property (nonatomic, retain) NSNumber* duration;
@property (nonatomic, readonly) NSArray *decodedLegGeometry;
@property (nonatomic, readonly) struct OTPBounds bounds;

@end
