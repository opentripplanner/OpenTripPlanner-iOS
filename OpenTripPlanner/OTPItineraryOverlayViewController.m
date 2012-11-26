//
//  OTPItineraryOverlayViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 11/26/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OTPItineraryOverlayViewController.h"

@interface OTPItineraryOverlayViewController ()

@end

@implementation OTPItineraryOverlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOpacity = 0.5;
    self.containerView.layer.shadowRadius = 5;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    self.containerView.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeMe:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    if ([self.delegate conformsToProtocol:@protocol(OTPItineraryOverlayViewControllerDelegate)]) {
        [self.delegate userClosedOverlay:self.view];
    }
}

@end
