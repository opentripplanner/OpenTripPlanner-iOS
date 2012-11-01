//
//  OTPItineraryOverviewCell.h
//  OpenTripPlanner
//
//  Created by eshon on 10/31/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OTPItineraryOverviewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *iconView;
//@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;
@property (strong, nonatomic) IBOutlet UILabel *departTime;
@property (strong, nonatomic) IBOutlet UILabel *arriveTime;

@end
