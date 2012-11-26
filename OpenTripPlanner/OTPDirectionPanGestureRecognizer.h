//
//  OTPDirectionPanGestureRecognizer.h
//  OpenTripPlanner
//
//  Created by Aaron Sutula on 11/25/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface OTPDirectionPanGestureRecognizer : UIPanGestureRecognizer
{
    BOOL _drag;
    int _moveX;
    int _moveY;
}

@property (nonatomic, assign) UISwipeGestureRecognizerDirection direction;

@end
