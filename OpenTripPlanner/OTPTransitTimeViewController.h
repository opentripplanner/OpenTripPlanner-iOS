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
{
    UISegmentedControl *_arrivingOrDepartingControl;
    UIDatePicker *_datePicker;
    NSDate *_date;
    NSObject<OTPTransitTimeViewControllerDelegate> *_delegate;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *arrivingOrDepartingControl;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSObject<OTPTransitTimeViewControllerDelegate> *delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end

@protocol OTPTransitTimeViewControllerDelegate <NSObject>

- (void)transitTimeViewController:(OTPTransitTimeViewController *)transitTimeViewController didChooseArrivingOrDepartingIndex:(NSNumber *)arrivingOrDepartingIndex atTime:(NSDate *)time;

@end
