//
//  RemoteDbManager.m
//  TravelApp
//
//  Created by Asemota Stefan on 10.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "RemoteDbManager.h"
#import "AppUtility.h"
#import "travelAppDelegate.h"

@implementation RemoteDbManager

@synthesize dataModelQueryManager =dataModelQueryManager_;

//Collections
@synthesize jsonCountryCollections = jsonCountryCollections_;
@synthesize jsonCountryAttributesCollections = jsonCountryAttributesCollections_;
@synthesize jsonCurrencyCollections=jsonCurrencyCollections_;
@synthesize jsonFavoritesCollections=jsonFavoritesCollections_;
@synthesize jsonUpdateHistoryCollections=jsonUpdateHistoryCollections_;
@synthesize jsonWeatherCollections=jsonWeatherCollections_;
@synthesize jsonAirportCollections=jsonAirportCollections_;

#pragma mark - Initialization Methods

-(id)init{
    self = [super init];
    self.jsonCountryCollections =[[NSMutableArray alloc] init];
    self.jsonCountryAttributesCollections=[[NSMutableArray alloc]init];
    travelAppDelegate *appDelegate = (travelAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.dataModelQueryManager=[appDelegate.databaseManager dataModelQueryManager];
    return self;
}

-(NSString*) updateAvailable
{
    NSError *myjsonerror;
    //retreive country data
    NSData *countryData = [self jsonUpdateAvailableData];
    NSMutableArray* collections = [NSJSONSerialization JSONObjectWithData:countryData options:kNilOptions error:&myjsonerror];
    NSString *version_;
    for(int x=0; x<[collections count];x++){
        
        //get an update row
        NSDictionary *info= [collections objectAtIndex:x];
        
        version_ = NULL_TO_NIL([info objectForKey:@"version"]);
        NSLog(@"Remote db version: %@", version_);
    }
    return version_;
}

#pragma mark - Convienence Methods
-(BOOL) firstTimeApplicationDataSetup{
    NSError *myjsonerror;
    BOOL wasSetupOk=TRUE;
    
    //retreive country data
    NSData *countryData = [self jsonCountryRemoteData];
    jsonCountryCollections_ = [NSJSONSerialization JSONObjectWithData:countryData options:kNilOptions error:&myjsonerror];
    //INSERT COUNTRY INTO DATABASE
    [self.dataModelQueryManager insertJSONCountryData:jsonCountryCollections_];
    
    //retreive country attribute data
    NSData *countryAttributeData = [self jsonCountryAttributesRemoteData];
    jsonCountryAttributesCollections_=[NSJSONSerialization JSONObjectWithData:countryAttributeData options:kNilOptions error:&myjsonerror];
    
    //INSERT COUNTRY-ATTRIBUTES INTO DATABASE
    [self.dataModelQueryManager insertJSONCountryAttributesData:jsonCountryAttributesCollections_];
    
    //retreive currency data
    NSData *countryCurrencyRemoteData = [self jsonCountryCurrencyRemoteData];
    countryCurrencyRemoteData=[NSJSONSerialization JSONObjectWithData:countryCurrencyRemoteData options:kNilOptions error:&myjsonerror];
    
    //retreive favorites data
    NSData *favoritesRemoteData = [self jsonFavoritesRemoteData];
    favoritesRemoteData=[NSJSONSerialization JSONObjectWithData:favoritesRemoteData options:kNilOptions error:&myjsonerror];
    
    //retreive history data
    NSData *updateHistoryRemoteData = [self jsonUpdateHistoryRemoteData];
    updateHistoryRemoteData= [NSJSONSerialization JSONObjectWithData:updateHistoryRemoteData options:kNilOptions error:&myjsonerror];
    
    //retreive weather data
    NSData *weatherRemoteData = [self jsonWeatherRemoteData];
    weatherRemoteData=[NSJSONSerialization JSONObjectWithData:weatherRemoteData options:kNilOptions error:&myjsonerror];
    
    //print out collections counts
    [AppUtility printOutMutableArrayObjects:jsonCountryCollections_];
    [AppUtility printOutMutableArrayObjects:jsonCountryAttributesCollections_];
    [AppUtility printOutMutableArrayObjects:jsonCurrencyCollections_];
    [AppUtility printOutMutableArrayObjects:jsonFavoritesCollections_];
    [AppUtility printOutMutableArrayObjects:jsonUpdateHistoryCollections_];
    [AppUtility printOutMutableArrayObjects:jsonWeatherCollections_];
    
    if (wasSetupOk) {
        // NSLog(@"Total count of Countries downloaded : %d",len);
        return true; 
    }else{
        return false;
    } 
}

// In charge of updating the local coredata
-(BOOL)updateLocalCoreData{
    return FALSE;
}

// This method returns the current version of the remote database verison
-(NSString*) fetchRemoteDbVersionNumber{
    return @"1.0";
}

#pragma mark - JSON GET Methods
// Returns all the airports
-(NSData*)jsonAirportRemoteData{
    return nil;
}

-(NSData*)jsonCountryRemoteData{
    if ([AppUtility networkReachability]) {
        NSURL *url= [NSURL URLWithString:phpJsonUrlGetCountry];
        //Insert the country data in core data
        return [NSData dataWithContentsOfURL:url];
    }
    return nil;
}

-(NSData*)jsonCountryAttributesRemoteData{
    NSURL *url= [NSURL URLWithString:phpJsonUrlGetCountryAttributes];
    return [NSData dataWithContentsOfURL:url];
}

-(NSData*)jsonCountryCurrencyRemoteData{
    NSURL *url= [NSURL URLWithString:phpJsonUrlGetCountryCurrency];
    return [NSData dataWithContentsOfURL:url];
}

-(NSData*)jsonFavoritesRemoteData{
    NSURL *url= [NSURL URLWithString:phpJsonUrlGetFavorites];
    return [NSData dataWithContentsOfURL:url];
}

-(NSData*)jsonUpdateHistoryRemoteData{
    NSURL *url= [NSURL URLWithString:phpJsonUrlGetUpdateHistory];
    return [NSData dataWithContentsOfURL:url];
}

-(NSData*)jsonWeatherRemoteData{
    NSURL *url= [NSURL URLWithString:phpJsonUrlGetWeather];
    return [NSData dataWithContentsOfURL:url];
}

-(NSData*)jsonUpdateAvailableData
{
    NSURL *url= [NSURL URLWithString:phpJsonUrlIsUpdateAvailable];
    return [NSData dataWithContentsOfURL:url];
}
@end
