//
//  OTPSearchBarWithActivity.m
//  OpenTripPlanner
//
//  Created by asutula on 9/19/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPSearchBarWithActivity.h"

@implementation OTPSearchBarWithActivity

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        for (UIView *subview in self.subviews)
        {
            if ([subview conformsToProtocol:@protocol(UITextInputTraits)]) {
                [(UITextField *)subview setClearButtonMode:UITextFieldViewModeWhileEditing];
            }
        }
    }
    return self;
}

- (void)layoutSubviews {
    UITextField *searchField = nil;
    
    for(UIView* view in self.subviews){
        if([view isKindOfClass:[UITextField class]]){
            searchField= (UITextField *)view;
            break;
        }
    }
    
    if(searchField) {
        if (!self.activityIndicatorView) {
            UIActivityIndicatorView *taiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            taiv.center = CGPointMake(searchField.leftView.bounds.origin.x + searchField.leftView.bounds.size.width/2,
                                      searchField.leftView.bounds.origin.y + searchField.leftView.bounds.size.height/2);
            taiv.hidesWhenStopped = YES;
            taiv.backgroundColor = [UIColor whiteColor];
            self.activityIndicatorView = taiv;
            self.startCount = 0;
            
            [searchField.leftView addSubview:self.activityIndicatorView];
        }
    }
    
    [super layoutSubviews];
}

- (void)startActivity  {
    self.startCount = self.startCount + 1;
}

- (void)finishActivity {
    self.startCount = self.startCount - 1;
}

- (int)startCount {
    return self.startCount;
}

- (void)setStartCount:(int)startCount_ {
    self.startCount = startCount_;
    if (self.startCount > 0)
        [self.activityIndicatorView startAnimating];
    else {
        [self.activityIndicatorView stopAnimating];
    }
}

@end
