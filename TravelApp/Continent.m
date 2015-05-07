//
//  Continent.m
//  TravelApp
//
//  Created by Ramon Saccilotto on 19.03.12.
//  Copyright (c) 2012 retrocode. All rights reserved.
//

#import "Continent.h"

@implementation Continent

@synthesize name = name_;
@synthesize iso_code = iso_code_;
@synthesize latitude = latitude_;
@synthesize longitude = longitude_;
@synthesize zoom = zoom_;

- (id)initWithName:(NSString*)name withIso:(NSString*)iso withLatitude:(NSNumber*)latitude withLongitude:(NSNumber*)longitude withZoom:(NSNumber*)zoom
{
    self = [super init];
    
    self.name = name;
    self.iso_code = iso;
    self.latitude = latitude;
    self.longitude = longitude;
    self.zoom = zoom;
    
    return self;
}

// return a 2D location for the continent
- (CLLocationCoordinate2D)getContinentLocation
{
    return CLLocationCoordinate2DMake([self.latitude floatValue], [self.longitude floatValue]);
}

@end
