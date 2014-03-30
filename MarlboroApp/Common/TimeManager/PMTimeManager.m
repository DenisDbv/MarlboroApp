//
//  PMTimeManager.m
//  ParlamentApp
//
//  Created by DenisDbv on 22.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMTimeManager.h"

//4-10 утро
//11-16 день
//17-23 вечер

@implementation PMTimeManager

-(NSString*) titleTimeArea
{
    return [self timeAreaName:[self timeArea]];
}

-(TimeArea) timeArea
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSInteger hour = [components hour];
    //NSInteger minute = [components minute];
    
    if(hour >= 4 && hour <= 10)
    {
        NSLog(@"Утро");
        return tMorning;
    }
    
    if(hour >= 11 && hour <= 16)
    {
        NSLog(@"День");
        return tDinner;
    }
    
    if(hour >= 17 && hour <= 23)
    {
        NSLog(@"Вечер");
        return tEvening;
    }
    
    if(hour >= 0 && hour < 4)
    {
        NSLog(@"Ночь");
        return tNight;
    }
    
    return tNone;
}

-(NSString*) timeAreaName:(TimeArea)timeArea
{
    switch (timeArea) {
        case 1:
            return @"ПРИЯТНОГО УТРА";
            break;
        case 2:
            return @"ПРИЯТНОГО ДНЯ";
            break;
        case 3:
            return @"ПРИЯТНОГО ВЕЧЕРА";
            break;
        case 4:
            return @"ПРИЯТНОЙ НОЧИ";
            break;
            
        default:
            break;
    }
    
    return @"";
}

@end
