//
//  travelAppDelegate.m
//  TravelApp
//
//  Created by Ramon Saccilotto on 05.03.12.
//  Copyright (c) 2012 retrocode. All rights reserved.
//

#import "travelAppDelegate.h"
#import "Country.h"

@interface travelAppDelegate()

@end

@implementation travelAppDelegate

// main window
@synthesize window = window_;

#pragma mark - Core Data: synthesize properties

@synthesize databaseManager = databaseManager_;


// setter for the TravelApp plist
@synthesize travelAppPlistDataController = travelAppPlistDataController_;

// setter for travel search functions
@synthesize travelAppSearchController = travelAppSearchController_;

#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{        
    
    [self initializeDatabaseAtStartup];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // remove all pending observers
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    [theCenter removeObserver:self];
    
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)initializeDatabaseAtStartup{
    
    NSLog(@"%@", @"INITIALIZE THE DATABASE");
    
    
    // create new database manager
    self.databaseManager = [[DatabaseManager alloc] init];
    
    // Initialize the DataModelQueryManager for the application
    self.databaseManager.dataModelQueryManager = [[DataModelQueryManager alloc]initWithManagedObjectContent:self.databaseManager.managedObjectContext withModel:self.databaseManager.managedObjectModel];
    
    //set the travelappSearch
    self.travelAppSearchController = [[TravelAppSearchController alloc] initWithValue:self.databaseManager.dataModelQueryManager];
    
    // Load the TravelApp PList from either the Project Resource folder or a resource folder    
    self.travelAppPlistDataController = [[TravelAppPlistDataController alloc] initWithValue:self.databaseManager.managedObjectContext];
    
    // set plist atrribute in databasemanager
    self.databaseManager.travelAppPlistDataController = self.travelAppPlistDataController;
    
    [self.databaseManager initializeDatabase];
    
    //executes a sample test
    //[appDelegate.travelAppSearchController testCoreData];
    
}

@end
