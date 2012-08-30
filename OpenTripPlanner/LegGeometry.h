//
//  LegGeometry.h
//  Open Trip Planner
//
//  Created by asutula on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LegGeometry : NSObject {
    NSNumber* _length;
    NSString* _points;
}

@property (nonatomic, retain) NSNumber* length;
@property (nonatomic, retain) NSString* points;

@end
