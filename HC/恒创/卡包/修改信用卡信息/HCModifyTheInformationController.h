//
//  HCModifyTheInformationController.h
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ModifyTheInformationBlock)(NSString *zdStr , NSString *hkStr);

@interface HCModifyTheInformationController : BaseViewController

//卡片id
@property (nonatomic , strong) NSString *CardID;

@property (nonatomic , copy) ModifyTheInformationBlock block;

///客户token
@property (nonatomic , strong) NSString *empowerToken;

@end

NS_ASSUME_NONNULL_END
