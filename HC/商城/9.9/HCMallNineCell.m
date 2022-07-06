//
//  HCMallNineCell.m
//  HC
//
//  Created by tuibao on 2021/12/13.
//

#import "HCMallNineCell.h"

@implementation HCMallNineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(180);
    }];
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top_image.mas_bottom).offset(8);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    [self.baoyou_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title_lab.mas_bottom).offset(8);
        make.left.offset(10);
    }];
    [self.xiaoliang_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.baoyou_lab);
        make.right.offset(-10);
    }];
    [self.yuanjia_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baoyou_lab.mas_bottom).offset(8);
        make.left.offset(10);
    }];
    
    [self.vip_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.centerY.equalTo(self.yuanjia_lab);
        make.left.equalTo(self.yuanjia_lab.mas_right).offset(10);
    }];

    [self.vip_left_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vip_view);
        make.left.equalTo(self.vip_view.mas_left).offset(5);
    }];
    [self.vip_right_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(16);
        make.centerY.equalTo(self.vip_view);
        make.left.equalTo(self.vip_left_lab.mas_right).offset(5);
        make.right.equalTo(self.vip_view.mas_right).offset(-2);
    }];
    
}

@end
