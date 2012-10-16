//
//  OTPItineraryCell.h
//  OpenTripPlanner
//
//  Created by aogle on 10/11/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTPItineraryCollectionView.h"

@interface OTPItineraryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet OTPItineraryCollectionView *collectionView;

@end
