//
//  CsvImportOperation.h
//  TravelApp
//
//  Created by Asemota Stefan on 21.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TravelAppCsvParser.h"

@interface CsvImportOperation : NSOperation{
    // In concurrent operations, we have to manage the operation's state
    BOOL executing_;
    BOOL finished_;
    NSError* error;
}

@property (nonatomic, retain,readwrite) NSError* error;

// Create a new operation to make a series of records
- (id)initCsvOperation;
@end
