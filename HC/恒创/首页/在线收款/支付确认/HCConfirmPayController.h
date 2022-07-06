//
//  HCConfirmPayController.h
//  HC
//
//  Created by tuibao on 2021/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCConfirmPayController : BaseViewController

//刷卡请求参数
@property (nonatomic , strong) NSMutableDictionary *params;

//是否选择城市
@property (nonatomic , strong) NSString *needCity;
//是否发送验证码
@property (nonatomic , strong) NSString *needCode;

@end

NS_ASSUME_NONNULL_END
