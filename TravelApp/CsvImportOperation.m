//
//  CsvImportOperation.m
//  TravelApp
//
//  Created by Asemota Stefan on 21.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "CsvImportOperation.h"
#import "travelAppDelegate.h"

@implementation CsvImportOperation

@synthesize error;

#pragma mark Initialization & Memory Management
// Create a new operation to make a series of records
- (id)initCsvOperation
{
    self = [super init];
	return self;
}

- (void)mergeChanges:(NSNotification *)notification
{
    // get instance of delegate
    travelAppDelegate *appDelegate = (travelAppDelegate *)[[UIApplication sharedApplication] delegate];
    // get the managedobject context
	NSManagedObjectContext *mainContext = appDelegate.databaseManager.managedObjectContext;
	
	// Merge changes into the main context on the main thread
	[mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)	
                                  withObject:notification
                               waitUntilDone:YES];	
}

#pragma mark Start & Utility Methods

// This method is just for convenience. It cancels the URL connection if it
// still exists and finishes up the operation.
- (void)done
{
    // Alert anyone that we are finished
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing_ = NO;
    finished_  = YES;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}

-(void)canceled {
	// Code for being cancelled
    self.error = [[NSError alloc] initWithDomain:@"DownloadUrlOperation"
                                        code:123
                                    userInfo:nil];
    [self done];
}

// 
- (void)start
{
    // Ensure that this operation starts on the main thread
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start)
                               withObject:nil waitUntilDone:NO];
        return;
    }
    
    // Ensure that the operation should exute
    if( finished_ || [self isCancelled] ) { [self done]; return; }
    
    // From this point on, the operation is officially executing--remember, isExecuting
    // needs to be KVO compliant!
    [self willChangeValueForKey:@"isExecuting"];
    executing_ = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    // Create the NSURLConnection--this could have been done in init, but we delayed
    // until no in case the operation was never enqueued or was cancelled before starting
    // Create context on background thread
    travelAppDelegate *appDelegate = (travelAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    // create the managed context NOT IN THE OPERATION INIT METHOD but in the start method for a concurrent queue
	NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] init];
	[ctx setUndoManager:nil];
	[ctx setPersistentStoreCoordinator: appDelegate.databaseManager.persistentStoreCoordinator];
	
	// Register context with the notification center
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc addObserver:self
           selector:@selector(mergeChanges:) 
               name:NSManagedObjectContextDidSaveNotification
             object:ctx];
	NSError *opError = nil;
    
	// Create some records to simulate a long running import
	[TravelAppCsvParser parseCountryCsvFile:ctx];
    [ctx save:& opError];
    
    if (error) {
        //[NSApp presentError:error]; 
    }
    [ctx reset];
    
    [TravelAppCsvParser parseCountryAttributesCsvFile:ctx];
    [ctx save:&opError];
    
    if (error) {
        //[NSApp presentError:error]; 
    }
    [ctx reset];
    
    [TravelAppCsvParser parseAirportCsvFile:ctx];
    [ctx save:&opError];
    
    if (error) {
        //[NSApp presentError:error]; 
    }
    [ctx reset];
    
    [TravelAppCsvParser parseCurrencyCsvFile:ctx];
    [ctx save:&opError];
    
    if (error) {
        //[NSApp presentError:error]; 
    }
    [ctx reset];
    
    [TravelAppCsvParser parseWeatherCsvFile:ctx];
    [ctx save:&opError];
    
    if (error) {
        //[NSApp presentError:error]; 
    }
    [ctx reset];
   // [TravelAppCsvParser parseRouteCsvFile:ctx];
    
    
	// Clean up any final imports
	//[ctx save:&opError];
	
	//if (error) {
		//[NSApp presentError:error]; 
	//}
    
	[ctx reset];
}

#pragma mark -
#pragma mark Overrides

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return executing_;
}

- (BOOL)isFinished
{
    return finished_;
}

@end
