//
//  HCSavingsListController.h
//  HC
//
//  Created by tuibao on 2021/11/12.
//

#import <UIKit/UIKit.h>

typedef void(^HCSavingsListBlock)(NSDictionary * _Nullable dataDic);

NS_ASSUME_NONNULL_BEGIN

@interface HCSavingsListController : BaseViewController


@property (nonatomic , copy) HCSavingsListBlock block;

@end

NS_ASSUME_NONNULL_END
