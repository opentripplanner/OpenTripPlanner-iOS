//
//  Plan.h
//  Open Trip Planner
//
//  Created by asutula on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Place.h"

@interface Plan : NSObject {
    NSDate* _date;
    Place* _from;
    Place* _to;
    NSArray* _itineraries;
}

@property (nonatomic, retain) NSDate* date;
@property (nonatomic, retain) Place* from;
@property (nonatomic, retain) Place* to;
@property (nonatomic, retain) NSArray* itineraries;

@end
