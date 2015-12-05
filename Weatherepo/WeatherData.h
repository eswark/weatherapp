//
//  WeatherData.h
//  Weatherepo
//
//  Created by Eswar Kuruba on 04/12/2015.
//  Copyright © 2015 Fresh Sprites. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherData : NSObject

// Properties
// ==========

// Place and time
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *country;
@property (nonatomic, readonly) CGFloat latitude;
@property (nonatomic, readonly) CGFloat longitude;
@property (nonatomic, copy, readonly) NSDate *reportTime;
@property (nonatomic, copy, readonly) NSDate *sunrise;
@property (nonatomic, copy, readonly) NSDate *sunset;

// Qualitative
@property (nonatomic, copy, readonly) NSArray *conditions;
@property (nonatomic, copy, readonly) NSString *descMini;
@property (nonatomic, copy, readonly) NSString *descMain;
// Quantitative
@property (nonatomic, readonly) NSInteger cloudCover;
@property (nonatomic, readonly) NSInteger humidity;
@property (nonatomic, readonly) NSInteger pressure;
@property (nonatomic, readonly) NSInteger rain3hours;
@property (nonatomic, readonly) NSInteger snow3hours;
@property (nonatomic, readonly) CGFloat tempCurrent;
@property (nonatomic, readonly) CGFloat tempMin;
@property (nonatomic, readonly) CGFloat tempMax;
@property (nonatomic, readonly) NSInteger windDirection;
@property (nonatomic, readonly) CGFloat windSpeed;

// Methods
// =======

- (void)getCurrent:(NSString *)query;

@end
