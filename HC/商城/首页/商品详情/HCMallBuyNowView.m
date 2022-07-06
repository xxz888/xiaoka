//
//  HCMallBuyNowView.m
//  HC
//
//  Created by tuibao on 2021/12/23.
//

#import "HCMallBuyNowView.h"
@interface HCMallBuyNowView()

@property (nonatomic , strong) UIView *contentView;

@property (nonatomic , assign) NSInteger number;

@end

@implementation HCMallBuyNowView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
        [self bk_whenTapped:^{
            [self disMissView];
        }];
        
        self.number = 1;
        
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.goods_image];
        [self.contentView addSubview:self.goods_name];
        [self.contentView addSubview:self.goods_vouchersAfter_price];
        
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.BuyNow_number_lab];
        [self.contentView addSubview:self.ReductionOf_number];
        [self.contentView addSubview:self.BuyNow_number];
        [self.contentView addSubview:self.add_number];
        
        [self.contentView addSubview:self.finishBtn];
        
        
        [self LoadUI];
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
}
- (void)LoadUI{
    [self.contentView bk_whenTapped:^{
            
    }];
    [self.goods_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.top.offset(15);
        make.left.offset(10);
    }];
    
    [self.goods_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.left.equalTo(self.goods_image.mas_right).offset(10);
        make.right.offset(-10);
    }];
    
    [self.goods_vouchersAfter_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goods_name.mas_bottom).offset(15);
        make.left.equalTo(self.goods_image.mas_right).offset(10);
        make.right.offset(-10);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 30, 0.5));
        make.top.equalTo(self.goods_image.mas_bottom).offset(30);
        make.left.offset(15);
    }];
    
    [self.BuyNow_number_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.equalTo(self.line.mas_bottom).offset(30);
        make.left.offset(15);
    }];
    
    [self.add_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.equalTo(self.BuyNow_number_lab);
        make.right.offset(-25);
    }];
    
    [self.BuyNow_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(25);
        make.width.offset(25);
        make.centerY.equalTo(self.BuyNow_number_lab);
        make.right.equalTo(self.add_number.mas_left).offset(0.5);
    }];
    
    [self.ReductionOf_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.equalTo(self.BuyNow_number_lab);
        make.right.equalTo(self.BuyNow_number.mas_left).offset(0.5);
    }];
    @weakify(self);
    [self.add_number bk_whenTapped:^{
        weak_self.number++;
        weak_self.BuyNow_number.text = [NSString stringWithFormat:@"%li",weak_self.number];
    }];
    [self.ReductionOf_number bk_whenTapped:^{
        if (weak_self.number > 1) {
            weak_self.number--;
            weak_self.BuyNow_number.text = [NSString stringWithFormat:@"%li",weak_self.number];
        }
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 46));
        make.left.offset(15);
        make.bottom.offset(-15-KBottomHeight);
    }];
    
}

- (void)ShowView{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.contentView.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT - _top_H);
    @weakify(self);
    [UIView animateWithDuration:.3f animations:^{
        weak_self.contentView.frame = CGRectMake(0, weak_self.top_H, DEVICE_WIDTH, DEVICE_HEIGHT - weak_self.top_H);
    }];
    CGFloat radius = 16.0; // 圆角大小
    UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight; // 圆角位置
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = path.CGPath;
    self.contentView.layer.mask = maskLayer;
    
}


- (void)disMissView{
    
    self.contentView.frame = CGRectMake(0, _top_H, DEVICE_WIDTH, DEVICE_HEIGHT - _top_H);
    @weakify(self);
    [UIView animateWithDuration:.3f animations:^{
        weak_self.contentView.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT - weak_self.top_H);
    }
    completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma 懒加载
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UIImageView *)goods_image{
    if (!_goods_image) {
        _goods_image = [UIImageView getUIImageView:@"mall_Placeholder_image"];
        _goods_image.contentMode = UIViewContentModeScaleToFill;
    }
    return _goods_image;
}

- (UILabel *)goods_name{
    if (!_goods_name) {
        _goods_name = [UILabel new];
        _goods_name.text = @"商品名称";
        _goods_name.font = [UIFont getUIFontSize:18 IsBold:YES];
        _goods_name.textColor = [UIColor colorWithHexString:@"#000000"];
    }
    return _goods_name;
}
- (UILabel *)goods_vouchersAfter_price{
    if (!_goods_vouchersAfter_price) {
        _goods_vouchersAfter_price = [UILabel getUILabelText:@"￥0.00" TextColor:[UIColor colorWithHexString:@"#FF8100"] TextFont:[UIFont getUIFontSize:18 IsBold:NO] TextNumberOfLines:0];
        _goods_vouchersAfter_price.backgroundColor = [UIColor whiteColor];
    }
    return _goods_vouchersAfter_price;
}

- (UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }
    return _line;
}

- (UILabel *)BuyNow_number_lab{
    if (!_BuyNow_number_lab) {
        _BuyNow_number_lab = [UILabel getUILabelText:@"购买数量" TextColor:[UIColor colorWithHexString:@"#000000"] TextFont:[UIFont getUIFontSize:14 IsBold:YES] TextNumberOfLines:0];
    }
    return _BuyNow_number_lab;
}

- (UILabel *)ReductionOf_number{
    if (!_ReductionOf_number) {
        _ReductionOf_number = [UILabel getUILabelText:@"-" TextColor:[UIColor colorWithHexString:@"#000000"] TextFont:[UIFont getUIFontSize:14 IsBold:NO] TextNumberOfLines:0];
        _ReductionOf_number.layer.masksToBounds = YES;
        _ReductionOf_number.layer.borderColor = [UIColor colorWithHexString:@"#CDCDCD"].CGColor;
        _ReductionOf_number.layer.borderWidth = 0.5;
        _ReductionOf_number.textAlignment = NSTextAlignmentCenter;
        _ReductionOf_number.userInteractionEnabled = YES;
    }
    return _ReductionOf_number;
}

- (UILabel *)BuyNow_number{
    if (!_BuyNow_number) {
        _BuyNow_number = [UILabel getUILabelText:@"1" TextColor:[UIColor colorWithHexString:@"#000000"] TextFont:[UIFont getUIFontSize:14 IsBold:YES] TextNumberOfLines:0];
        _BuyNow_number.layer.masksToBounds = YES;
        _BuyNow_number.layer.borderColor = [UIColor colorWithHexString:@"#CDCDCD"].CGColor;
        _BuyNow_number.layer.borderWidth = 0.5;
        _BuyNow_number.textAlignment = NSTextAlignmentCenter;
    }
    return _BuyNow_number;
}

- (UILabel *)add_number{
    if (!_add_number) {
        _add_number = [UILabel getUILabelText:@"+" TextColor:[UIColor colorWithHexString:@"#000000"] TextFont:[UIFont getUIFontSize:14 IsBold:NO] TextNumberOfLines:0];
        _add_number.layer.masksToBounds = YES;
        _add_number.layer.borderColor = [UIColor colorWithHexString:@"#CDCDCD"].CGColor;
        _add_number.layer.borderWidth = 0.5;
        _add_number.textAlignment = NSTextAlignmentCenter;
        _add_number.userInteractionEnabled = YES;
        
    }
    return _add_number;
}

- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton new];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"KD_BindCardBtn"] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont getUIFontSize:13 IsBold:YES];
    }
    return _finishBtn;
}




@end
