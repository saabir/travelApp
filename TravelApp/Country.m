//
//  Country.m
//  TravelApp
//
//  Created by Asemota Stefan on 20.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "Country.h"
#import "Airport.h"
#import "Country_attributes.h"
#import "Currency.h"
#import "Weather.h"


@implementation Country

@dynamic capital;
@dynamic continent;
@dynamic iso_code;
@dynamic name;
@dynamic latitude;
@dynamic longitude;
@dynamic fkAirports;
@dynamic fkCountryAttributes;
@dynamic fkCurrency;
@dynamic fkWeather;

@end
