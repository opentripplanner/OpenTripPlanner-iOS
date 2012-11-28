//
//  OTPAppDelegate.h
//  OpenTripPlanner
//
//  Created by asutula on 8/29/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OTPItineraryMapViewController.h"

@interface OTPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *currentUrlString;
@property (strong, nonatomic) OTPItineraryMapViewController *itineraryMapViewController;

@end
