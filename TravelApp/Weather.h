//
//  Weather.h
//  TravelApp
//
//  Created by Asemota Stefan on 19.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country;

@interface Weather : NSManagedObject

@property (nonatomic, retain) NSNumber * average;
@property (nonatomic, retain) NSNumber * average_high;
@property (nonatomic, retain) NSNumber * average_low;
@property (nonatomic, retain) NSString * month;
@property (nonatomic, retain) NSNumber * precipitation;
@property (nonatomic, retain) Country *fkCountry;

@end
