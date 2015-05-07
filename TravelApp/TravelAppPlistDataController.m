//
//  TravelAppPlistDataControler.m
//  TravelApp
//
//  Created by Asemota Stefan on 10.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
// This controller file is used to load,read and write the application P-list file

#import "TravelAppPlistDataController.h"
#import "TravelAppCsvParser.h"

@implementation TravelAppPlistDataController

@synthesize allPreferences = allPreferences_;
@synthesize remoteDbManager = remoteDbManager_;
@synthesize nsManagedContext = nsManagedContext_;
@synthesize preferenceFilePath = preferenceFilePath_;

#pragma mark - Initialization Methods
// This method retreives the plist from the project resources folder and 
// checks if the travel app db version is the same as the remote db version.
// If there is a difference, the method shall call up the RemoteDbManagerClass to update
// the database.
-(id) init {
    self = [super init];
    return self;
}

// This init method takes the NSManagedObjectContext als parameter
-(id)initWithValue:(NSManagedObjectContext*)nsManagedObjectContext
{
    if ((self = [super init])) 
    {
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        
        plistPath = [rootPath stringByAppendingPathComponent:@"TravelAppPlistData.plist"];
        
        // Guard against null values
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
        {
            plistPath = [[NSBundle mainBundle] pathForResource:@"TravelAppPlistData" ofType:@"plist"];
            self.preferenceFilePath=plistPath;
        }
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        if (!temp) 
        {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        //set members varaibles
        self.allPreferences = temp;
        
        //set the nsmanaged context
        self.nsManagedContext = nsManagedObjectContext;
        
        // Initialize the remoteDbManager
        self.remoteDbManager = [[RemoteDbManager alloc] init];
    }
    return self;
}

#pragma mark - Application startup Methods
// This method verifies the current db version if the remote db version is higher an update shall be
// made
//THIS METHOD SHALL BE DELETED
-(BOOL)verifyApplicationDbVersion{
    return TRUE;
}

#pragma mark - PList specific Methods
-(NSString*) getValueForKey:(NSString*)keyItem{
    return [self.allPreferences valueForKey:keyItem];
}

-(NSString*) getRemoteDbVersionValue{
    return self.remoteDbManager.fetchRemoteDbVersionNumber;  
}

// If you need the plist from the main bundle you can copy it first in to the documents directory then modify it.
-(BOOL) writeVersionChangesToFile
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",@"TravelAppPlistData"]]; 
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]){
        NSLog(@"File don't exists at path %@", path);
        NSString *plistPathBundle = [[NSBundle mainBundle] pathForResource:@"TravelAppPlistData" ofType:@"plist"];
        [fileManager copyItemAtPath:plistPathBundle toPath: path error:&error]; 
    }else{
        NSLog(@"File exists at path:%@", path);
    }
    
    // get path to 
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    //here add elements to data file and write data to file
    BOOL value = FALSE;
    
    [data setObject:[NSNumber numberWithBool:value] forKey:@"TravelAppFirstTimeLaunch"];
    [data writeToFile: path atomically:YES];
    return TRUE;
}
@end
