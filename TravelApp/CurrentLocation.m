//
//  CurrentLocation.m
//  TravelApp
//
//  Created by Ramon Saccilotto on 20.03.12.
//  Copyright (c) 2012 retrocode. All rights reserved.
//

#import "CurrentLocation.h"

@interface CurrentLocation()

    // location manager to get current location
    @property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation CurrentLocation 

@synthesize locationManager = locationManager_;

// start watching location
- (void)getCurrentLocation
{    
    // Create the manager object 
    self.locationManager = [[CLLocationManager alloc] init];
    
    // check whether location services are enabled
    if ([self.locationManager locationServicesEnabled] == NO) {
        
        // post notification that location services are not available
        NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
        [theCenter postNotificationName:@"locationServicesNotAvailable" object:nil];

    }
    
    self.locationManager.delegate = self;
    
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
    // self.locationManager.desiredAccuracy = [[setupInfo objectForKey:kSetupInfoKeyAccuracy] doubleValue];
    
    // Once configured, the location manager must be "started".
    [self.locationManager startUpdatingLocation];
}

// get update from location change
- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation 
{    
    
    // stop updating the location if we have a new location
    [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
    
    // create a notification and add the current location as information
    
    // get the default notification center
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
        
    // get position information into a dictionary object
    NSDictionary *location = [NSDictionary dictionaryWithObjectsAndKeys: [[NSNumber alloc] initWithDouble:newLocation.coordinate.latitude], @"latitude",  [[NSNumber alloc] initWithDouble:newLocation.coordinate.longitude], @"longitude", @"currentLocation", @"type", nil];
    
    // pass the information of the continent on to anyone who is listening
    NSDictionary *locationInfo = [NSDictionary dictionaryWithObjectsAndKeys:location, @"locationInfo", nil];
    [theCenter postNotificationName:@"currentLocationAcquired" object:nil userInfo:locationInfo];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
}

// stop updating the location
- (void)stopUpdatingLocation:(NSString *)state {
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    
}



@end
