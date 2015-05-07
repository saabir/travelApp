//
//  FlickrImageController.m
//  TravelApp
//
//  Created by Asemota Stefan on 16.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "FlickrImageController.h"

#pragma mark Interface Private Methods
@interface FlickrImageController(){

}
@end
// Replace with your Flickr key
NSString *const FlickrAPIKey = @"b65d8552b71f15b5caefe44f24b9c334";

@implementation FlickrImageController

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
-(void)searchFlickrPhotos:(NSString *)text
{
   
}

/**************************************************************************
 *
 * Class implementation section
 *
 **************************************************************************/

#pragma mark -
#pragma mark Initialization

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (id)init
{
    if (self = [super init])
    {
       
        
    }
	return self;
    
}

@end
