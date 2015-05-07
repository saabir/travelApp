//
//  TravelAppSearchController.h
//  TravelApp
//
//  Created by Asemota Stefan on 13.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModelQueryManager.h"

@interface TravelAppSearchController : NSObject{
    DataModelQueryManager *dataModelQueryManager;
}

@property(nonatomic,retain,readwrite) DataModelQueryManager *dataModelQueryManager;

#pragma mark - Initialization Methods

// Designated initializer
-(id)initWithValue:(DataModelQueryManager*)aDataModelQueryManager;

#pragma mark - Fetch Query Methods

// all countries in a continent
-(NSArray*)fetchCountriesFromContinent:(NSString*)nameOfContinent;

// get continent name form country_iso_code
-(NSString*)getContinentFromCountryCode:(NSString*)countryIsoCode;

// all available contient
-(NSArray*)fetchAllContinents;

// all countries by each continent
-(NSArray*)fetchCountriesSortedByContinent;

-(NSArray*)fetchCountriesFromSearchWithName:(NSString*)countryName
                     withMinimalTemperature:(NSNumber*)minTemp 
                     withMaximalTemperature:(NSNumber*)maxTemp
                            withMaximalRain:(NSNumber*)maxRain
                              withLanguages:(NSArray*)languages
                                   inMonths:(NSArray*)months;

// particular attribute name for a particular country i.e national language / DZ
-(NSArray*)fetchValuesForAttribute:(NSString*)attributeName 
                      forCountry:(NSString*)whichCountry;


//returns an array of objects with the supplied predicates
- (NSMutableArray*)fetchArrayFromDBWithEntity:(NSString*)entityName
                                       forKey:(NSString*)keyName
                                withPredicate:(NSPredicate*)predicate;

// search for a country with the following params
- (NSArray*) fetchCountryWithViewPredicates :(NSMutableArray*)weatherMonths 
                           withTempretureMax:(NSString*) tempMax 
                                 withTempMin:(NSString*) tempMin 
                                    withRain:(NSString*) precipi;

#pragma mark - Test Methods
//TESTS METHODS
- (void)testCoreData;
@end
