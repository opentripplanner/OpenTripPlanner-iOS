//
//  OTPArrivalCell.h
//  OpenTripPlanner
//
//  Created by eshon on 11/2/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTPInsetLabel.h"

@interface OTPArrivalCell : UITableViewCell

@property(strong, nonatomic) IBOutlet OTPInsetLabel *destinationText;
@property(strong, nonatomic) IBOutlet UILabel *arrivalTime;
@property(strong, nonatomic) IBOutlet UIImageView *icon;

@end
