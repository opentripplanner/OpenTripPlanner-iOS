//
//  OTPItineraryOverlayViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 11/26/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OTPItineraryOverlayViewControllerDelegate;

@interface OTPItineraryOverlayViewController : UIViewController

@property(nonatomic, strong) IBOutlet UIView *containerView;
@property(nonatomic, assign) NSObject<OTPItineraryOverlayViewControllerDelegate> *delegate;

- (IBAction)closeMe:(id)sender;

@end

@protocol OTPItineraryOverlayViewControllerDelegate <NSObject>

- (void)userClosedOverlay:(UIView *)overlay;

@end
