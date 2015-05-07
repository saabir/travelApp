//
//  AppUtility.h
//  TravelApp
//
//  Created by Asemota Stefan on 11.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>

// Collection class of several utilities
@interface AppUtility : NSObject

// Check if internet connection is available (try to connect to google.com)
// returns true if connection can be established
+(BOOL) networkReachability;

// prints out the obejects of a NSMutableArray data
+(void) printOutMutableArrayObjects:(NSMutableArray *) nSMutableArrayData;

// get path to the internal document storage on the device
+ (NSURL *)applicationDocumentsDirectory;

@end
