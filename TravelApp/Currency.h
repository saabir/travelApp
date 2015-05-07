//
//  Currency.h
//  TravelApp
//
//  Created by Asemota Stefan on 19.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country;

@interface Currency : NSManagedObject

@property (nonatomic, retain) NSString * conversion_factor;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * short_code;
@property (nonatomic, retain) NSSet *fkCountry;
@end

@interface Currency (CoreDataGeneratedAccessors)

- (void)addFkCountryObject:(Country *)value;
- (void)removeFkCountryObject:(Country *)value;
- (void)addFkCountry:(NSSet *)values;
- (void)removeFkCountry:(NSSet *)values;

@end
