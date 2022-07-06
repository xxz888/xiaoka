//
//  HCMallShippingAddressController.h
//  HC
//
//  Created by tuibao on 2021/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HCMallShippingAddressBlock)(NSDictionary * _Nullable dataDic);

@interface HCMallShippingAddressController : BaseViewController

@property (nonatomic , copy) HCMallShippingAddressBlock block;

@end

NS_ASSUME_NONNULL_END
