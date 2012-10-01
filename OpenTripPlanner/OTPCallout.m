//
//  OTPCallout.m
//  OpenTripPlanner
//
//  Created by asutula on 9/12/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPCallout.h"

@implementation OTPCallout

BOOL visible;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCallout:(SMCalloutView *)callout forMarker:(RMMarker *)marker inMap:(RMMapView *)map
{
    self = [super init];
    if (self) {
        visible = NO;
        self.calloutView = callout;
        self.marker = marker;
        self.map = map;
        self.calloutView.delegate = self;
    }
    return self;
}

- (void)toggle
{
    if (visible) {
        [self.calloutView dismissCalloutAnimated:NO];
        visible = NO;
    } else {
        self.frame = CGRectMake(-self.marker.frame.origin.x, 0, self.map.frame.size.width, 0);
        [self.calloutView presentCalloutFromRect:CGRectMake(self.marker.frame.origin.x + self.marker.bounds.size.width/2, 0, 0, 0) inView:self constrainedToView:self.map permittedArrowDirections:SMCalloutArrowDirectionDown animated:YES];
        visible = YES;
    }
}

- (NSTimeInterval)calloutView:(SMCalloutView *)calloutView delayForRepositionWithSize:(CGSize)offset
{
    CLLocationCoordinate2D currentMapCenterCoord = self.map.centerCoordinate;
    CGPoint currentMapCenterPoint= [self.map coordinateToPixel:currentMapCenterCoord];
    CGPoint newCenterPoint = CGPointMake(currentMapCenterPoint.x - offset.width, currentMapCenterPoint.y - offset.height - 4);
    CLLocationCoordinate2D newCenterCoordinate = [self.map pixelToCoordinate:newCenterPoint];
    [self.map setCenterCoordinate:newCenterCoordinate animated:YES];
    return 0.2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
