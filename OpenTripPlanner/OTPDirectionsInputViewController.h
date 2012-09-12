//
//  OTPDirectionsInputViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 9/10/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OTPGeocodedTextField.h"

@protocol OTPDirectionsInputViewControllerDelegate;

@interface OTPDirectionsInputViewController : UIViewController <UITextFieldDelegate>
{
    UISegmentedControl *_modeControl;
    UIBarButtonItem *_cancelButton;
    UIView *_textFieldContainer;
    OTPGeocodedTextField *_fromTextField;
    OTPGeocodedTextField *_toTextField;
    UITextField *_dummyField;
    UISegmentedControl *_switchFromAndToButton;
    NSObject<OTPDirectionsInputViewControllerDelegate> *_delegate;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *modeControl;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIView *textFieldContainer;
@property (nonatomic, retain) IBOutlet OTPGeocodedTextField *fromTextField;
@property (nonatomic, retain) IBOutlet OTPGeocodedTextField *toTextField;
@property (nonatomic, retain) IBOutlet UITextField *dummyField;
@property (nonatomic, retain) UISegmentedControl *switchFromAndToButton;
@property (nonatomic, retain) NSObject<OTPDirectionsInputViewControllerDelegate> *delegate;

- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)updatedTextField:(id)sender;
- (IBAction)doneEditingTextField:(id)sender;

@end

@protocol OTPDirectionsInputViewControllerDelegate <NSObject>

- (void)directionsInputViewCancelButtonClicked:(OTPDirectionsInputViewController *)directionsInputView;
- (void)directionsInputViewRouteButtonClicked:(OTPDirectionsInputViewController *)directionsInputView;
- (void)directionsInputView:(OTPDirectionsInputViewController *)directionsInputView geocodedPlacemark:(CLPlacemark *)placemark;
- (void)directionsInputView:(OTPDirectionsInputViewController *)directionsInputView choseRouteFrom:(CLPlacemark *)from to:(CLPlacemark *)to;

@end