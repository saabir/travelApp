//
//  DatabaseManager.m
//  TravelApp
//
//  Created by Ramon Saccilotto on 19.03.12.
//  Copyright (c) 2012 retrocode. All rights reserved.
//

#import "DatabaseManager.h"
#import "AppUtility.h"
#import "TravelAppCsvParser.h"

@implementation DatabaseManager

// synthesize properties to the app delegate implementation of the core data model
@synthesize managedObjectContext = managedObjectContext_;
@synthesize managedObjectModel = managedObjectModel_;
@synthesize persistentStoreCoordinator = persistentStoreCoordinator_;
@synthesize travelAppPlistDataController = travelAppPlistDataController_;
@synthesize importOperation = importOperation_;
@synthesize remoteDbManager = remoteDbManager_;

// setter for core data model queries
@synthesize dataModelQueryManager =dataModelQueryManager_;

// initialize the database for the first use from csv files
- (BOOL)initializeDatabase{
    
    //check for updates
    /*if ([self updateAvailable]) {
        //executute update
    }
     */
    //GUARD AGAINST UNNEEDED INITIALIZATION
    if ([[self.travelAppPlistDataController getValueForKey:@"TravelAppFirstTimeLaunch"] boolValue]) 
    {
        //first delete existing data 
        [self.dataModelQueryManager deleteCountryData];
        [self.dataModelQueryManager deleteAirportData];
        [self.dataModelQueryManager deleteCountryAttributeData];
        opQueue = [[NSOperationQueue alloc] init];
        
        // Create operation queue
        opQueue = [NSOperationQueue new];
        // set maximum operations possible
        [opQueue setMaxConcurrentOperationCount:2];
        
        CsvImportOperation *operation = [[CsvImportOperation alloc] init];
        [operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
        // operation starts as soon as its added
        [opQueue addOperation:operation]; 
        
        BOOL * isSuccessful=  [self.travelAppPlistDataController writeVersionChangesToFile];
        NSLog(@"All Data for CoreData was parsed and plist was written %d", (int)isSuccessful);
    
    }
    else
    {
        // happy end we do nothing :-D ufffff
        NSString *currentDbVersion= [self.travelAppPlistDataController getValueForKey:@"ConfigAppVersion"];
        NSLog ( @"Current db version of the local Core data %@", currentDbVersion );
    }
    
    // send notification
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
        
    // post notification
    [theCenter postNotificationName:@"databaseInitialized" object:nil];
    
    return FALSE;
}

// check if an update is available
- (BOOL)updateAvailable{
    // get current version
    NSString * localVersion= [self.travelAppPlistDataController getValueForKey:@"ConfigAppVersion"];
    
    // initialize the class
    self.remoteDbManager= [[RemoteDbManager alloc] init];
    NSString * remoteDbVerison= [self.remoteDbManager updateAvailable];
    
    if (localVersion==remoteDbVerison) {
        return false;
    }
    return true;
}

// update the database to a newer version (json-requests)
- (BOOL)updateDatabase{
    return FALSE;
}



# pragma mark - Core Data methods

// save core data model to the specified source (i.e. sqlite db)
- (void)saveContext
{
    NSError *error = nil;
    
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    // use a lazy getter
    if (managedObjectContext_ != nil)
    {
        return managedObjectContext_;
    }
    
    // create a managed object context with our persistentStoreCoordinator
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    
    return managedObjectContext_;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    // usa a lazy getter
    if (managedObjectModel_ != nil)
    {
        return managedObjectModel_;
    }
    
    // define the core data model for the application
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TravelAppModel" withExtension:@"momd"];
    
    // get a managed object model of our schema
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];   
    
    return managedObjectModel_;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // use lazy getter
    if (persistentStoreCoordinator_ != nil)
    {
        return persistentStoreCoordinator_;
    }
    
    // define sqlite as storage object for the core data model
    NSURL *storeURL = [[AppUtility applicationDocumentsDirectory] URLByAppendingPathComponent:@"TravelAppModel.sqlite"];
    
    // initialize errors
    NSError *error = nil;
    
    // initiliaze the persistentStoreCoordinator
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // check if any errors occured while creating the persistentStoreCoordinator
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}




@end
