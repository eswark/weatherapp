//
//  ViewController.h
//  Weatherepo
//
//  Created by Eswar Kuruba on 04/12/2015.
//  Copyright © 2015 Fresh Sprites. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) IBOutlet UITextField *cityText;
@property(nonatomic,strong) IBOutlet UILabel *city;
@property(nonatomic,strong) IBOutlet UILabel *currWeather;
@property(nonatomic,strong) IBOutlet UIImageView *currWeatherImage;
@property(nonatomic,strong) IBOutlet UILabel *currTemperature;
@property(nonatomic,strong) IBOutlet UISegmentedControl *currTemperatureCorF;

@property(nonatomic,strong) IBOutlet UILabel *currPrecipitation;
@property(nonatomic,strong) IBOutlet UILabel *currHumidity;
@property(nonatomic,strong) IBOutlet UILabel *currWindSpeed;

@property(nonatomic,strong) IBOutlet UISegmentedControl *forecastDuration;
@property(nonatomic,strong) IBOutlet UITableView *weatherForecast;

@property(nonatomic,strong) IBOutlet UILabel *copyrightInfo;


-(IBAction)forecastDurationChanged:(id)sender;
-(IBAction)tempMetricChanged:(id)sender;
@end

