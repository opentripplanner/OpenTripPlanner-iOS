//
//  OTPTransitLegCell.h
//  OpenTripPlanner
//
//  Created by asutula on 10/11/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTPInsetLabel.h"

@interface OTPStopBasedLegCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *iconView;
@property(strong, nonatomic) IBOutlet OTPInsetLabel *instructionLabel;
@property(strong, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property(strong, nonatomic) IBOutlet UILabel *stopsLabel;
@property(strong, nonatomic) IBOutlet OTPInsetLabel *toLabel;

@end
