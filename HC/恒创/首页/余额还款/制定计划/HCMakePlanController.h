//
//  HCMakePlanController.h
//  HC
//
//  Created by tuibao on 2021/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCMakePlanController : BaseViewController
//信用卡信息
@property (nonatomic , strong) NSMutableDictionary *cardData;

///客户名称
@property (nonatomic , strong) NSString *customer_Name;
///客户token
@property (nonatomic , strong) NSString *empowerToken;

@end

NS_ASSUME_NONNULL_END
