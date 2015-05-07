//
//  CurrentLocation.h
//  TravelApp
//
//  Created by Ramon Saccilotto on 20.03.12.
//  Copyright (c) 2012 retrocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CurrentLocation : NSObject <CLLocationManagerDelegate>
    
- (void)getCurrentLocation;
- (void)stopUpdatingLocation:(NSString *)state;
@end
