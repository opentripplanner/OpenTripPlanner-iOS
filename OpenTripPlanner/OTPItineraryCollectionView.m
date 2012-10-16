//
//  OTPItineraryCollectionView.m
//  OpenTripPlanner
//
//  Created by aogle on 10/15/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPItineraryCollectionView.h"

@interface OTPItineraryCollectionView ()
{
    NSSet* lastTouchesSentToNextResponder;
}

@end

@implementation OTPItineraryCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesBegan:touches withEvent:event];
    lastTouchesSentToNextResponder = touches;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (lastTouchesSentToNextResponder) {
        [self.nextResponder touchesCancelled:lastTouchesSentToNextResponder withEvent:event];
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // If not dragging, send event to next responder
    if (!self.dragging) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
    else {
        [super touchesEnded:touches withEvent:event];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
