//
//  HCModifySavingsCardController.h
//  HC
//
//  Created by tuibao on 2021/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ModifySavingsCardBlock)(NSString *cardNo , NSString *phone);

@interface HCModifySavingsCardController : BaseViewController

//卡片id
@property (nonatomic , strong) NSString *CardID;

@property (nonatomic , copy) ModifySavingsCardBlock block;
///需要修改的储蓄卡数据
@property (nonatomic , strong) NSDictionary *data;

///客户token
@property (nonatomic , strong) NSString *empowerToken;
///客户身份证号码
@property (nonatomic , strong) NSString *customer_idCard;

@end

NS_ASSUME_NONNULL_END
