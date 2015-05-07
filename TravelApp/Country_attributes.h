//
//  Country_attributes.h
//  TravelApp
//
//  Created by Asemota Stefan on 11.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Country_attributes : NSManagedObject

@property (nonatomic, retain) NSNumber * sorting;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSManagedObject *fkCountry;

@end
