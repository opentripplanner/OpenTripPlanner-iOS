//
//  OTPDirectionPanGestureRecognizer.m
//  OpenTripPlanner
//
//  Created by Aaron Sutula on 11/25/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPDirectionPanGestureRecognizer.h"

int const static kDirectionPanThreshold = 5;

@implementation OTPDirectionPanGestureRecognizer

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (!_drag) {
        if (abs(_moveX) > kDirectionPanThreshold) {
            if (_direction == UISwipeGestureRecognizerDirectionDown || _direction == UISwipeGestureRecognizerDirectionUp) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _drag = YES;
            }
        } else if (abs(_moveY) > kDirectionPanThreshold) {
            if (_direction == UISwipeGestureRecognizerDirectionLeft || _direction == UISwipeGestureRecognizerDirectionRight) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _drag = YES;
            }
        }
    }
}

- (void)reset {
    [super reset];
    _drag = NO;
    _moveX = 0;
    _moveY = 0;
}
@end
