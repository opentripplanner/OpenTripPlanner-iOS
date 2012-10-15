//
//  OTPUnitFormatter.m
//  OpenTripPlanner
//
//  Created by Aaron Sutula on 10/14/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPUnitFormatter.h"
#import "OTPUnitData.h"

@interface OTPUnitFormatter ()
{
    NSNumberFormatter *_numberFormatter;
}

@end

@implementation OTPUnitFormatter

- (id)init
{
    self = [super init];
    if (self) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.maximumFractionDigits = 1;
        _numberFormatter.roundingMode = NSNumberFormatterRoundUp;
    }
    return self;
}

- (NSString *)numberToString:(NSNumber *)number
{
    OTPUnitData *validUnitData;
    for (OTPUnitData *unitData in self.unitData) {
        float convertedNumber = number.floatValue * self.cutoffMultiplier.floatValue;
        if (convertedNumber <= unitData.cutoff.floatValue) {
            validUnitData = unitData;
            break;
        }
    }
    if (validUnitData) {
        _numberFormatter.roundingIncrement = validUnitData.roundingIncrement;
        _numberFormatter.multiplier = validUnitData.multiplier;
        NSString *formattedValue = [_numberFormatter stringFromNumber:number];
        NSString *units = formattedValue == @"1" ? validUnitData.singularLabel : validUnitData.pluralLabel;
        formattedValue = [[formattedValue stringByAppendingString:@" "] stringByAppendingString:units];
        return formattedValue;
    }
    return nil;
}

@end
