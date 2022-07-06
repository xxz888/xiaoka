//
//  HCMallBuyNowView.h
//  HC
//
//  Created by tuibao on 2021/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCMallBuyNowView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)ShowView;
- (void)disMissView;

///距离顶部的距离
@property (nonatomic, assign) CGFloat top_H;

///商品图片
@property (strong , nonatomic) UIImageView *goods_image;
///商品名称
@property (strong , nonatomic) UILabel *goods_name;
///商品券后价
@property (strong , nonatomic) UILabel *goods_vouchersAfter_price;

@property (strong , nonatomic) UIView *line;

///购买数量
@property (strong , nonatomic) UILabel *BuyNow_number_lab;
///减
@property (strong , nonatomic) UILabel *ReductionOf_number;
///购买数量
@property (strong , nonatomic) UILabel *BuyNow_number;
///加
@property (strong , nonatomic) UILabel *add_number;
///立即购买
@property (strong , nonatomic) UIButton *finishBtn;

@end

NS_ASSUME_NONNULL_END
