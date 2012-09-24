//
//  OTPCallout.h
//  OpenTripPlanner
//
//  Created by asutula on 9/12/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SMCalloutView.h"
#import "RouteMe.h"

@interface OTPCallout : UIView <SMCalloutViewDelegate>
{
    SMCalloutView *_calloutView;
    RMMarker *_marker;
    RMMapView *_map;
}

- (id)initWithCallout:(SMCalloutView *)callout forMarker:(RMMarker* )marker inMap:(RMMapView *)map;

- (void)toggle;

@property (nonatomic, retain) SMCalloutView *calloutView;
@property (nonatomic, retain) RMMarker *marker;
@property (nonatomic, retain) RMMapView *map;

@end
