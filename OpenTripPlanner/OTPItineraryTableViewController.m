//
//  OTPItineraryTableViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 10/1/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPItineraryViewController.h"

@interface OTPItineraryTableViewController ()
@end

@implementation OTPItineraryTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayFeedback:(id)sender
{
    [((OTPItineraryViewController *)self.parentViewController) presentFeedbackView];
}

@end
