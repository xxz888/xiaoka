//
//  CreditCardToCardVC.h
//  HC
//
//  Created by tuibao on 2022/5/26.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CreditCardToCardBlock)(NSString *str);

@interface CreditCardToCardVC : BaseViewController

//信用卡信息
@property (nonatomic , strong) NSDictionary *cardData;

@property (nonatomic , copy) CreditCardToCardBlock block;

///通道ID
@property (nonatomic , strong) NSString *channelId;




@end

NS_ASSUME_NONNULL_END
