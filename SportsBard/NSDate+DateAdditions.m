//
//  DateAdditions.m
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+DateAdditions.h"

@implementation NSDate (MotoAdditions)

- (NSDate *)startOfWeek {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [cal components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    [components setWeekday:(-[components weekday] + 1)];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    
    NSDate *weekStart = [cal dateByAddingComponents:components toDate:[NSDate date] options:0];
    return weekStart;
}

- (NSDate *)startOfDay {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    
    //Create the start of today (midnight);
    NSDate *dayStart = [cal dateByAddingComponents:components toDate:[NSDate date] options:0]; 
    return dayStart;
}

@end