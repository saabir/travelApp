//
//  FlickrImageController.h
//  TravelApp
//
//  Created by Asemota Stefan on 16.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrImageController : NSObject{
    NSMutableArray  *photoTitles;         // Titles of images
    NSMutableArray  *photoSmallImageData; // Image data (thumbnail)
    NSMutableArray  *photoURLsLargeImage; // URL to larger image 
}

@end
