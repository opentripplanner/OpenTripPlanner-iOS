//
//  OTPStepCell.h
//  OpenTripPlanner
//
//  Created by Aaron Sutula on 10/15/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTPInsetLabel.h"

@interface OTPStepCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *iconView;
@property(nonatomic, strong) IBOutlet OTPInsetLabel *instructionLabel;

@end
