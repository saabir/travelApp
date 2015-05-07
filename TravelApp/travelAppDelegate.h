//
//  travelAppDelegate.h
//  TravelApp
//
//  Created by Ramon Saccilotto & Asemota Stephan on March 2012
//  Copyright (c) 2012 retrocode. All rights reserved.
//
//  DESCRIPTION:
//  This is the starting point and main delegate for our application


// import classes for core data model and database handling
#import "DatabaseManager.h"

// import class for plist handling
#import "TravelAppPlistDataController.h"

// import class for search handling
#import "TravelAppSearchController.h"

// main interface of the application
@interface travelAppDelegate : UIResponder <UIApplicationDelegate>

// main window for application
@property (strong, nonatomic) UIWindow *window;


#pragma mark - Core Data: properties

// application settings
@property(nonatomic, retain, readwrite) TravelAppPlistDataController *travelAppPlistDataController;

//exposes all the search functions to the applicaton
@property(nonatomic, retain, readwrite) TravelAppSearchController *travelAppSearchController;

// manages initalization, update and connection to the core data database
@property(nonatomic, retain, readwrite) DatabaseManager *databaseManager;

- (void)initializeDatabaseAtStartup;

@end
