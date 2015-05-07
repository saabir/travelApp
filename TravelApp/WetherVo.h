//
//  WetherVo.h
//  TravelApp
//
//  Created by Asemota Stefan on 20.03.12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WetherVo : NSObject{
    NSString * tempretureMax;
    NSString * tempretureMin;
    NSString * rain;
    NSMutableDictionary * months;
}
@property (nonatomic, retain) NSMutableArray * months;
@property (nonatomic, retain) NSString * tempretureMax;
@property (nonatomic, retain) NSString * tempretureMin;
@property (nonatomic, retain) NSString * rain;

// This init method
-(id)initWithWeatherValues:(NSMutableArray*)weatherMonths 
                                withTempretureMax:(NSString*) tempMax 
                                withTempMin:(NSString*) tempMin 
                                withRain:(NSString*) precipi;

@end
