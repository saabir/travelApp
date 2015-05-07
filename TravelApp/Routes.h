//
//  Routes.h
//  TravelApp
//
//  Created by Asemota Stefan on 20.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Airport;

@interface Routes : NSManagedObject

@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * from_airport;
@property (nonatomic, retain) NSDecimalNumber * time;
@property (nonatomic, retain) NSNumber * to_airport;
@property (nonatomic, retain) Airport *fkAirports;

@end
