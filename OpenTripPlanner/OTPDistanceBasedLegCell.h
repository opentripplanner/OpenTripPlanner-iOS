//
//  OTPWalkLegCell.h
//  OpenTripPlanner
//
//  Created by asutula on 10/11/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPDistanceBasedLegCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *instructionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@end
