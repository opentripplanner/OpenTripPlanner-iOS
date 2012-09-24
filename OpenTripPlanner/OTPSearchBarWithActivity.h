//
//  OTPSearchBarWithActivity.h
//  OpenTripPlanner
//
//  Created by asutula on 9/19/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPSearchBarWithActivity : UISearchBar
{
    UIBarButtonItem *_directionsButton;
    UIActivityIndicatorView *activityIndicatorView;
    int startCount;
}

@property (nonatomic, retain) UIBarButtonItem *directionsButton;
@property(retain) UIActivityIndicatorView *activityIndicatorView;
@property int startCount;

- (void)startActivity;  // increments startCount and shows activity indicator
- (void)finishActivity; // decrements startCount and hides activity indicator if 0

@end
