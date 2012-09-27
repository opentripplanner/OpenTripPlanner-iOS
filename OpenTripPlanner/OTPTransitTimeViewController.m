//
//  OTPTransitTimeViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 9/26/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPTransitTimeViewController.h"

@interface OTPTransitTimeViewController ()

@end

@implementation OTPTransitTimeViewController

@synthesize arrivingOrDepartingControl = _arrivingOrDepartingControl;
@synthesize datePicker = _datePicker;
@synthesize date;
@synthesize delegate = _delegate;

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
    self.datePicker.date = self.date;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)done:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(OTPTransitTimeViewControllerDelegate)]) {
        [self.delegate transitTimeViewController:self
               didChooseArrivingOrDepartingIndex:[NSNumber numberWithInt:self.arrivingOrDepartingControl.selectedSegmentIndex]
                                          atTime:self.datePicker.date];
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
