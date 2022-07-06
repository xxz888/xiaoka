//
//  HCCustomerCardController.h
//  HC
//
//  Created by tuibao on 2021/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCCustomerCardController : BaseViewController

///客户token
@property (nonatomic , strong) NSString *empowerToken;
///客户名称
@property (nonatomic , strong) NSString *customer_Name;
///客户身份证号码
@property (nonatomic , strong) NSString *customer_idCard;

@end

NS_ASSUME_NONNULL_END
