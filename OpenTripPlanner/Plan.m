//
//  Plan.m
//  Open Trip Planner
//
//  Created by asutula on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Plan.h"

@implementation Plan

- (void)setEpochDate:(NSNumber *)epochDate
{
    _epochDate = epochDate;
    self.date = [NSDate dateWithTimeIntervalSince1970:epochDate.floatValue/1000];
}

@end
