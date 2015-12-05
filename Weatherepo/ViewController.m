//
//  ViewController.m
//  Weatherepo
//
//  Created by Eswar Kuruba on 04/12/2015.
//  Copyright © 2015 Fresh Sprites. All rights reserved.
//

#import "ViewController.h"
#import "WeatherData.h"

#define CITY_LABEL_TAG 1

@interface ViewController (){
    
    NSInteger forecastDays;
    float currentTemperature;
    //TODO: change this to be handled through a singleton API for local and remote data
    WeatherData *theWeather;
}

@end

@implementation ViewController

static NSString *CellIdentifier = @"CellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // If previous weather info is stored locally, get the info and display as default
    // update complete weather info based on persistent data stored in previous run cycle
    // TODO fill data from local store if available or make a quick request and then load data
    
    // dummy logic to fill new data
    theWeather = [[WeatherData alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weatherUpdated:) name:@"WeatherUpdateNotification" object:nil];

    //handle current date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    NSLog(@"formattedDateString: %@", formattedDateString);

    self.cityText.enabled = NO;
    self.cityText.hidden = TRUE;
    
    forecastDays = 3;
   
    self.currTemperature.text = [NSString stringWithFormat:@"16"];
    currentTemperature = 16;
    self.city.text = @"Dusseldorf";
    
    self.currWeatherImage.image = [UIImage imageNamed:@"sun.png"];
    
    
  
    //TODO ensure calls to server are spaced at 10 min intervals so
    //update is visible
    
    [theWeather getCurrent:self.city.text];
 
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if(touch.view.tag == CITY_LABEL_TAG)
    {
        //show keyboard
        self.cityText.enabled = YES;
        self.cityText.hidden = FALSE;
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"You entered %@",self.cityText.text);
    [self.cityText resignFirstResponder];
    self.city.text = self.cityText.text;
    [theWeather getCurrent:self.cityText.text];
    
    return YES;
}

- (void)weatherUpdated:(NSNotification *)notification {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    NSLog(@"formattedDateString: %@", formattedDateString);
    NSString* weatherCond = theWeather.descMini;
    self.currWeather.text = [NSString stringWithFormat:@"%@     %@",formattedDateString,weatherCond];
    self.city.text = [NSString stringWithFormat:@"%@ , %@",theWeather.city,theWeather.country];
    self.currTemperature.text = [NSString stringWithFormat: @"%.2f", theWeather.tempCurrent];
    currentTemperature = theWeather.tempCurrent;
    self.currPrecipitation.text =
    [NSString stringWithFormat:@"Pressure: %ld mmHg",(long)theWeather.pressure];
    self.currHumidity.text =[NSString stringWithFormat:@"Humidity: %ld %%",(long)theWeather.humidity];
    
    
    if([weatherCond containsString:@"Clear"] ||[weatherCond isEqualToString:@"sunny"] )
        self.currWeatherImage.image = [UIImage imageNamed:@"sun"];
    
    else if([weatherCond isEqualToString:@"Drizzle"] ||[weatherCond containsString:@"Rain"] ||[weatherCond containsString:@"mist"] )
        self.currWeatherImage.image = [UIImage imageNamed:@"rain"];
    
    else if([weatherCond containsString:@"Cloud"] || [weatherCond containsString:@"Haze"] )
        self.currWeatherImage.image = [UIImage imageNamed:@"cloud"];
    
    
    self.cityText.hidden = TRUE;
    self.cityText.enabled = FALSE;
    
}


-(void)updateGUI{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    NSLog(@"formattedDateString: %@", formattedDateString);
    NSString* weatherCond = [theWeather.conditions description];
    self.currWeather.text = [NSString stringWithFormat:@"%@ , %@",formattedDateString,weatherCond];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)tempMetricChanged:(id)sender{
    
    if(self.currTemperatureCorF.selectedSegmentIndex == 0){
        currentTemperature = ((currentTemperature - 32) * 5.0)/9.0;
        self.currTemperature.text = [NSString stringWithFormat: @"%.2f",currentTemperature];
    }
    else if(self.currTemperatureCorF.selectedSegmentIndex == 1){
       
        currentTemperature = ((currentTemperature * 9.0)/5.0)+32;
        self.currTemperature.text = [NSString stringWithFormat: @"%.2f",currentTemperature];
    }
    
    [self.weatherForecast reloadData];
    
}



-(IBAction)forecastDurationChanged:(id)sender{

    if(self.forecastDuration.selectedSegmentIndex == 0){
        forecastDays = 3;
        self.currWeatherImage.image = [UIImage imageNamed:@"sun"];
    }
    else if(self.forecastDuration.selectedSegmentIndex == 1){
        forecastDays = 5;
        self.currWeatherImage.image = [UIImage imageNamed:@"rain"];
    }

    [self.weatherForecast reloadData];
    
  
    NSLog(@"Weather Report call:");
        [theWeather getCurrent:self.city.text];

}

#pragma mark UITableView Delegate methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    return forecastDays; //TODO return 3 or 5 or other value based on model data rt now only 3 or 5
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // TODO update cell info based on the data received and indexPath.row info
    
    cell.textLabel.text = @"FRI   Temp High : 20   Low : 9 ";
    cell.imageView.image = [UIImage imageNamed:@"sun"];
    
    if(self.forecastDuration.selectedSegmentIndex == 1){
            cell.textLabel.text = @"SAT  Temp High : 12  Low : 5 ";
            cell.imageView.image = [UIImage imageNamed:@"rain"];
    }
    
    return cell;
    
    
}


@end
