//
//  Place.h
//  Open Trip Planner
//
//  Created by asutula on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* lon;
@property (nonatomic, strong) NSNumber* lat;
@property (nonatomic, strong) NSString* geometry;

@end
