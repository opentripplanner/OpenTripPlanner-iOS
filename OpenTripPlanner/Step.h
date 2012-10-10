//
//  Step.h
//  OpenTripPlanner
//
//  Created by Aaron Sutula on 10/6/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Step : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lon;

@end
