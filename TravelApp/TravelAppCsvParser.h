//
//  TravelAppCsvParser.h
//  TravelApp
//
//  Created by Asemota Stefan on 15.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "parseCSV.h"
#import "Country.h"
#import "Country_attributes.h"
#import "Airport.h"
#import "Currency.h"
#import "Weather.h"
#import "Routes.h"

@interface TravelAppCsvParser : NSObject

// parses the country csv file and inserts into core data
+ (void)parseCountryCsvFile:(NSManagedObjectContext*)managedObjectContext;

//parses the country attributes csv and inserts into cored ata
+ (void)parseCountryAttributesCsvFile:(NSManagedObjectContext*)managedObjectContext;

// parses the airport csv and inserts into core data
+ (void)parseAirportCsvFile:(NSManagedObjectContext*)managedObjectContext;

// parse the currency csv and insert into coredata
+ (void)parseCurrencyCsvFile:(NSManagedObjectContext*)managedObjectContext;

// parse the weather csv and insert into coredata
+ (void)parseWeatherCsvFile:(NSManagedObjectContext*)managedObjectContext;

// parse the routes csv and inset into coredata
+ ( void ) parseRouteCsvFile : ( NSManagedObjectContext* ) managedObjectContext;

+(void)addCountryAttributesFk:(NSManagedObjectContext*)managedObjectContext;

//fetches the coresponding country using the a particualar isokey in a parcitualar cd contenxt
+ (NSManagedObject*)fetchCountryWithIsoKey:(NSString*)isoKeyValue nSManagedObjectContext:(NSManagedObjectContext*)context;

//fetches all the countries using the a particualar cd contenxt
+ (NSArray*)fetchAllCountries:(NSManagedObjectContext*)context;

//fetches all the countries attributes using the a particualar cd contenxt
+ (NSArray*)fetchAllCountriesAttributes:(NSManagedObjectContext*)context;

+ (Airport*)fetchAirportWithId:(NSManagedObjectContext*) context airportIdKey:(NSNumber*) idKey;
@end
