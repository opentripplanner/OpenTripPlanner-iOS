//
//  OTPCallout.h
//  OpenTripPlanner
//
//  Created by asutula on 9/12/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RouteMe.h"

#import "SMCalloutView.h"

@interface OTPCallout : UIView <SMCalloutViewDelegate>

- (id)initWithCallout:(SMCalloutView *)callout forMarker:(RMMarker* )marker inMap:(RMMapView *)map;

- (void)toggle;

@property (nonatomic, strong) SMCalloutView *calloutView;
@property (nonatomic, strong) RMMarker *marker;
@property (nonatomic, strong) RMMapView *map;

@end
