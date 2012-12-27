//
//  OTPAboutViewController.m
//  OpenTripPlanner
//
//  Created by Jeff Maki on 10/26/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPAboutViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OTPAboutViewController ()

@end

@implementation OTPAboutViewController

- (void)viewDidLoad
{
    [TestFlight passCheckpoint:@"ABOUT"];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
