//
//  DatabaseManager.h
//  TravelApp
//
//  Created by Ramon Saccilotto on 19.03.12.
//  Copyright (c) 2012 retrocode. All rights reserved.
//

#import <Foundation/Foundation.h>

// import class for core data interaction
#import "DataModelQueryManager.h"

//plist import for the application
#import "TravelAppPlistDataController.h"

// thread class for csv imports
#import "CsvImportOperation.h"

// RemoteDbManager
#import "RemoteDbManager.h"

@interface DatabaseManager : NSObject
{
    NSOperationQueue *opQueue;
    CsvImportOperation *importOperation;
    RemoteDbManager * remoteDbManager;
}

@property (retain) CsvImportOperation *importOperation;

@property(retain,nonatomic,readwrite) RemoteDbManager * remoteDbManager;
#pragma mark Public methods for database management

// initialize the database for the first use from csv files
- (BOOL)initializeDatabase;

// check if an update is available
- (BOOL)updateAvailable;

// update the database to a newer version (json-requests)
- (BOOL)updateDatabase;

// save data context to persistent storage
- (void)saveContext;

#pragma mark Core data model interaction

// application settings
@property(nonatomic, retain, readwrite) TravelAppPlistDataController *travelAppPlistDataController;

// single object space, it manages a collection of managed objects
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

// defines managed objects for this application
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;

// presents a facade to managed object contexts ( persistent object stores & managed object model)
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Applicaiton Query handler for the application
@property (nonatomic, retain, readwrite) DataModelQueryManager *dataModelQueryManager;

@end
