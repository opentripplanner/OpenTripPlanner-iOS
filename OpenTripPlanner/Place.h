//
//  Place.h
//  Open Trip Planner
//
//  Created by asutula on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject {
    NSString* _name;
    NSNumber* _lon;
    NSNumber* _lat;
    NSString* _geometry;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSNumber* lon;
@property (nonatomic, retain) NSNumber* lat;
@property (nonatomic, retain) NSString* geometry;

@end
