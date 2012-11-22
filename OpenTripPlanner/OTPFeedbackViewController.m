//
//  OTPFeedbackViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 11/21/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPFeedbackViewController.h"

@interface OTPFeedbackViewController ()

@end

@implementation OTPFeedbackViewController

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
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    self.topView.center = CGPointMake(self.topView.center.x, self.topView.center.y - self.topView.bounds.size.height);
}

- (void)viewDidAppear:(BOOL)animated
{
    self.topView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.topView.center = CGPointMake(self.topView.center.x, self.topView.center.y + self.topView.bounds.size.height);
    }];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIView animateWithDuration:0.3 animations:^{
        self.topView.center = CGPointMake(self.topView.center.x, self.topView.center.y - self.topView.bounds.size.height);
    }];
    [self.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.textView.text.length > 0) {
        self.submitButton.enabled = YES;
    } else {
        self.submitButton.enabled = NO;
    }
}

- (void)willShowKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect newFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, self.textView.frame.size.height - keyboardRect.size.height);
    self.textView.frame = newFrame;
}

- (void)willHideKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect newFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, self.textView.frame.size.height + keyboardRect.size.height);
    self.textView.frame = newFrame;
}

- (void)submit:(id)sender
{
    [TestFlight submitFeedback:self.textView.text];
    [self.navigationController popViewControllerAnimated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Thanks for your feedback!" delegate:nil cancelButtonTitle:@"No problem" otherButtonTitles: nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
