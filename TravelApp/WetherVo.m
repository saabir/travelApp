//
//  WetherVo.m
//  TravelApp
//
//  Created by Asemota Stefan on 20.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "WetherVo.h"

@implementation WetherVo

@synthesize months = months_;
@synthesize tempretureMax = tempretureMax_;
@synthesize tempretureMin = tempretureMin_;
@synthesize rain = rain;


-(id)initWithWeatherValues:(NSMutableArray*)weatherMonths 
         withTempretureMax:(NSString*) tempMax 
               withTempMin:(NSString*) tempMin 
                  withRain:(NSString*) precipi{
    
    self = [super init];
    // init the months
    self.months = weatherMonths;
    self.tempretureMax = tempMax;
    self.tempretureMin = tempMin;
    self.rain = precipi;
    return self;  
}

@end
