//
//  TravelAppSearchController.m
//  TravelApp
//
//  Created by Asemota Stefan on 13.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
// This class supplies all the search functionality for the application

#import "TravelAppSearchController.h"

// private methods
@interface TravelAppSearchController()

//Convenience local method to fetch the array of objects for a given Entity
- (NSMutableArray*)fetchArrayFromDBWithEntity:(NSString*)entityName 
                                       forKey:(NSString*)keyName 
                                withPredicate:(NSPredicate*)predicate;

@end

@implementation TravelAppSearchController

// This class exposes various query methods to core data
@synthesize dataModelQueryManager = dataModelQueryManager_;

#pragma mark - Initializaiton Methods
//init method 
-(id)initWithValue:(DataModelQueryManager*)aDataModelQueryManager{
    if ((self = [super init])) {
        self.dataModelQueryManager=aDataModelQueryManager;
    }
    return self;
}

#pragma mark - Fetch Query Methods

// all countries in a continent
-(NSArray*)fetchCountriesFromContinent:(NSString*)nameOfContinent{
    return [self.dataModelQueryManager fetchCountriesFromContinent:nameOfContinent];
}

-(NSString*)getContinentFromCountryCode:(NSString*)countryIsoCode{
    return @"NOT YET IMPLEMENTED";
}

// all available contient
-(NSArray*)fetchAllContinents{
    return [self.dataModelQueryManager fetchAllContinents];
}

// all countries by each continent
-(NSArray*)fetchCountriesSortedByContinent{
    return [self.dataModelQueryManager fetchCountriesSortedByContinent];
}

-(NSArray*)fetchCountriesFromSearchWithName:(NSString*)countryName
                withMinimalTemperature:(NSNumber*)minTemp 
                withMaximalTemperature:(NSNumber*)maxTemp
                       withMaximalRain:(NSNumber*) maxRain
                         withLanguages:(NSArray*)languages
                              inMonths:(NSArray*)months{
    return [self.dataModelQueryManager fetchCountriesFromSearchWithName:countryName withMinimalTemperature:minTemp withMaximalTemperature:maxTemp withMaximalRain:maxRain withLanguages:languages inMonths:months];
}

// particular attribute name for a particular country i.e national language / DZ
-(NSArray*)fetchValuesForAttribute:(NSString*)attributeName 
                      forCountry:(NSString*)whichCountry{
    return [self.dataModelQueryManager fetchValuesForAttribute:attributeName forCountry:whichCountry];
}

//returns an array of objects with the supplied predicates
- (NSMutableArray*)fetchArrayFromDBWithEntity:(NSString*)entityName
                                       forKey:(NSString*)keyName
                                withPredicate:(NSPredicate*)predicate{
        return [self.dataModelQueryManager fetchArrayFromDBWithEntity:entityName forKey:keyName withPredicate:predicate];
}

// search for a country with the following params
- (NSArray*) fetchCountryWithViewPredicates :(NSMutableArray*)weatherMonths 
                           withTempretureMax:(NSString*) tempMax 
                                 withTempMin:(NSString*) tempMin 
                                    withRain:(NSString*) precipi{
    return [self.dataModelQueryManager fetchCountryWithViewPredicates:weatherMonths withTempretureMax:tempMax withTempMin:tempMin withRain:precipi];
}

#pragma mark - Test Methods
//TESTS VARIOUS SEARCH METHODS OF CORE DATA
- (void)testCoreData{
    [self.dataModelQueryManager fetchAllContinents];
    [self.dataModelQueryManager fetchCountriesFromContinent:@"EU"]; 
    [self.dataModelQueryManager fetchValuesForAttribute:@"National language" forCountry:@"DZ"]; 
    
    // The code below executes a insert into the table favourites!
    // [self.dataModelQueryManager testCoreData];
}

@end
