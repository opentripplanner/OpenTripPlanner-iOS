//
//  Leg.m
//  Open Trip Planner
//
//  Created by asutula on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "Leg.h"

@interface Leg ()

- (NSMutableArray *)decodePolyLine:(NSString *)encodedStr;

@end

@implementation Leg

- (void)setLegGeometry:(LegGeometry *)legGeometry
{
    _legGeometry = legGeometry;
    _decodedLegGeometry = [self decodePolyLine:_legGeometry.points];
    
    CLLocationCoordinate2D northEastPoint;
    CLLocationCoordinate2D southWestPoint;
    
    int counter = 0;
    
    for (CLLocation *loc in _decodedLegGeometry) {
        
        CLLocationCoordinate2D point = loc.coordinate;
        
        if (counter == 0) {
            northEastPoint = point;
            southWestPoint = point;
        } else {
            if (point.longitude > northEastPoint.longitude)
                northEastPoint.longitude = point.longitude;
            if(point.latitude > northEastPoint.latitude)
                northEastPoint.latitude = point.latitude;
            if (point.longitude < southWestPoint.longitude)
                southWestPoint.longitude = point.longitude;
            if (point.latitude < southWestPoint.latitude)
                southWestPoint.latitude = point.latitude;
        }
        counter++;
    }
    _bounds.swCorner = southWestPoint;
    _bounds.neCorner = northEastPoint;
}

// http://code.google.com/apis/maps/documentation/utilities/polylinealgorithm.html
-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr
{
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    [encoded appendString:encodedStr];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        //          printf("[%f,", [latitude doubleValue]);
        //          printf("%f]", [longitude doubleValue]);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:loc];
    }
    return array;
}

@end
