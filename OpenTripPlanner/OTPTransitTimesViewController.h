//
//  OTPTransitTimesViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 9/6/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPTransitTimesViewController : UITableViewController
{
    NSArray *_itineraries;
}

@property (nonatomic, retain) NSArray *itineraries;

- (IBAction)dismiss:(id)sender;

@end
