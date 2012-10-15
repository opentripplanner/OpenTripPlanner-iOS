//
//  OTPUnitFormatter.h
//  OpenTripPlanner
//
//  Created by Aaron Sutula on 10/14/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTPUnitFormatter : NSObject

@property(strong, nonatomic) NSNumber *cutoffMultiplier;
@property(strong, nonatomic) NSArray *unitData;

- (NSString *)numberToString:(NSNumber *)number;

@end
