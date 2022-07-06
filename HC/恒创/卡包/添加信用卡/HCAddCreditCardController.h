//
//  HCAddCreditCardController.h
//  HC
//
//  Created by tuibao on 2021/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCAddCreditCardController : BaseViewController
///客户名称
@property (nonatomic , strong) NSString *customer_Name;
///客户token
@property (nonatomic , strong) NSString *empowerToken;

@end

NS_ASSUME_NONNULL_END
