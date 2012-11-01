//
//  OTPInsetLabel.h
//  OpenTripPlanner
//
//  Created by asutula on 10/26/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPInsetLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets insets;

- (void)resizeHeightToFitText;

@end
