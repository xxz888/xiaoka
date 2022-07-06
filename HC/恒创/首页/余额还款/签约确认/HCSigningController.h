//
//  HCSigningController.h
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HCSigningBlock)(NSString *str);

@interface HCSigningController : BaseViewController

//信用卡信息
@property (nonatomic , strong) NSDictionary *cardData;

@property (nonatomic , copy) HCSigningBlock block;

///客户名称
@property (nonatomic , strong) NSString *customer_Name;
///客户token
@property (nonatomic , strong) NSString *empowerToken;

@end

NS_ASSUME_NONNULL_END
