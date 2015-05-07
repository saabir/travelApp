//
//  DataModelQueryManager.h
//  TravelApp
//
//  Created by Asemota Stefan on 10.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>

//a macro to handle json null properties
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface DataModelQueryManager : NSObject{
    NSManagedObjectContext *nsManagedObjectContext;
    NSManagedObjectModel *objectModel;
    NSFetchedResultsController *nsFetchedResultsController;
}

// ns managed object context
@property(nonatomic,retain)NSManagedObjectContext *nsManagedObjectContext;

//ns fetched result controler
@property(nonatomic,retain)NSFetchedResultsController *nsFetchedResultsController;

// existing managed object for this application
@property (nonatomic, retain, readwrite) NSManagedObjectModel *objectModel;

// returns the nsobject corresponding to the iso key of countryAttribute
+(NSManagedObject*)fetchCountryWithIsoKey:(NSString*)isoKeyValue;

#pragma mark - Initialization Methods
// This init method takes the NSManagedObjectContext als parameter
-(id)initWithManagedObjectContent:(NSManagedObjectContext*)managedObjectContext withModel:(NSManagedObjectModel*) nsObjectModel;

#pragma mark - Fetch Query Methods
//Convenience method to fetch the array of objects for a given Entity
//name in the context, optionally limiting by a predicate or by a predicate
//made from a format NSString and variable arguments.
- (NSMutableArray*)fetchArrayFromDBWithEntity:(NSString*)entityName 
                                       forKey:(NSString*)keyName
                                withPredicate:(NSPredicate*)predicate;

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
                       withMaximalRain:(NSNumber*) maxRain
                         withLanguages:(NSArray*)languages
                              inMonths:(NSArray*)months;

// particular attribute name for a particular country i.e national language / DZ
-(NSArray*)fetchValuesForAttribute:(NSString*)attributeName 
                      forCountry:(NSString*)whichCountry;

// search for a country with the following params
- (NSArray*) fetchCountryWithViewPredicates :(NSMutableArray*)weatherMonths 
                           withTempretureMax:(NSString*) tempMax 
                                 withTempMin:(NSString*) tempMin 
                                    withRain:(NSString*) precipi;
 
#pragma mark - Insert Query Methods
// Inserts a collection of country data to core data
-(void) insertJSONCountryData:(NSMutableArray*) collections;

// Inserts a collection of country attributes to core data
-(void)insertJSONCountryAttributesData:(NSMutableArray*) collections;

- ( NSManagedObject* ) fetchCountryWithIsoKey : (NSString*) isoKeyValue;

#pragma mark - Delete Query Methods
-(void)deleteAirportData;

-(void)deleteCountryAttributeData;

-(void)deleteCountryData;

#pragma mark - Test class Methods

- (void) testCoreData;
@end
