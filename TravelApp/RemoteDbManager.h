//
//  RemoteDbManager.h
//  TravelApp
//
//  Created by Asemota Stefan on 10.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "DataModelQueryManager.h"

//SELECT SCRIPTS

// php select script for country table
#define phpJsonUrlIsUpdateAvailable @"http://travelapp.asemota.ch/getJSONUpdateVersion.php"

// php select script for country table
#define phpJsonUrlGetAirport @"http://travelapp.asemota.ch/getJSONAirport.php"

// php select script for country table
#define phpJsonUrlGetCountry @"http://travelapp.asemota.ch/getJSONCountry.php"

// php select script for country table
#define phpJsonUrlGetCountryAttributes @"http://travelapp.asemota.ch/getJSONCountryAttributes.php"

// php select script for country table
#define phpJsonUrlGetCountryCurrency @"http://travelapp.asemota.ch/getJSONCountryMapCurrency.php"

// php select script for country table
#define phpJsonUrlGetFavorites @"http://travelapp.asemota.ch/getJSONFavorites.php"

// php select script for country table
#define phpJsonUrlGetUpdateHistory @"http://travelapp.asemota.ch/getJSONUpdateHistory.php"

// php select script for country table
#define phpJsonUrlGetWeather @"http://travelapp.asemota.ch/getJSONWeather.php"

//INSERTS SCRIPTS
// php insert script country table
#define myPhpScriptInsertUrl @"http://travelapp.asemota.ch/insertData.php"

//declear my country table attributes
#define myCountryAtrributeName @"name"
#define myCountryAtrributeRefDetail @"refDetail"
#define myCountryAtrributeRefState @"refState"

@interface RemoteDbManager : NSObject{
    
    NSURLConnection *myPhpConnection;
    
    NSMutableArray *jsonAirportCollections;
    NSMutableArray *jsonCountryCollections;
    NSMutableArray *jsonCountryAttributesCollections;
    NSMutableArray *jsonCurrencyCollections;
    NSMutableArray *jsonFavoritesCollections;
    NSMutableArray *jsonUpdateHistoryCollections;
    NSMutableArray *jsonWeatherCollections;
   DataModelQueryManager *dataModelQueryManager;
    
}
@property(nonatomic,retain) DataModelQueryManager *dataModelQueryManager;

@property (nonatomic,retain) NSMutableArray *jsonCountryCollections;
@property(nonatomic,retain) NSMutableArray *jsonCountryAttributesCollections;
@property(nonatomic,retain) NSMutableArray *jsonAirportCollections;
@property(nonatomic,retain) NSMutableArray *jsonCurrencyCollections;
@property(nonatomic,retain) NSMutableArray *jsonFavoritesCollections;
@property(nonatomic,retain) NSMutableArray *jsonUpdateHistoryCollections;
@property(nonatomic,retain) NSMutableArray *jsonWeatherCollections;

#pragma mark - Initialization Methods
// Designated initializer
-(id)init;

#pragma mark - Convienence Methods
-(NSString*)fetchRemoteDbVersionNumber;

-(BOOL) firstTimeApplicationDataSetup;

-(NSString*) updateAvailable;

-(BOOL)updateLocalCoreData;

#pragma mark - JSON GET Methods
// Methods below are instance methods
-(NSData*)jsonAirportRemoteData;

// This method does a get using the sql define phpJsonUrlGetCountryAttributes
// query, the result is an json object
-(NSData*)jsonCountryRemoteData;

// This method does a get using the sql define: phpJsonUrlGetCountryAttributes
// query, the result is an json object
-(NSData*)jsonCountryAttributesRemoteData;

// This method does a get using the sql define: phpJsonUrlGetCountryCurrency
// query, the result is an json object
-(NSData*)jsonCountryCurrencyRemoteData;

// This method does a get using the sql define: phpJsonUrlGetFavorites
// query, the result is an json object
-(NSData*)jsonFavoritesRemoteData;

// This method does a get using the sql define: phpJsonUrlGetUpdateHistory
// query, the result is an json object
-(NSData*)jsonUpdateHistoryRemoteData;

// This method does a get using the sql define: phpJsonUrlGetWeather
// query, the result is an json object
-(NSData*)jsonWeatherRemoteData;

-(NSData*)jsonUpdateAvailableData;

@end
