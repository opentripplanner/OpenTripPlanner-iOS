//
//  OTPViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 8/30/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMMapView.h"

@interface OTPViewController : UIViewController
{
    RMMapView* _mapView;
}

@property (nonatomic, retain) IBOutlet RMMapView* mapView;

@end
