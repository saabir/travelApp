//
//  Continent.h
//  TravelApp
//
//  Created by Ramon Saccilotto on 19.03.12.
//  Copyright (c) 2012 retrocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Continent : NSObject

// define properties for the continent
@property(nonatomic, retain, readwrite) NSString *name;

@property(nonatomic, retain, readwrite) NSString *iso_code;

@property(nonatomic, retain, readwrite) NSNumber *latitude;

@property(nonatomic, retain, readwrite) NSNumber *longitude;

@property(nonatomic, retain, readwrite) NSNumber *zoom;

- (CLLocationCoordinate2D)getContinentLocation;

- (id)initWithName:(NSString*)name withIso:(NSString*)iso withLatitude:(NSNumber*)latitude withLongitude:(NSNumber*)longitude withZoom:(NSNumber*)zoom;

@end
