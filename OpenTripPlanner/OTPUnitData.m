//
//  OTPUnitData.m
//  OpenTripPlanner
//
//  Created by Aaron Sutula on 10/14/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPUnitData.h"

@implementation OTPUnitData

+ (OTPUnitData *)unitDataWithCutoff:(NSNumber *)cutoff multiplier:(NSNumber *)multiplier roundingIncrement:(NSNumber *)roundingIncrement singularLabel:(NSString *)singularLabel pluralLabel:(NSString *)pluralLabel
{
    return [[OTPUnitData alloc] initWithCutoff:cutoff multiplier:multiplier roundingIncrement:roundingIncrement singularLabel:singularLabel pluralLabel:pluralLabel];
}

- (id)initWithCutoff:(NSNumber *)cutoff multiplier:(NSNumber *)multiplier roundingIncrement:(NSNumber *)roundingIncrement singularLabel:(NSString *)singularLabel pluralLabel:(NSString *)pluralLabel
{
    self = [super init];
    if (self) {
        self.cutoff = cutoff;
        self.multiplier = multiplier;
        self.roundingIncrement = roundingIncrement;
        self.singularLabel = singularLabel;
        self.pluralLabel = pluralLabel;
    }
    return self;
}

@end
