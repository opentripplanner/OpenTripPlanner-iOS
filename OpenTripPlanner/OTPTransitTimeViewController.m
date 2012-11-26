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
    [TestFlight passCheckpoint:@"PARAMS_OPEN"];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.datePicker.date = self.date;
    self.datePicker.minimumDate = [[[NSDate alloc] init] earlierDate:self.date];
    self.arrivingOrDepartingControl.selectedSegmentIndex = self.selectedSegment.intValue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel:(id)sender
{
    [TestFlight passCheckpoint:@"PARAMS_CANCEL"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done:(id)sender
{
    [TestFlight passCheckpoint:@"PARAMS_DONE"];
    if ([self.delegate conformsToProtocol:@protocol(OTPTransitTimeViewControllerDelegate)]) {
        [self.delegate transitTimeViewController:self
               didChooseArrivingOrDepartingIndex:[NSNumber numberWithInt:self.arrivingOrDepartingControl.selectedSegmentIndex]
                                          atTime:self.datePicker.date];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
