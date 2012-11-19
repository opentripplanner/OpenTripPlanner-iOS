//
//  Error.h
//  OpenTripPlanner
//
//  Created by Aaron Sutula on 11/18/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Error : NSObject

@property(nonatomic, strong) NSNumber *id;
@property(nonatomic, strong) NSString *msg;
@property BOOL noPath;

@end
