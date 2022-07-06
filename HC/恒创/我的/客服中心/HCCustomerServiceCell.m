//
//  HCCustomerServiceCell.m
//  HC
//
//  Created by tuibao on 2021/11/18.
//

#import "HCCustomerServiceCell.h"

@implementation HCCustomerServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(5);
        make.right.bottom.offset(-5);
    }];
    
    [self.name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bg_view);
    }];
    
    [self.top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.centerX.equalTo(self.bg_view);
        make.bottom.equalTo(self.name_lab.mas_top).offset(-5);
    }];
    
    [self.content_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(38);
        make.centerX.equalTo(self.bg_view);
        make.top.equalTo(self.name_lab.mas_bottom).offset(0);
    }];
    
    self.bg_view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.bg_view.layer.shadowOffset = CGSizeMake(0, 0.1);// 阴影偏移，默认(0, -3)
    self.bg_view.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
    self.bg_view.layer.shadowRadius = 3;// 阴影半径，默认3
    self.bg_view.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    self.bg_view.layer.cornerRadius = 10;
    
    
    
}

@end
