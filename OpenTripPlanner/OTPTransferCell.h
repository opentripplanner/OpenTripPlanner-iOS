//
//  OTPTransferCell.h
//  OpenTripPlanner
//
//  Created by asutula on 10/17/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTPInsetLabel.h"

@interface OTPTransferCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *iconView;
@property(nonatomic, strong) IBOutlet OTPInsetLabel *instructionLabel;

@end
