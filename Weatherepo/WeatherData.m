//
//  WeatherData.m
//  Weatherepo
//
//  Created by Eswar Kuruba on 04/12/2015.
//  Copyright © 2015 Fresh Sprites. All rights reserved.
//

#import "WeatherData.h"
#import "AFNetworking.h"

@implementation WeatherData {
    NSDictionary *weatherServiceResponse;
}

- (id)init
{
    self = [super init];
    weatherServiceResponse = @{};
    return self;
}


- (void)getCurrent:(NSString *)query
{
    
    //http://api.openweathermap.org/data/2.5/forecast/city?id=524901&APPID=5fbf6eed67fc87f4ac297363aa07406e
    
    NSString *BASE_URL_STRING = @"http://api.openweathermap.org/data/2.5/weather";
    NSString *appId = @"APPID=5fbf6eed67fc87f4ac297363aa07406e";
    NSString *weatherURLText = [NSString stringWithFormat:@"%@?q=%@&%@",
                                BASE_URL_STRING, query, appId];
    NSURL *weatherURL = [NSURL URLWithString:weatherURLText];
   
    //TODO: call async and load data in bgnd thread then call ui update on main thread
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:weatherURL.absoluteString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data !=NULL)
        {
            NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"data is :%@",strData);
            weatherServiceResponse = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
            [self parseWeatherServiceResponse];
        }
        
    }] resume];
    
}

- (void)parseWeatherServiceResponse
{
    //TODO error handling on null 
    
    NSLog(@"Parsing...");
    // clouds
    _cloudCover = [weatherServiceResponse[@"clouds"][@"all"] integerValue];
    
    // coord
    _latitude = [weatherServiceResponse[@"coord"][@"lat"] doubleValue];
    _longitude = [weatherServiceResponse[@"coord"][@"lon"] doubleValue];
    
    // dt
    _reportTime = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"dt"] doubleValue]];
    
    // main
    _humidity = [weatherServiceResponse[@"main"][@"humidity"] integerValue];
    _pressure = [weatherServiceResponse[@"main"][@"pressure"] integerValue];
    _tempCurrent = [WeatherData kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp"] doubleValue]];
    _tempMin = [WeatherData kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp_min"] doubleValue]];
    _tempMax = [WeatherData kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp_max"] doubleValue]];
    
    // name
    _city = weatherServiceResponse[@"name"];
    
    // rain
    _rain3hours = [weatherServiceResponse[@"rain"][@"3h"] integerValue];
    
    // snow
    _snow3hours = [weatherServiceResponse[@"snow"][@"3h"] integerValue];
    
    // sys
    _country = weatherServiceResponse[@"sys"][@"country"];
    _sunrise = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"sys"][@"sunrise"] doubleValue]];
    _sunset = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"sys"][@"sunset"] doubleValue]];
    
    // weather
    _conditions = weatherServiceResponse[@"weather"];
    /*
     * weather section of the response is an array of
     * dictionary objects. The first object in the array
     * contains the desired weather information.
     */
    NSArray* weather = _conditions;
    if ([weather count] > 0) {
        NSDictionary* weatherData = [weather objectAtIndex:0];
        if (weatherData) {
            NSString *status = weatherData[@"main"];
            if (status) {
                _descMini = status;
            }
            
            NSString *condition = weatherData[@"description"];
            if (condition) {
                _descMain = condition;
            }
        }
    }
    
    // wind
    _windDirection = [weatherServiceResponse[@"wind"][@"dir"] integerValue];
    _windSpeed = [weatherServiceResponse[@"wind"][@"speed"] doubleValue];
    
    //now update values in view
    //post notification
    dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WeatherUpdateNotification" object:self];
    });
}

+ (double)kelvinToCelsius:(double)degreesKelvin
{
    const double ZERO_CELSIUS_IN_KELVIN = 273.15;
    return degreesKelvin - ZERO_CELSIUS_IN_KELVIN;
}

@end