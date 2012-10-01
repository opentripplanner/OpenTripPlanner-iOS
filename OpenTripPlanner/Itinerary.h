//
//  Itinerary.h
//  Open Trip Planner
//
//  Created by asutula on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Leg.h"

@interface Itinerary : NSObject

@property (nonatomic, strong) NSNumber* duration;
@property (nonatomic, strong) NSDate* startTime;
@property (nonatomic, strong) NSDate* endTime;
@property (nonatomic, strong) NSNumber* walkTime;
@property (nonatomic, strong) NSNumber* transitTime;
@property (nonatomic, strong) NSNumber* waitingTime;
@property (nonatomic, strong) NSNumber* walkDistance;
@property (nonatomic, strong) NSNumber* elevationLost;
@property (nonatomic, strong) NSNumber* elevationGained;
@property (nonatomic, strong) NSNumber* transfers;
@property (nonatomic, strong) NSArray* legs;
@property (nonatomic, readonly) struct OTPBounds bounds;

@end
