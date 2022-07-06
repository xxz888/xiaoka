//
//  HCCreditListController.h
//  HC
//
//  Created by tuibao on 2021/11/12.
//

#import <UIKit/UIKit.h>

typedef void(^HCCreditListBlock)(NSDictionary * _Nullable dataDic);

NS_ASSUME_NONNULL_BEGIN

@interface HCCreditListController : BaseViewController

@property (nonatomic , copy) HCCreditListBlock block;

@end

NS_ASSUME_NONNULL_END
