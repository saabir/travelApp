//
//  TravelAppCsvParser.m
//  TravelApp
//
//  Created by Asemota Stefan on 15.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "TravelAppCsvParser.h"
#import "DataModelQueryManager.h"
@implementation TravelAppCsvParser

#pragma mark - Import Country Data Method
+ ( void ) parseCountryCsvFile : (NSManagedObjectContext*) managedObjectContext
{
    NSLog(@" Method - allContinents Parsing!"); 
    NSError *myError;
    
    CSVParser *parser = [CSVParser new];
    //get the path to the file in your xcode project's resource path 
    NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:@"country_view" ofType:@"csv"];
    [parser openFile:csvFilePath];
    NSMutableArray *csvContent = [parser parseFile];
    
    for (int i = 1; i < [csvContent count]; i++) {
        NSArray* arr = [csvContent objectAtIndex:i];
        
        //  NSLog(@"Content of line %@",colOne );
        Country *countryRow = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:managedObjectContext];
        countryRow.iso_code = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:0]];
        countryRow.name = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:1]];
        countryRow.continent = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:2]];
        countryRow.capital = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:3]];
        countryRow.latitude = [[NSNumber alloc] initWithFloat:[[arr objectAtIndex:4] floatValue]];
        countryRow.longitude = [[NSNumber alloc] initWithFloat:[[arr objectAtIndex:5] floatValue]];
        
        if (![managedObjectContext save:&myError]) {
            NSLog(@"Ops Error inserting country data from csv file!");
        }   
    }
    NSLog(@"Countries created: %d",[csvContent count] );
    [parser closeFile];
}

#pragma mark - Import CountryAtributes Data Method
// parses the countryAttributes file "id","type","value","sorting","country_iso_code"
+ ( void ) parseCountryAttributesCsvFile : (NSManagedObjectContext*) managedObjectContext
{
    NSLog(@" Method - parseCountryAttributesCsvFile Parsing!");
    NSError *myError;
    
    CSVParser *parser = [CSVParser new];
    //get the path to the file in your xcode project's resource path 
    NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:@"country_attributes_view" ofType:@"csv"];
    [parser openFile:csvFilePath];
    NSMutableArray *csvContent = [parser parseFile];
    
    for (int i = 1; i < [csvContent count]; i++) {
        NSArray* arr = [csvContent objectAtIndex:i];
        // NSString *colSorting = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:3]];
        NSString *colIso = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:4]];
        
        //get fk of country
        NSManagedObject *refCountry = [TravelAppCsvParser fetchCountryWithIsoKey:colIso nSManagedObjectContext:managedObjectContext];
        // Guard against nil values
        if(refCountry != nil){
            Country_attributes *countryAttributesRow = [NSEntityDescription insertNewObjectForEntityForName:@"Country_attributes" inManagedObjectContext:managedObjectContext];
            countryAttributesRow.type = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:1]];
            countryAttributesRow.value = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:2]];
            countryAttributesRow.sorting = 0;
            //set fk from country attributes entity
            countryAttributesRow.fkCountry = refCountry;
            
            if (![managedObjectContext save:&myError]) {
                NSLog(@"Ops Error");
            }   
        }
        
    }
    NSLog(@"Country_attributes created: %d",[csvContent count] );
    [parser closeFile];
}

#pragma mark - Import Airport Data Method
// parses the airport csv and inserts into core data
+ ( void ) parseAirportCsvFile : (NSManagedObjectContext*) managedObjectContext
{
    NSLog(@" Method - parseAirportCsvFile Parsing!");
    NSError *myError;
    NSManagedObject *refCountry;
    CSVParser *parser = [CSVParser new];
    //get the path to the file in your xcode project's resource path 
    NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:@"airport_view" ofType:@"csv"];
    [parser openFile:csvFilePath];
    NSMutableArray *csvContent = [parser parseFile];
    
    for (int i = 1; i < [csvContent count]; i++) {
        NSArray* arr = [csvContent objectAtIndex:i];
        
        /// country iso code for FK
        NSString *colCountryIsoCode = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:6]];
        
        // convert timezone
        NSDecimalNumber *decimalTime = [[NSDecimalNumber alloc]
                                        initWithString:[arr objectAtIndex:8]];
        
        // get country key object
        refCountry= [TravelAppCsvParser fetchCountryWithIsoKey:colCountryIsoCode nSManagedObjectContext:managedObjectContext];
        // Guard against nil values
        if(refCountry!=nil){
            Airport *airportRow = [NSEntityDescription insertNewObjectForEntityForName:@"Airport" inManagedObjectContext:managedObjectContext];
            airportRow.mysqlId = [[NSNumber alloc] initWithInt:[[arr objectAtIndex:0] intValue]];
            airportRow.airport_name = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:1]];
            airportRow.country_name = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:7]];
            airportRow.city_name = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:2]];
            airportRow.type = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:3]];
            airportRow.latitude = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:4]];
            airportRow.longitude = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:5]];
            airportRow.country_iso_code = colCountryIsoCode;
            airportRow.timezone = decimalTime;
            airportRow.iata_code = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:9]];
            airportRow.icao_code = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:10]];
            //set country fk
            airportRow.fkCountry=(Country*)refCountry;
            
            if (![managedObjectContext save:&myError]) {
                NSLog(@"Ops Error");
            }  
        }
        //SET INVERSE FK FOR COUNTRY
        //[refCountry setValue:@"" forKey:@"fkCountryAttributes"];
    }
    NSLog(@"Airports created: %d",[csvContent count] );
    [parser closeFile];  
}

#pragma mark - Import Currency Data Method
//parse the currency csv and insert into coredata
+( void ) parseCurrencyCsvFile : (NSManagedObjectContext*) managedObjectContext
{
    NSLog(@" Method - parseCurrencyCsvFile Parsing!");
    NSError *myError;
    
    CSVParser *parser = [CSVParser new];
    //get the path to the file in your xcode project's resource path 
    NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:@"currency" ofType:@"csv"];
    [parser openFile:csvFilePath];
    NSMutableArray *csvContent = [parser parseFile];
    
    for (int i = 1; i < [csvContent count]; i++) {
        NSArray* arr = [csvContent objectAtIndex:i];
        
        Currency *countryRow = [NSEntityDescription insertNewObjectForEntityForName:@"Currency" inManagedObjectContext:managedObjectContext];
        countryRow.name = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:1]];
        countryRow.short_code = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:2]];
        countryRow.conversion_factor = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:3]];
        
        if (![managedObjectContext save:&myError]) {
            NSLog(@"Ops Error inserting currency data from csv file!");
        } 
        [managedObjectContext reset];
        
    }
    NSLog(@"Currency created: %d",[csvContent count] );
    [parser closeFile];
}

#pragma mark - Import Weather Data Method
// parse the weather csv and insert into coredata
+ ( void ) parseWeatherCsvFile : ( NSManagedObjectContext* ) managedObjectContext
{
    NSLog(@" Method - parseWeatherCsvFile Parsing!");
    NSError *myError;
    CSVParser *parser = [CSVParser new]; 
    
    // get the path to the file in your xcode project's resource path 
    NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:@"weather" ofType:@"csv"];
    // open file
    [parser openFile:csvFilePath];
    NSMutableArray *csvContent = [parser parseFile];
    
    for (int i = 1; i < [csvContent count]; i++) {
        // get a line
        NSArray* arr = [csvContent objectAtIndex:i];
        
        // retrieve country iso key at index 6
        NSString *isokey= [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:6]];
        Country *iso = (Country *)[TravelAppCsvParser fetchCountryWithIsoKey:isokey nSManagedObjectContext:managedObjectContext];
        // Guard against nil values
        if (iso != nil) {
            // create a weather object
            Weather *weatherRow = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:managedObjectContext];
            weatherRow.month = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:1]];
            weatherRow.average = [[NSNumber alloc] initWithInt:[[arr objectAtIndex:2] intValue]];
            weatherRow.average_high= [[NSNumber alloc] initWithInt:[[arr objectAtIndex:3] intValue]];
            weatherRow.average_low= [[NSNumber alloc] initWithInt:[[arr objectAtIndex:4] intValue]];
            weatherRow.precipitation= [[NSNumber alloc] initWithInt:[[arr objectAtIndex:5] intValue]];
            weatherRow.fkCountry=iso;
        }
        //save obejct
        if (![managedObjectContext save:&myError]) {
            NSLog(@"Ops Error inserting weather data from csv file!");
        }
    }
    NSLog(@"Weather created : %d",[csvContent count] );
    [parser closeFile]; 
}

#pragma mark - Import Routes Data method 

+ ( void ) parseRouteCsvFile : ( NSManagedObjectContext* ) managedObjectContext
{
    NSLog(@" Method - parseRouteCsvFile Parsing!");
    NSError *myError;
    CSVParser *parser = [CSVParser new]; 
    
    // get the path to the file in your xcode project's resource path 
    NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:@"routes" ofType:@"csv"];
    // open file
    [parser openFile:csvFilePath];
    NSMutableArray *csvContent = [parser parseFile];
    
    for (int i = 1; i < [csvContent count]; i++) {
        // get a line
        NSArray* arr = [csvContent objectAtIndex:i];
        
        // retrieve airport at via key 
        NSNumber *fromAirportRef= [[NSNumber alloc] initWithInt:[[arr objectAtIndex:3] intValue]];
        NSNumber *toAirportRef= [[NSNumber alloc] initWithInt:[[arr objectAtIndex:4] intValue]];
        Airport *from = (Airport *)[TravelAppCsvParser fetchAirportWithId:managedObjectContext airportIdKey:fromAirportRef];
        
        // GUARD AGAINST NIL DISTANCE
        NSNumber * distance = [[NSNumber alloc] initWithInt:[[arr objectAtIndex:1] intValue]];
        // Guard against nil values
        if (distance != nil && from!=nil) {
            // create a weather object
            Routes *routeRow = [NSEntityDescription insertNewObjectForEntityForName:@"Routes" inManagedObjectContext:managedObjectContext];
            routeRow.distance = distance;
            // routeRow.time= [[NSNumber alloc] initWithd:[[arr objectAtIndex:4] intValue]];
            routeRow.from_airport = fromAirportRef;
            routeRow.to_airport = toAirportRef;
            routeRow.fkAirports=from;
            
            //save obejct
            if (![managedObjectContext save:&myError]) {
                NSLog(@"Ops Error inserting Route data from csv file!");
            }
        }
    }
    NSLog(@"Route created : %d",[csvContent count] );
    [parser closeFile]; 
}

#pragma mark - Utility method for countries FK's

+ ( void ) addCountryAttributesFk : ( NSManagedObjectContext* ) managedObjectContext
{
    //all attributes
    NSArray * defaultLists= [TravelAppCsvParser fetchAllCountriesAttributes:managedObjectContext];
    //all countries
    NSArray * countryLists= [TravelAppCsvParser fetchAllCountries:managedObjectContext];
    //NSArray *list= [NSArray alloc];
    //iterate country
    for (Country *country in countryLists) {
        NSLog(@"An FK: %@", country.name);
        
        for (Country_attributes *attribute in defaultLists) {
            Country * att=(Country *)attribute.fkCountry;
            NSString *isoCode= att.iso_code;
            NSLog(@"An FK from attribute: %@", isoCode);
            if (isoCode==country.iso_code) {
                //we want to add this attribute to current country!!
            }
        }
        // countryAttributes= [NSSet setWithArray:list];
    }
}

#pragma mark - Utility method for countries NSSet attributes for country attributes
//fetches country with isokey using the import nSManagedObjectContext instance
+ ( NSManagedObject* ) fetchCountryWithIsoKey : (NSString*) isoKeyValue nSManagedObjectContext:(NSManagedObjectContext*)context{
    //NSLog(@" Method - allContinents %@", isoKeyValue);    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Country" inManagedObjectContext:context];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(iso_code = %@)", isoKeyValue];
    [request setEntity:entity];
    [request setPredicate:pred];
    NSManagedObject *singleMatch = nil;
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        //NSLog(@"No matches,ISOkey %@",isoKeyValue);
    }else {
        singleMatch = [objects objectAtIndex:0];
        // NSLog(@"Search input was .., results are %@",singleMatch);
    }  
    return singleMatch;
}

//fetches country using the import nSManagedObjectContext instance
+(Airport*)fetchAirportWithId:(NSManagedObjectContext*) context airportIdKey:(NSNumber*) idKey
{
    NSError *error;
    Airport * resultItem;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Airport" inManagedObjectContext:context]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(mysqlId = %@)", idKey];
    [request setPredicate:pred];
    NSArray *airports = [context executeFetchRequest:request error:&error];
    if (airports == nil || [airports count]==0) 
    {
        //NSLog(@"Failed / cant find %@", [error localizedDescription]);   
    }else
    {
        resultItem=[airports objectAtIndex:0];
    }
    return resultItem; 
}

//fetches country using the import nSManagedObjectContext instance
+(NSArray*)fetchAllCountriesAttributes:(NSManagedObjectContext*)context{
    NSError *error;
    NSFetchRequest *requestSettings = [[NSFetchRequest alloc] init];
    [requestSettings setEntity:[NSEntityDescription entityForName:@"Country_attributes" inManagedObjectContext:context]];
    NSArray *setting = [context executeFetchRequest:requestSettings error:&error];
    if (error) 
        NSLog(@"Failed to executeFetchRequest to data store: %@", [error localizedDescription]); 
    return setting;
}

//fetches all the countries using the a particualar cd contenxt
// DOES NOT RETURN ANYTHING RIGHT NOW
+ (NSArray*)fetchAllCountries:(NSManagedObjectContext*)context{
    
    return nil;
    
}
@end
