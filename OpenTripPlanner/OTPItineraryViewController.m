//
//  OTPItineraryViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 9/14/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPItineraryViewController.h"
#import "UIView+Origami.h"
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
    self.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:self.itineraryTableViewController];
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
    [self.revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionNone];
    [self.revealSideViewController setPanInteractionsWhenOpened:PPRevealSideInteractionContentView];
    [self.revealSideViewController setTapInteractionsWhenOpened:PPRevealSideInteractionNone];
    [self.view addSubview:self.revealSideViewController.view];
    
    self.itineraryMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItineraryMapViewController"];
    self.itineraryMapViewController.itinerary = self.itinerary;
    [self.revealSideViewController preloadViewController:self.itineraryMapViewController forSide:PPRevealSideDirectionLeft];
    [self.itineraryMapViewController displayItinerary];
    [self.itineraryMapViewController displayItineraryOverview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
