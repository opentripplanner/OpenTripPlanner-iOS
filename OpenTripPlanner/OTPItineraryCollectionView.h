//
//  OTPItineraryCollectionView.h
//  OpenTripPlanner
//
//  Created by aogle on 10/15/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"

@interface OTPItineraryCollectionView : UICollectionView
@property (strong, nonatomic) Itinerary *itinerary;

@end
