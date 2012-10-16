//
//  OTPTransitTimeViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 9/26/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OTPTransitTimeViewControllerDelegate;

@interface OTPTransitTimeViewController : UIViewController

@property (nonatomic, strong) IBOutlet UISegmentedControl *arrivingOrDepartingControl;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *selectedSegment;
@property (nonatomic, strong) NSObject<OTPTransitTimeViewControllerDelegate> *delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end

@protocol OTPTransitTimeViewControllerDelegate <NSObject>

- (void)transitTimeViewController:(OTPTransitTimeViewController *)transitTimeViewController didChooseArrivingOrDepartingIndex:(NSNumber *)arrivingOrDepartingIndex atTime:(NSDate *)time;

@end
