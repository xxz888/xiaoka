//
//  HCUsedCashbackView.m
//  HC
//
//  Created by tuibao on 2021/11/19.
//

#import "HCUsedCashbackView.h"

@implementation HCUsedCashbackView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10);
        make.right.bottom.offset(-10);
    }];
    self.bgview.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.bgview.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
    self.bgview.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
    self.bgview.layer.shadowRadius = 3;// 阴影半径，默认3
    self.bgview.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    self.bgview.layer.cornerRadius = 10;
    
    double view_W = (DEVICE_WIDTH - 20 )/3;
    
    [self.yihuan_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(view_W);
        make.center.equalTo(self.bgview);
    }];
    
    [self.type_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(view_W);
        make.centerY.equalTo(self.bgview);
        make.right.equalTo(self.yihuan_lab.mas_left);
    }];
    
    [self.fanxian_lab  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(view_W);
        make.centerY.equalTo(self.bgview);
        make.left.equalTo(self.yihuan_lab.mas_right);
    }];
}

@end
