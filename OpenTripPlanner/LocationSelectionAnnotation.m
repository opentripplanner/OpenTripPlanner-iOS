//
//  LocationSelectionAnnotation.m
//  Open Trip Planner
//
//  Created by asutula on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationSelectionAnnotation.h"

@implementation LocationSelectionAnnotation

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    [super setCoordinate:coordinate];
    self.title = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
}

@end
