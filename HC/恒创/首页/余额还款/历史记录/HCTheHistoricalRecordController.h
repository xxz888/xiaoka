//
//  HCTheHistoricalRecordController.h
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCTheHistoricalRecordController : BaseViewController
//信用卡信息
@property (nonatomic , strong) NSDictionary *cardData;

///客户token
@property (nonatomic , strong) NSString *empowerToken;

@end

NS_ASSUME_NONNULL_END
