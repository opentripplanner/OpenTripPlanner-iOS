//
//  Plan.h
//  Open Trip Planner
//
//  Created by asutula on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Place.h"

@interface Plan : NSObject

@property (nonatomic, strong) NSNumber *epochDate;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) Place* from;
@property (nonatomic, strong) Place* to;
@property (nonatomic, strong) NSArray* itineraries;

@end
