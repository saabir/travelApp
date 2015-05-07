//
//  AppUtility.m is a STATIC CLASS!!
//  TravelApp
//
//  Created by Asemota Stefan on 11.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "AppUtility.h"

@implementation AppUtility

+(BOOL) networkReachability
{  
    // initialize error
    NSError *error = nil;
    
    // define url to test
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]
                                                   encoding:NSASCIIStringEncoding error:nil];
    
    // check if url was accessible
    if(URLString==nil)
    {
        // url is not accessible
        NSLog(@"No Network!! %@",error);
    }
    
    // return true if network is accessible, false if not
    return ( URLString != NULL ) ? YES : NO;
}

+(void) printOutMutableArrayObjects:(NSMutableArray *) nSMutableArrayData{
    int count = [nSMutableArrayData count];
    NSLog(@"NSMutableArray Count: %d",count);
    //for (NSString *item in nSMutableArrayData) {
      //  NSLog(@"NSMutableArray Item: %@",item);
    //} 
}


+(void) printoutNsDataObjects:(NSData*) nsDataObjects{
    
}

// Returns the URL to the application's documents directory
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


// Instantiation of the class should return error as the class is intended to be used static
+ (id)alloc 
{   
    
    // raise error upon instantiation of this class
    [NSException raise:@"This class cannot be instantiated!" 
                format:@"Static class 'ClassName' cannot be instantiated!"];
    
    return nil;
}
@end
