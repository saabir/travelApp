//
//  TravelAppPlistDataControler.h
//  TravelApp
//
//  Created by Asemota Stefan on 10.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//  This class provides methods for the reading of the application plists

#import <Foundation/Foundation.h>
#import "RemoteDbManager.h"

@interface TravelAppPlistDataController : NSObject{
    //an array of preferences
    NSDictionary *allPreferences;
    NSString * preferenceFilePath;
    NSManagedObjectContext * nsManagedContext;
}

@property (nonatomic,retain) NSDictionary *allPreferences;
@property(nonatomic,retain,readwrite) RemoteDbManager *remoteDbManager;
@property(nonatomic,retain) NSManagedObjectContext *nsManagedContext;
@property(nonatomic,retain) NSString * preferenceFilePath;
#pragma mark - Initialization Methods
// Designated initializer
-(id)initWithValue:(NSManagedObjectContext*)nsManagedObjectContext;

-(id)init;

#pragma mark - Application startup Methods
// This method verifies the current db version
-(BOOL)verifyApplicationDbVersion;

#pragma mark - PList specific Methods
// This method returns the plist value of the cooresponding key
-(NSString*) getValueForKey:(NSString*)keyItem;

// This method returns the version of the remote mysql server
-(NSString*) getRemoteDbVersionValue;

// Writes the the plist property TravelAppFirstTimeLaunch
-(BOOL*) writeVersionChangesToFile;

@end
