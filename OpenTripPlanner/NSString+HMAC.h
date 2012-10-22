//
//  NSString+HMAC.h
//  OpenTripPlanner
//
//  Created by asutula on 10/22/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HMAC)

- (NSString*) HMACWithSecret:(NSString*) secret;

@end
