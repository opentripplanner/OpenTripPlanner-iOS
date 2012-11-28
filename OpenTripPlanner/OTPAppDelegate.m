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
#import "Response.h"
#import "OTPDirectionsInputViewController.h"
#import "UIDevice+IdentifierAddition.h"

@implementation OTPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    #define TESTING 1
    #ifdef TESTING
        [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    #endif
    [TestFlight takeOff:@"b6cabd426fa7b67e7671bfb043872d5f_MTI1NzEzMjAxMi0wOC0yNyAxNDo1NToyNy43MjE2MDk"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceId = [defaults stringForKey:@"deviceId"];
    if (deviceId == nil) {
        deviceId = [[UIDevice currentDevice] uniqueDeviceIdentifier];
        [defaults setObject:deviceId forKey:@"deviceId"];
        [defaults synchronize];
    }
    
    self.itineraryMapViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"ItineraryMapViewController"];
    
//    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    // Initialize RestKit
    //RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:@"http://demo.opentripplanner.org/opentripplanner-api-webapp/ws"];
    
    //RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:@"http://sfbay.deployer.opentripplanner.org/opentripplanner-api-webapp/ws"];
    
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:@"http://otpna.deployer.opentripplanner.org/opentripplanner-api-webapp/ws"];
    
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    RKObjectMapping* placeMapping = [RKObjectMapping mappingForClass:[Place class]];
    [placeMapping mapKeyPathsToAttributes:
     @"name", @"name",
     @"lon", @"lon",
     @"lat", @"lat",
     @"geometry", @"geometry",
     nil];
    
    RKObjectMapping* stepMapping = [RKObjectMapping mappingForClass:[Step class]];
    [stepMapping mapKeyPathsToAttributes:
     @"distance", @"distance",
     @"relativeDirection", @"relativeDirection",
     @"streetName", @"streetName",
     @"absoluteDirection", @"absoluteDirection",
     @"exit", @"exit",
     @"stayOn", @"stayOn",
     @"bogusName", @"bogusName",
     @"lon", @"lon",
     @"lat", @"lat",
     nil];
    
    RKObjectMapping* legGeometryMapping = [RKObjectMapping mappingForClass:[LegGeometry class]];
    [legGeometryMapping mapKeyPathsToAttributes:
     @"length", @"length",
     @"points", @"points",
     nil];
    
    RKObjectMapping* legMapping = [RKObjectMapping mappingForClass:[Leg class]];
    [legMapping mapKeyPathsToAttributes:
     @"route", @"route",
     @"headsign", @"headsign",
     @"mode", @"mode",
     @"startTime", @"epochStartTime",
     @"endTime", @"epochEndTime",
     @"distance", @"distance",
     @"duration", @"duration",
     nil];
    [legMapping mapKeyPath:@"from" toRelationship:@"from" withMapping:placeMapping];
    [legMapping mapKeyPath:@"to" toRelationship:@"to" withMapping:placeMapping];
    [legMapping mapKeyPath:@"intermediateStops" toRelationship:@"intermediateStops" withMapping:placeMapping];
    [legMapping mapKeyPath:@"legGeometry" toRelationship:@"legGeometry" withMapping:legGeometryMapping];
    [legMapping mapKeyPath:@"steps" toRelationship:@"steps" withMapping:stepMapping];
    
    RKObjectMapping* itineraryMapping = [RKObjectMapping mappingForClass:[Itinerary class]];
    [itineraryMapping mapKeyPathsToAttributes:
     @"duration", @"duration",
     @"startTime", @"epochStartTime",
     @"endTime", @"epochEndTime",
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
     @"date", @"epochDate",
     nil];
    [planMapping mapKeyPath:@"from" toRelationship:@"from" withMapping:placeMapping];
    [planMapping mapKeyPath:@"to" toRelationship:@"to" withMapping:placeMapping];
    [planMapping mapKeyPath:@"itineraries" toRelationship:@"itineraries" withMapping:itineraryMapping];
    
    RKObjectMapping* errorMapping = [RKObjectMapping mappingForClass:[Error class]];
    [errorMapping mapKeyPathsToAttributes:
     @"id", @"id",
     @"msg", @"msg",
     @"noPath", @"noPath",
     nil];
    
    RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[Response class]];
    [responseMapping mapKeyPath:@"plan" toRelationship:@"plan" withMapping:planMapping];
    [responseMapping mapKeyPath:@"error" toRelationship:@"error" withMapping:errorMapping];
    
    [objectManager.mappingProvider setObjectMapping:responseMapping forResourcePathPattern:@"/plan"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([MKDirectionsRequest isDirectionsRequestURL:url]) {
        [TestFlight passCheckpoint:@"LAUNCHED_BY_URL"];
        
        MKDirectionsRequest* directionsInfo = [[MKDirectionsRequest alloc] initWithContentsOfURL:url];
        // TO DO: Plot and display the route using the
        //   source and destination properties of directionsInfo.
        OTPDirectionsInputViewController *viewContorller = (OTPDirectionsInputViewController*)self.window.rootViewController;
        viewContorller.launchedFromUrl = YES;
        // If the app is already open, dismiss any view controllers that are already displayed and reset the input fields
        [viewContorller dismissViewControllerAnimated:NO completion:nil];
        [viewContorller updateTextField:viewContorller.toTextField withText:nil andLocation:nil];
        [viewContorller updateTextField:viewContorller.fromTextField withText:nil andLocation:nil];
        
        if (directionsInfo.source.isCurrentLocation) {
            [viewContorller updateTextField:viewContorller.toTextField withText:@"End Location" andLocation:directionsInfo.destination.placemark.location];
            viewContorller.needsShowFromAndToLocations = YES;
            [viewContorller enableUserLocation];
        } else if (directionsInfo.destination.isCurrentLocation) {
            [viewContorller updateTextField:viewContorller.fromTextField withText:@"Start Location" andLocation:directionsInfo.source.placemark.location];
            viewContorller.needsShowFromAndToLocations = YES;
            [viewContorller enableUserLocation];
        } else {
            [viewContorller updateTextField:viewContorller.fromTextField withText:@"Start Location" andLocation:directionsInfo.source.placemark.location];
            [viewContorller updateTextField:viewContorller.toTextField withText:@"End Location" andLocation:directionsInfo.destination.placemark.location];
            [viewContorller showFromAndToLocations];
        }
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
