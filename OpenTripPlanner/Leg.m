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

- (void)setEpochStartTime:(NSNumber *)epochStartTime
{
    _epochStartTime = epochStartTime;
    self.startTime = [NSDate dateWithTimeIntervalSince1970:epochStartTime.floatValue/1000];
}

- (void)setEpochEndTime:(NSNumber *)epochEndTime
{
    _epochEndTime = epochEndTime;
    self.endTime = [NSDate dateWithTimeIntervalSince1970:epochEndTime.floatValue/1000];
}

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
            southWestPoint.longitude = MIN(southWestPoint.longitude, point.longitude);
            southWestPoint.latitude = MIN(southWestPoint.latitude, point.latitude);
            northEastPoint.longitude = MAX(northEastPoint.longitude, point.longitude);
            northEastPoint.latitude = MAX(northEastPoint.latitude, point.latitude);
        }
        counter++;
    }
    _bounds.swCorner = southWestPoint;
    _bounds.neCorner = northEastPoint;
}

// http://objc.id.au/post/9245961184/mapkit-encoded-polylines
-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    const char *bytes = [encodedStr UTF8String];
    NSUInteger length = [encodedStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:finalLat longitude:finalLon];
        [array addObject:loc];
    }
    return array;
}

@end
