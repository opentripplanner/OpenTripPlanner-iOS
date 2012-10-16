//
//  Step.h
//  OpenTripPlanner
//
//  Created by Aaron Sutula on 10/6/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Step : NSObject

@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSString *relativeDirection;
@property (strong, nonatomic) NSString *streetName;
@property (strong, nonatomic) NSString *absoluteDirection;
@property (strong, nonatomic) NSString *exit;
@property Boolean stayOn;
@property Boolean bogusName;
@property (strong, nonatomic) NSNumber *lon;
@property (strong, nonatomic) NSNumber *lat;

@end
