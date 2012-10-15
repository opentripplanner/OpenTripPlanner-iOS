//
//  OTPUnitData.h
//  OpenTripPlanner
//
//  Created by Aaron Sutula on 10/14/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTPUnitData : NSObject

@property(nonatomic, strong) NSNumber *cutoff;
@property(nonatomic, strong) NSNumber *multiplier;
@property(nonatomic, strong) NSNumber *roundingIncrement;
@property(nonatomic, strong) NSString *singularLabel;
@property(nonatomic, strong) NSString *pluralLabel;

+ (OTPUnitData *)unitDataWithCutoff:(NSNumber *)cutoff multiplier:(NSNumber *)multiplier roundingIncrement:(NSNumber *)roundingIncrement singularLabel:(NSString *)singularLabel pluralLabel:(NSString *)pluralLabel;
- (id)initWithCutoff:(NSNumber *)cutoff multiplier:(NSNumber *)multiplier roundingIncrement:(NSNumber *)roundingIncrement singularLabel:(NSString *)singularLabel pluralLabel:(NSString *)pluralLabel;

@end
