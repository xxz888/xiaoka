//
//  WSDatePickerView.h
//  WSDatePicker
//
//  Created by iMac on 17/2/23.
//  Copyright © 2017年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+hfx.h"

/**
 *  弹出日期类型
 */
typedef enum{
    DateStyleShowYearMonthDayHourMinute  = 0,///年月日时分
    DateStyleShowMonthDayHourMinute,///月日时分
    DateStyleShowYearMonthDay,///年月日
    DateStyleShowMonthDay,///月日
    DateStyleShowHourMinute,///时分
    DateStyleShowMonthDayWeekHourMinute,///月日星期时分
    /////
    DateStyleShowHourPMAM,///年月日上午下午
    DateStyleShowMonth,///年月
    DateStyleShowWeekly,//周
    DateStyleShowMM,//月
    DateStyleShowDD,//日
    DateStyleShowYear,///年
    DateStyleShowOtherString///显示其他字符串数组（单一）
}WSDateStyle;


@interface WSDatePickerView : UIView

/**
 *  确定按钮颜色
 */
@property (nonatomic,strong)UIColor *doneButtonColor;
/**
 *  年-月-日-时-分 文字颜色(默认橙色)
 */
@property (nonatomic,strong)UIColor *dateLabelColor;
/**
 *  滚轮日期颜色(默认黑色)
 */
@property (nonatomic,strong)UIColor *datePickerColor;

/**
 * 如果需要显示指定的数组，需要传一个数组
 */
@property (nonatomic,strong) NSArray * MyearArray;

/**
 * 字典的key
 */
@property (nonatomic,strong) NSString * DicKey;
/**
 *  限制最大时间（默认2099）datePicker大于最大日期则滚动回最大限制日期
 */
@property (nonatomic, retain) NSDate *maxLimitDate;
/**
 *  限制最小时间（默认0） datePicker小于最小日期则滚动回最小限制日期
 */
@property (nonatomic, retain) NSDate *minLimitDate;

/**
 *  大号年份字体颜色(默认灰色)想隐藏可以设置为clearColor
 */
@property (nonatomic, retain) UIColor *yearLabelColor;

/**
 *  手动设置 大号年份字
 */
@property (nonatomic, strong) NSString *showYearViewMax;



/**
 默认滚动到当前时间
 */
-(instancetype)initWithDateStyle:(WSDateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate * Data , NSString * Str , id OtherString))completeBlock;

/**
 滚动到指定的的日期
 */
-(instancetype)initWithDateStyle:(WSDateStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(void(^)(NSDate * Data , NSString * Str , id OtherString))completeBlock;


-(void)show;


@end

