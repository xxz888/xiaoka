//
//  HCAddModificationController.h
//  HC
//
//  Created by tuibao on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AddModificationblock)(void);

@interface HCAddModificationController : BaseViewController

@property (nonatomic , strong) NSString *typeStr;

@property (nonatomic , strong) NSString *zhanghao;

@property (nonatomic , strong) AddModificationblock block;


@end

NS_ASSUME_NONNULL_END
