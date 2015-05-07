//
//  DataModelQueryManager.m
//  TravelApp
//
//  Created by Asemota Stefan on 10.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//
// The purpose of this class is to decleare various data access methods for travel app

#import "DataModelQueryManager.h"
#import "Country.h"
#import "Country_attributes.h"
#import "travelAppDelegate.h"

//local class methods
@interface DataModelQueryManager()

//deletes all country data
-(void)deleteCountryData;

//deletes all country attributes data
-(void)deleteCountryAttributeData;

//deletes all airport data
-(void)deleteAirportData;
@end

@implementation DataModelQueryManager

// managed context
@synthesize nsManagedObjectContext = nsManagedObjectContext_;

// object model 
@synthesize objectModel = objectModel_;

// fetchresult controler
@synthesize nsFetchedResultsController = nsFetchedResultsController_;

#pragma mark - Initialization

// class initialization mehtod
- (id)initWithManagedObjectContent : (NSManagedObjectContext*) managedObjectContext 
                         withModel : (NSManagedObjectModel*) nsObjectModel
{
    
    self = [super init];
    self.objectModel=nsObjectModel;
    self.nsManagedObjectContext=managedObjectContext;
    
    return self;   
}

#pragma mark - Class methods

- (NSString*) convertToHtmlForWebView:(NSArray *) countryAttributes
{
    for (Country_attributes *item in countryAttributes) {
        NSLog(@"Country atributes Item: %@",item.type);
        NSLog(@"Country atributes Item: %@",item.value);
    } 
    return nil;
}

// returns the cooresponding country for a country_attribute
+ (NSManagedObject*) fetchCountryWithIsoKey : (NSString*) isoKeyValue
{
    //this is BAD CODING :-(
    travelAppDelegate *appDelegate = (travelAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[appDelegate.databaseManager managedObjectContext];
    //END OF BAD CODING
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Country" inManagedObjectContext:context];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(iso_code = %@)", isoKeyValue];
    [request setEntity:entity];
    [request setPredicate:pred];
    NSManagedObject *singleMatch = nil;
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        NSLog(@"No matches");
    }else {
        singleMatch = [objects objectAtIndex:0];
    }  
    return singleMatch;
}

#pragma mark - Fetch Query Methods
//Convenience method to fetch the array of objects for a given Entity
//name in the context, optionally limiting by a predicate or by a predicate
//made from a format NSString and variable arguments. An example query is

//[[self managedObjectContext] fetchObjectsForEntityName:@"Country" withPredicate:
// @"(name LIKE[c] 'Mali') AND (continent > %@)", continentSample]
- (NSMutableArray*) fetchArrayFromDBWithEntity : (NSString*) entityName
                                        forKey : (NSString*) keyName 
                                 withPredicate : (NSPredicate*) predicate
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.nsManagedObjectContext];
    [request setEntity:entity];
    [request setReturnsDistinctResults:true];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyName ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    if (predicate != nil)
        [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.nsManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"Error: %@", error);
    }
    return mutableFetchResults;
}

// all countries in a continent
- (NSArray*) fetchCountriesFromContinent : (NSString*) nameOfContinent
{
    //NSLog(@" Method - countriesFromContinent %@", nameOfContinent);
    //set query parameter
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Country" inManagedObjectContext:self.nsManagedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSSortDescriptor *sortDescriptorCountryName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorCountryName, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(continent = %@)", nameOfContinent];
    [request setPredicate:pred];
    NSError *error;
    
    NSArray *fetchedObjects = [self.nsManagedObjectContext executeFetchRequest:request error:&error];
    if ([fetchedObjects count] == 0) {
        
    } 
    //NSLog(@"Count of Countries found belonging to conitinent = %d",[fetchedObjects count]);
    return fetchedObjects;
}

// get continent name form country_iso_code
- (NSString*) getContinentFromCountryCode : (NSString*) countryIsoCode
{
    //NSLog(@" Method - continentFromCountryCode %@", countryIsoCode);
    
    //sort by country name
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]; 
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    //set query parameter
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Country" inManagedObjectContext:self.nsManagedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(iso_code = %@)", countryIsoCode];
    [request setPredicate:pred];
    [request setSortDescriptors:sortDescriptors];
    [request setFetchLimit:1];
    NSError *error;
    NSArray *fetchedObjects = [self.nsManagedObjectContext executeFetchRequest:request error:&error];
    if ([fetchedObjects count] == 0) {
        //error handling
    } 
    
    NSString *coninentName= [fetchedObjects objectAtIndex:0];
    //NSLog(@"Continent name found belonging to conitinent = %@",coninentName);
    return coninentName;
}

// all available contient
- (NSArray*) fetchAllContinents
{
    // NSLog(@" Method - allContinents %@", @"ALL");    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Country" inManagedObjectContext:self.nsManagedObjectContext];
    NSDictionary *entityProperties = [entity propertiesByName];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entity];
    [request setReturnsDistinctResults:TRUE];
    [request setPropertiesToFetch:[NSArray arrayWithObject:[entityProperties objectForKey:@"continent"]]];
    [request setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"continent" ascending:YES] ]];
    [request setResultType:NSDictionaryResultType];
    
    //execute request and fetch the results
    NSArray * results = [self.nsManagedObjectContext executeFetchRequest:request error:nil];
    // NSLog(@"Total # of continents %d",[results count]);
    return  results;
}

// all countries by each continent
- (NSArray*) fetchCountriesSortedByContinent
{
    // NSLog(@" Method - countriesSortedByContinent %@", @"sort by continent");
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Country" inManagedObjectContext:self.nsManagedObjectContext];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setReturnsDistinctResults:true];
    
    // Create the sort descriptors array.
    NSSortDescriptor* sortDescriptorContinent = [[NSSortDescriptor alloc] initWithKey:@"continent" ascending:YES];
    NSSortDescriptor *sortDescriptorCountryName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorContinent,sortDescriptorCountryName, nil];
    [request setSortDescriptors:sortDescriptors];
    
    // Clear the cache
	[NSFetchedResultsController deleteCacheWithName:@"Country"];
    
    // instanciate the nsfetch result controller
    self.nsFetchedResultsController = [[NSFetchedResultsController alloc] 
                                       initWithFetchRequest:request
                                       managedObjectContext:self.nsManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    NSError* error = nil;
    
    //execute request and fetch the results
    if (![[self nsFetchedResultsController] performFetch:&error])
    {
        // Handle error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //exit(-1);  // Fail
    }
    return  self.nsFetchedResultsController.fetchedObjects ;
}

-(NSArray*)fetchCountriesFromSearchWithName : (NSString*) countryName
                     withMinimalTemperature : (NSNumber*) minTemp 
                     withMaximalTemperature : (NSNumber*) maxTemp
                            withMaximalRain : (NSNumber*) maxRain
                              withLanguages : (NSArray*) languages
                                   inMonths : (NSArray*) months
{
    return nil;
}

// particular attribute name for a particular country i.e national language / DZ
- (NSArray*)fetchValuesForAttribute : (NSString*) attributeName 
                         forCountry : (NSString*) whichCountry
{
    NSLog(@"Name %@",attributeName);
    NSLog(@"Name %@",whichCountry);
    // SEARCH FOR WEATHER OBJECTS WHICH HAS THE MENTIONED TEMPRETURES AND RAIN DURING THE MONTHS
    //sort by country name
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES]; 
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    //set query parameter
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Country_attributes" inManagedObjectContext:self.nsManagedObjectContext];
    
    NSMutableArray *predicates = [[NSMutableArray alloc] initWithCapacity:5];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error = nil;
    
    Country * country = (Country*)[self fetchCountryWithIsoKey:whichCountry];
    // temp, predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(type == %@) AND (fkCountry ==  %@)", attributeName, country];
    [predicates addObject:predicate];
        
    [request setPredicate:predicate];
    [request setSortDescriptors:sortDescriptors];
    NSArray *fetchedObjects = [self.nsManagedObjectContext executeFetchRequest:request error:&error];
    if ([fetchedObjects count] == 0) {
        //error handling
    } 

    for (Country_attributes *item in fetchedObjects) {
        NSLog(@"NSMutableArray Item: %@",item.value);
    }
    
    // convert result in NSStrings
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (Country_attributes *item in fetchedObjects) {
        [results addObject:item.value];
    }
        
    //retreive objects
   // if([[self.nsManagedObjectContext executeFetchRequest:request error:&error] count]>0){
        //Country_attributes *couAttr
        
   //     Country *country = (Country*) [[self.nsManagedObjectContext executeFetchRequest:request error:&error] objectAtIndex:0]; 
    //    NSSet *results=[country fkCountryAttributes ];
    //    NSArray * countryAttributes= [[NSArray alloc] initWithArray:[results allObjects]];
    //    return countryAttributes;
   // }
    return [[NSArray alloc] initWithArray:results];
}

- (NSArray*) fetchCountryWithViewPredicates :(NSMutableArray*)weatherMonths 
                           withTempretureMax:(NSString*) tempMax 
                                 withTempMin:(NSString*) tempMin 
                                    withRain:(NSString*) precipi
{
    
    // SEARCH FOR WEATHER OBJECTS WHICH HAS THE MENTIONED TEMPRETURES AND RAIN DURING THE MONTHS
    //sort by country name
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fkCountry.name" ascending:YES]; 
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    //set query parameter
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Weather" inManagedObjectContext:self.nsManagedObjectContext];
    
    NSMutableArray *predicates = [[NSMutableArray alloc] initWithCapacity:5];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    // Guard against nils value, if nil set default values
    if (tempMax==nil) {
        tempMax=@"35";
    }
    if (tempMin==nil) {
        tempMin=@"0";
    }
    if (precipi==nil) {
        precipi=@"2000";
    }
    // temp, predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(average_high <= %@) AND (average_low >=  %@) AND (precipitation <= %@)", tempMax,tempMin,precipi];
    [predicates addObject:predicate];
    
    for(NSString *value in weatherMonths){
        NSLog(@"MONTHS: %@",value);
    }
    
    // Make sure months list is not nil
    if (weatherMonths!=nil) 
    {
        //NSMutableArray *viewWeatherMonths = [NSMutableArray arrayWithArray:weatherMonths];
        if ([weatherMonths count] > 0) {
            predicate = [NSPredicate predicateWithFormat:@"month IN %@", weatherMonths];
            [predicates addObject:predicate];
        }
        if ([weatherMonths count]) {
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];   
        }
    }
    
    [request setPredicate:predicate];
    [request setSortDescriptors:sortDescriptors];
    NSError *error;
    NSArray *fetchedObjects = [self.nsManagedObjectContext executeFetchRequest:request error:&error];
    if ([fetchedObjects count] == 0) {
        //error handling
    } 
    
    // SEARCH FOR ALL COUNTRIES USING THE ISO_CODE IN THE WEATHER OBEJCT
    NSMutableArray *countriesList= [[NSMutableArray alloc]init];
    for (Weather   *item in fetchedObjects) {
        Country * country = (Country *)item.fkCountry;
        if([countriesList containsObject:country] == FALSE)
        {
            [countriesList addObject:country];
        }
        
    } 
    NSLog(@"Countries Item: %d",countriesList.count);
    
    return [[NSArray alloc] initWithArray:countriesList];
}

#pragma mark - Inserts Query Methods
//Inserts all the country data in the collecition
// CURRENTLY NOT BEING USED
- (void) insertJSONCountryData:(NSMutableArray*) collections{
    NSError *myError;
    for(int x=0; x<[collections count];x++){
        
        //get a country row
        NSDictionary *info= [collections objectAtIndex:x];
        
        Country *mycountry=[NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:self.nsManagedObjectContext];
        NSString *countryName = NULL_TO_NIL([info objectForKey:@"name"]);
        mycountry.name=countryName;
        mycountry.iso_code=NULL_TO_NIL([info objectForKey:@"iso_code"]);
        mycountry.continent=NULL_TO_NIL([info objectForKey:@"continent"]);
        mycountry.capital=NULL_TO_NIL([info objectForKey:@"capital"]);
        //get the attributes of a country
        
        //persist object
        if (![self.nsManagedObjectContext save:&myError]) {
            NSLog(@"Ops Error");
        }
        NSLog(@"Country Object was saved: %@", countryName);
    }
}

// CURRENTLY NOT BEING USED
- (void) insertJSONCountryAttributesData:(NSMutableArray*) collections
{
    NSError *myError;
    for(int x=0; x<[collections count];x++){
        
        //get a country attribute row
        NSDictionary *info= [collections objectAtIndex:x];
        
        Country_attributes *countryAttributes = [NSEntityDescription insertNewObjectForEntityForName:@"Country_attributes" inManagedObjectContext:self.nsManagedObjectContext];
        NSString *attributeType=[info objectForKey:@"type"];
        countryAttributes.type=attributeType;
        countryAttributes.value =[info objectForKey:@"value"];
        countryAttributes.sorting=[info objectForKey:@"sorting"];
        countryAttributes.fkCountry=[info objectForKey:@"country_iso_code"];
        
        //persist object
        if (![nsManagedObjectContext save:&myError]) {
            NSLog(@"Ops Error");
        }
        NSLog(@"Country Object was saved: %@", attributeType);
    }
}

// THIS METHOD BASICALLY INSERTS AND DOES A SELECT ON THE ENTITY Favorites
- (void) testCoreData
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Favorites" inManagedObjectContext:self.nsManagedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [self.nsManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *model in fetchedObjects) {
        NSLog(@"Value: %@", [model valueForKey:@"type"]);
    }
}

/**
 --------------------------
 LOCAL CLASS METHODS!!!
 --------------------------
 */
#pragma mark - Delete Query Methods
// deletes all country data
- (void) deleteCountryData
{
    NSLog(@"About to delete all country data execute DELETE NSFetchRequest!");
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Country" inManagedObjectContext:self.nsManagedObjectContext]];
    //only fetch the managedObjectID
    [request setIncludesPropertyValues:NO];
    
    NSError * error = nil;
    NSArray * countries = [self.nsManagedObjectContext executeFetchRequest:request error:&error];
    //error handling goes here
    if(error) {
        NSLog(@"Cannot execute DELETE NSFetchRequest: %@", [error localizedDescription]);
        return ;
    }
    for (NSManagedObject * country in countries) {
        [self.nsManagedObjectContext deleteObject:country];
    }
    NSLog(@"Count of deleted countries: %d", [countries count]);
    NSError *saveError = nil;
    [self.nsManagedObjectContext save:&saveError];
}

// deletes all country attributes data
- (void) deleteCountryAttributeData
{
    NSLog(@"About to delete all country attributes data execute DELETE NSFetchRequest!");
    NSFetchRequest * allCountryAttributes = [[NSFetchRequest alloc] init];
    [allCountryAttributes setEntity:[NSEntityDescription entityForName:@"Country_attributes" inManagedObjectContext:self.nsManagedObjectContext]];
    //only fetch the managedObjectID
    [allCountryAttributes setIncludesPropertyValues:NO];
    
    NSError * error = nil;
    NSArray * attributes = [self.nsManagedObjectContext executeFetchRequest:allCountryAttributes error:&error];
    //error handling goes here
    if(error) {
        NSLog(@"Cannot execute DELETE NSFetchRequest: %@", [error localizedDescription]);
        return ;
    }
    for (NSManagedObject * countryAttributes in attributes) {
        [self.nsManagedObjectContext deleteObject:countryAttributes];
    }
    NSLog(@"Count of deleted country attributes: %d", [attributes count]);
    NSError *saveError = nil;
    [self.nsManagedObjectContext save:&saveError]; 
}

// deletes all airport data
- (void) deleteAirportData
{
    NSLog(@"About to delete all airports data execute DELETE NSFetchRequest!");
    NSFetchRequest * allAirports = [[NSFetchRequest alloc] init];
    [allAirports setEntity:[NSEntityDescription entityForName:@"Airport" inManagedObjectContext:self.nsManagedObjectContext]];
    
    //only fetch the managedObjectID
    [allAirports setIncludesPropertyValues:NO]; 
    
    NSError * error = nil;
    NSArray * airports = [self.nsManagedObjectContext executeFetchRequest:allAirports error:&error];
    //error handling goes here
    if(error) {
        NSLog(@"Cannot execute DELETE NSFetchRequest: %@", [error localizedDescription]);
        return ;
    }
    for (NSManagedObject * airport in airports) {
        [self.nsManagedObjectContext deleteObject:airport];
    }
    NSLog(@"Count of deleted airports: %d", [airports count]);
    NSError *saveError = nil;
    [self.nsManagedObjectContext save:&saveError];
}
//fetches country with isokey using the import nSManagedObjectContext instance
- ( NSManagedObject* ) fetchCountryWithIsoKey : (NSString*) isoKeyValue
{
    //NSLog(@" Method - allContinents %@", isoKeyValue);    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Country" inManagedObjectContext:self.nsManagedObjectContext];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(iso_code = %@)", isoKeyValue];
    [request setEntity:entity];
    [request setPredicate:pred];
    NSManagedObject *singleMatch = nil;
    NSError *error = nil;
    NSArray *objects = [self.nsManagedObjectContext executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        //NSLog(@"No matches,ISOkey %@",isoKeyValue);
    }else {
        singleMatch = [objects objectAtIndex:0];
        // NSLog(@"Search input was .., results are %@",singleMatch);
    }  
    return singleMatch;
}
@end
