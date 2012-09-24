//
//  Itinerary.h
//  Open Trip Planner
//
//  Created by asutula on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Leg.h"

@interface Itinerary : NSObject {
    NSNumber* _duration;
    NSDate* _startTime;
    NSDate* _endTime;
    NSNumber* _walkTime;
    NSNumber* _transitTime;
    NSNumber* _waitingTime;
    NSNumber* _walkDistance;
    NSNumber* _elevationLost;
    NSNumber* _elevationGained;
    NSNumber* _transfers;
    NSArray* _legs;
    struct OTPBounds _bounds;
}

@property (nonatomic, retain) NSNumber* duration;
@property (nonatomic, retain) NSDate* startTime;
@property (nonatomic, retain) NSDate* endTime;
@property (nonatomic, retain) NSNumber* walkTime;
@property (nonatomic, retain) NSNumber* transitTime;
@property (nonatomic, retain) NSNumber* waitingTime;
@property (nonatomic, retain) NSNumber* walkDistance;
@property (nonatomic, retain) NSNumber* elevationLost;
@property (nonatomic, retain) NSNumber* elevationGained;
@property (nonatomic, retain) NSNumber* transfers;
@property (nonatomic, retain) NSArray* legs;
@property (nonatomic, readonly) struct OTPBounds bounds;

@end
