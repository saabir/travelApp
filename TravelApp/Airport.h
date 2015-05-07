//
//  Airport.h
//  TravelApp
//
//  Created by Asemota Stefan on 21.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country, Routes;

@interface Airport : NSManagedObject

@property (nonatomic, retain) NSString * airport_name;
@property (nonatomic, retain) NSString * city_name;
@property (nonatomic, retain) NSString * country_iso_code;
@property (nonatomic, retain) NSString * country_name;
@property (nonatomic, retain) NSString * iata_code;
@property (nonatomic, retain) NSString * icao_code;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSDecimalNumber * timezone;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * mysqlId;
@property (nonatomic, retain) Country *fkCountry;
@property (nonatomic, retain) Routes *fkRoutes;

@end
