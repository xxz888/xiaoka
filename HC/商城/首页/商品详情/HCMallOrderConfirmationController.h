//
//  HCMallOrderConfirmationController.h
//  HC
//
//  Created by tuibao on 2021/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCMallOrderConfirmationController : BaseViewController

///收货人
@property (weak, nonatomic) IBOutlet UILabel *TheConsignee_lab;
@property (weak, nonatomic) IBOutlet UIView *address_view;
///收货地址
@property (weak, nonatomic) IBOutlet UILabel *TheAddress_lab;
///商品图片
@property (weak, nonatomic) IBOutlet UIImageView *goods_image;
///商品名称
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
///商品数量
@property (weak, nonatomic) IBOutlet UILabel *goods_number;
///商品总价格
@property (weak, nonatomic) IBOutlet UILabel *goods_TheTotalPrice;
///优惠券抵扣
@property (weak, nonatomic) IBOutlet UILabel *goods_coupons;
///合计金额
@property (weak, nonatomic) IBOutlet UILabel *goods_ACombined;
///备注
@property (weak, nonatomic) IBOutlet UITextView *goods_note;
///提交订单
@property (weak, nonatomic) IBOutlet UIButton *submit_order;

///商品详情数据
@property (nonatomic , strong) NSDictionary *goodsDic;

///商品数量
@property (nonatomic , assign) NSInteger number;

@end

NS_ASSUME_NONNULL_END
