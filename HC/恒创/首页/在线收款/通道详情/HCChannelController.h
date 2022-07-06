//
//  HCChannelController.h
//  HC
//
//  Created by tuibao on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCChannelController : BaseViewController

//刷卡金额
@property (nonatomic , strong) NSString *amount;
//信用卡信息
@property (nonatomic , strong) NSDictionary *CreditData;
//储蓄卡信息
@property (nonatomic , strong) NSDictionary *CashData;


@end

NS_ASSUME_NONNULL_END
