//
//  Country.h
//  TravelApp
//
//  Created by Asemota Stefan on 20.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Airport, Country_attributes, Currency, Weather;

@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * capital;
@property (nonatomic, retain) NSString * continent;
@property (nonatomic, retain) NSString * iso_code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSSet *fkAirports;
@property (nonatomic, retain) NSSet *fkCountryAttributes;
@property (nonatomic, retain) NSSet *fkCurrency;
@property (nonatomic, retain) NSSet *fkWeather;
@end

@interface Country (CoreDataGeneratedAccessors)

- (void)addFkAirportsObject:(Airport *)value;
- (void)removeFkAirportsObject:(Airport *)value;
- (void)addFkAirports:(NSSet *)values;
- (void)removeFkAirports:(NSSet *)values;

- (void)addFkCountryAttributesObject:(Country_attributes *)value;
- (void)removeFkCountryAttributesObject:(Country_attributes *)value;
- (void)addFkCountryAttributes:(NSSet *)values;
- (void)removeFkCountryAttributes:(NSSet *)values;

- (void)addFkCurrencyObject:(Currency *)value;
- (void)removeFkCurrencyObject:(Currency *)value;
- (void)addFkCurrency:(NSSet *)values;
- (void)removeFkCurrency:(NSSet *)values;

- (void)addFkWeatherObject:(Weather *)value;
- (void)removeFkWeatherObject:(Weather *)value;
- (void)addFkWeather:(NSSet *)values;
- (void)removeFkWeather:(NSSet *)values;

@end
