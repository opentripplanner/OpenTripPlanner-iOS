//
//  OTPAboutViewController.h
//  OpenTripPlanner
//
//  Created by Jeff Maki on 10/26/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPAboutViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *aboutTextView;

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *receivedData;

@end
