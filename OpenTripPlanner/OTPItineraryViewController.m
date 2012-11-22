//
//  OTPItineraryViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 9/14/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPItineraryViewController.h"
#import "Leg.h"

@interface OTPItineraryViewController ()

@end

@implementation OTPItineraryViewController

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
    
    self.itineraryTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItineraryTableViewController"];
    self.itineraryTableViewController.itinerary = self.itinerary;
    self.itineraryTableViewController.fromTextField = self.fromTextField;
    self.itineraryTableViewController.toTextField = self.toTextField;
    self.itineraryTableViewController.navBar = self.navigationController.navigationBar;
    self.itineraryTableViewController.mapShowedUserLocation = self.mapShowedUserLocation;
    self.itineraryTableViewController.itineraryViewController = self;
    
    self.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:self.itineraryTableViewController];
    self.revealSideViewController.delegate = self.itineraryTableViewController;
    [self.revealSideViewController resetOption:PPRevealSideOptionsBounceAnimations];
    //[self.revealSideViewController resetOption:PPRevealSideOptionsShowShadows];
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
    [self.revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionContentView];
    [self.revealSideViewController setPanInteractionsWhenOpened:PPRevealSideInteractionContentView];
    [self.revealSideViewController setTapInteractionsWhenOpened:PPRevealSideInteractionNone];
    
    [self.view addSubview:self.revealSideViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(UIBarButtonItem *)sender
{
    [TestFlight passCheckpoint:@"ITINERARY_DONE"];
    [self dismissModalViewControllerAnimated:YES];
}

@end
