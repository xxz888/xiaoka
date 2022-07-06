//
//  HCPlanDetailsController.h
//  HC
//
//  Created by tuibao on 2021/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCPlanDetailsController : BaseViewController

//信用卡信息 必传
@property (nonatomic , strong) NSDictionary *cardData;

//以下两个参数必传一个
///计划ID
@property (nonatomic , strong) NSString *planIDStr;
/// 制定计划详情 数据
@property (nonatomic , strong) NSDictionary *MakePlanData;

///客户名称
@property (nonatomic , strong) NSString *customer_Name;
///客户token
@property (nonatomic , strong) NSString *empowerToken;



@end

NS_ASSUME_NONNULL_END
