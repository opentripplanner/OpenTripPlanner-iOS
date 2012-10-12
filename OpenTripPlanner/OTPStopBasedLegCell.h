//
//  OTPTransitLegCell.h
//  OpenTripPlanner
//
//  Created by asutula on 10/11/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPTransitLegCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *instructionLabel;
@property (strong, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *stopsLabel;

@end
