//
//  HCReflectController.h
//  HC
//
//  Created by tuibao on 2021/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCReflectController : BaseViewController

//可提现金额
@property(nonatomic , strong) NSString *CanCarry_amount;


//提现类型。空卡。收益。
@property(nonatomic , strong) NSString *Reflect_type;


@end

NS_ASSUME_NONNULL_END
