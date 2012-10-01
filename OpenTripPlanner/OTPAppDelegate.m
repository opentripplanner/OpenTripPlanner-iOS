//
//  OTPAppDelegate.m
//  OpenTripPlanner
//
//  Created by asutula on 8/29/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <RestKit/RestKit.h>
#import "OTPAppDelegate.h"

#import "Place.h"
#import "LegGeometry.h"
#import "Leg.h"
#import "Itinerary.h"
#import "Plan.h"
#import "OTPViewController.h"

@implementation OTPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    // Initialize RestKit
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:@"http://demo.opentripplanner.org/opentripplanner-api-webapp/ws"];
    
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    RKObjectMapping* placeMapping = [RKObjectMapping mappingForClass:[Place class]];
    [placeMapping mapKeyPathsToAttributes:
     @"name", @"name",
     @"lon", @"lon",
     @"lat", @"lat",
     @"geometry", @"geometry",
     nil];
    
    RKObjectMapping* legGeometryMapping = [RKObjectMapping mappingForClass:[LegGeometry class]];
    [legGeometryMapping mapKeyPathsToAttributes:
     @"length", @"length",
     @"points", @"points",
     nil];
    
    RKObjectMapping* legMapping = [RKObjectMapping mappingForClass:[Leg class]];
    [legMapping mapKeyPathsToAttributes:
     @"startTime", @"startTime",
     @"endTime", @"endTime",
     @"distance", @"distance",
     @"duration", @"duration",
     nil];
    [legMapping mapKeyPath:@"from" toRelationship:@"from" withMapping:placeMapping];
    [legMapping mapKeyPath:@"to" toRelationship:@"to" withMapping:placeMapping];
    [legMapping mapKeyPath:@"legGeometry" toRelationship:@"legGeometry" withMapping:legGeometryMapping];
    
    RKObjectMapping* itineraryMapping = [RKObjectMapping mappingForClass:[Itinerary class]];
    [itineraryMapping mapKeyPathsToAttributes:
     @"duration", @"duration",
     @"startTime", @"startTime",
     @"endTime", @"endTime",
     @"walkTime", @"walkTime",
     @"transitTime", @"transitTime",
     @"waitingTime", @"waitingTime",
     @"walkDistance", @"walkDistance",
     @"elevationLost", @"elevationLost",
     @"elevationGained", @"elevationGained",
     @"transfers", @"transfers",
     nil];
    [itineraryMapping mapKeyPath:@"legs" toRelationship:@"legs" withMapping:legMapping];
    
    RKObjectMapping* planMapping = [RKObjectMapping mappingForClass:[Plan class]];
    [planMapping mapKeyPathsToAttributes:
     @"plan.date", @"date",
     nil];
    [planMapping mapKeyPath:@"plan.from" toRelationship:@"from" withMapping:placeMapping];
    [planMapping mapKeyPath:@"plan.to" toRelationship:@"to" withMapping:placeMapping];
    [planMapping mapKeyPath:@"plan.itineraries" toRelationship:@"itineraries" withMapping:itineraryMapping];
    
    [objectManager.mappingProvider setObjectMapping:planMapping forResourcePathPattern:@"/plan"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([MKDirectionsRequest isDirectionsRequestURL:url]) {
        MKDirectionsRequest* directionsInfo = [[MKDirectionsRequest alloc] initWithContentsOfURL:url];
        // TO DO: Plot and display the route using the
        //   source and destination properties of directionsInfo.
        OTPViewController *viewContorller = (OTPViewController*)self.window.rootViewController;
        
//        if (directionsInfo.source.isCurrentLocation && !directionsInfo.destination.isCurrentLocation) {
//            [viewContorller planTripFromCurrentLocationTo:directionsInfo.destination.placemark.coordinate];
//        } else if (!directionsInfo.source.isCurrentLocation && directionsInfo.destination.isCurrentLocation) {
//            [viewContorller planTripToCurrentLocationFrom:directionsInfo.source.placemark.coordinate];
//        } else if (!directionsInfo.source.isCurrentLocation && !directionsInfo.destination.isCurrentLocation) {
//            [viewContorller planTripFrom:directionsInfo.source.placemark.coordinate
//                                      to:directionsInfo.destination.placemark.coordinate];
//        } else {
//            return NO;
//        }
        return YES;
    }
    else {
        // Handle other URL types...
    }
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
