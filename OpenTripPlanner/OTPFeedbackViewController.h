//
//  OTPFeedbackViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 11/21/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPFeedbackViewController : UIViewController <UITextViewDelegate>

@property(nonatomic, strong) IBOutlet UITextView *textView;
@property(nonatomic, strong) IBOutlet UIBarButtonItem *submitButton;
@property(nonatomic, strong) IBOutlet UIView *topView;

- (IBAction)updatedText:(id)sender;
- (IBAction)submit:(id)sender;

@end
