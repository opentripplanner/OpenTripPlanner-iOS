//
//  Response.h
//  OpenTripPlanner
//
//  Created by Aaron Sutula on 11/18/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Plan.h"
#import "Error.h"

@interface Response : NSObject

@property(nonatomic, strong) Plan *plan;
@property(nonatomic, strong) Error *error;

@end
