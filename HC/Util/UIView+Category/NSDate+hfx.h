//
//  NSDate+hfx.h
//  沃尔讯
//
//  Created by fuxinto on 2017/5/25.
//  Copyright © 2017年 fuxinto. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_MINUTE    60
#define D_HOUR        3600
#define D_DAY        86400
#define D_WEEK        604800
#define D_YEAR        31556926

typedef NS_ENUM(NSUInteger, DateType) {
    DateTypeYMD,
    DateTypeHms,
    DateTypeYMDHms
};
@interface NSDate (hfx)
/**
 *  判断是否为昨天
 */
- (BOOL)isYesterday;

/**
 *  判断是否为今天
 */
- (BOOL)isToday;

/**
 *  判断是否为今年
 */
- (BOOL)isThisYear;

//比较日期与当前日期的大小（日期格式为yyyy-MM-dd）
+ (NSInteger)comparewithDate:(NSString*)bDate;

/**
 获取前2个月时间
 @return 日期字符串
 */
+ (NSString *)getBefore;

+ (NSString *)getBeforeWithYear:(NSInteger)year;
+ (NSString *)getBeforeWithMonth:(NSInteger)month;
+ (NSString *)getBeforeWithDay:(NSInteger)day;
/**
 获取当前时间
 
 @param type 返回的时间格式，时分秒/年月日/年月日时分秒
 @return 当前时间
 */
+ (NSString *)GetCurrentDateType: (DateType)type;

//计算两个日期之间的天数
+ (NSInteger)calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate;



+ (NSString *)getCurrentWithFormat:(NSString *)format;
/**
 *  时间戳返回时间
 */
+ (NSString *)timeStr:(long long)timestamp;
/**
 比较两个时间之间的时间差
 
 @param type 传入的时间类型
 @param startTime 开始时间
 @param endTime 结束时间
 @return 差值字符串 根据需求修改
 */
+ (NSString *)dateTimeDifferenceWithType: (DateType)type startTime:(NSString *)startTime endTime:(NSString *)endTime;


//通过时间戳计算时间差（几小时前、几天前）
+ (NSString *) compareCurrentTime:(NSTimeInterval) compareDate;

//通过时间戳得出显示时间
+ (NSString *) getDateStringWithTimestamp:(NSTimeInterval)timestamp;

//通过时间戳和格式显示时间
+ (NSString *) getStringWithTimestamp:(NSTimeInterval)timestamp formatter:(NSString*)formatter;
//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date WithFormat:(NSString *)format;

//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)string WithFormat:(NSString *)format;

//获取传入日期的开始日期和结束日期
+ (NSArray *)getCurrentWeekBeginDate:(NSDate *)date;
//获取传入日期年的开始日期和结束日期
+ (NSArray *)getCurrentYearBeginDate:(NSDate *)date;
//获取传入日期季度的开始日期和结束日期
+ (NSArray *)getCurrentQuarterBeginDate:(NSDate *)date;
//获取传入日期月的开始日期和结束日期
+ (NSArray *)getCurrentMonthBeginDate:(NSDate *)date;


///另一个文件与这个文件方法名同
+ (NSCalendar *) currentCalendar; // avoid bottlenecks

// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;
+ (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format;

// Short string utilities
- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle;
- (NSString *) stringWithFormat: (NSString *) format;
@property (nonatomic, readonly) NSString *shortString;
@property (nonatomic, readonly) NSString *shortDateString;
@property (nonatomic, readonly) NSString *shortTimeString;
@property (nonatomic, readonly) NSString *mediumString;
@property (nonatomic, readonly) NSString *mediumDateString;
@property (nonatomic, readonly) NSString *mediumTimeString;
@property (nonatomic, readonly) NSString *longString;
@property (nonatomic, readonly) NSString *longDateString;
@property (nonatomic, readonly) NSString *longTimeString;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;

- (BOOL) isTomorrow;

- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;

- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisMonth;
- (BOOL) isNextMonth;
- (BOOL) isLastMonth;

- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isNextYear;
- (BOOL) isLastYear;

- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;

- (BOOL) isInFuture;
- (BOOL) isInPast;

// Date roles
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;

// Adjusting dates
- (NSDate *) dateByAddingYears: (NSInteger) dYears;
- (NSDate *) dateBySubtractingYears: (NSInteger) dYears;
- (NSDate *) dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths;
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;

// Date extremes
- (NSDate *) dateAtStartOfDay;
- (NSDate *) dateAtEndOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;

- (NSDate *)dateWithYMD;
- (NSDate *)dateWithFormatter:(NSString *)formatter;
@end
