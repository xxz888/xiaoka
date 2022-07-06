//
//  HCStatementView.m
//  HC
//
//  Created by tuibao on 2021/11/25.
//

#import "HCStatementView.h"

@implementation HCStatementView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
    
    [self.clean_btn setEnlargeEdgeWithTop:0 right:0 bottom:30 left:30];
    self.clean_btn.layer.masksToBounds = YES;
    self.clean_btn.layer.cornerRadius = 12;
    [self.clean_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.right.top.offset(0);
    }];
    self.bg_view.layer.cornerRadius = 10;
    [self.bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.frame.size.width - 20);
        make.top.left.offset(10);
        make.right.offset(-10);
        make.bottom.offset(-10);
    }];
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.centerX.equalTo(self.bg_view);
        make.top.offset(30);
    }];
    
    [self.bg_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
    }];
    
    
    [self.conent_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title_lab.mas_bottom).offset(20);
        make.left.equalTo(self.bg_image.mas_left).offset(20);
        make.right.equalTo(self.bg_image.mas_right).offset(-20);
        make.bottom.equalTo(self.bg_view.mas_bottom).offset(-20);
    }];
    
    self.conent_view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.conent_view.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
    self.conent_view.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
    self.conent_view.layer.shadowRadius = 3;// 阴影半径，默认3
    self.conent_view.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    self.conent_view.layer.cornerRadius = 10;
    
    [self.order_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.top.offset(15);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    
    
    [self.jine_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.top.equalTo(self.order_lab.mas_bottom);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    
    double W = (DEVICE_WIDTH - 130) / 2;
    
    [self.shouxufei_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(W);
        make.height.offset(30);
        make.top.equalTo(self.jine_lab.mas_bottom);
        make.left.offset(10);
    }];
    [self.feilv_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(W);
        make.centerY.equalTo(self.shouxufei_lab);
        make.left.equalTo(self.shouxufei_lab.mas_right).offset(10);
    }];
    [self.leixing_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(W);
        make.height.offset(30);
        make.top.equalTo(self.shouxufei_lab.mas_bottom);
        make.left.offset(10);
    }];
    [self.zhuangtai_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(W);
        make.centerY.equalTo(self.leixing_lab);
        make.left.equalTo(self.leixing_lab.mas_right).offset(10);
    }];
    
    
    
    [self.miaoshu_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.top.equalTo(self.leixing_lab.mas_bottom);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    
    
    [self.shijian_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.top.equalTo(self.miaoshu_lab.mas_bottom);
        make.left.offset(10);
    }];
    
    [self.shibai_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shijian_lab.mas_bottom);
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.offset(-15);
    }];
    
    
    
}
@end
