//
//  HCUsedCashbackCell.m
//  HC
//
//  Created by tuibao on 2021/11/19.
//

#import "HCUsedCashbackCell.h"

@implementation HCUsedCashbackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    double view_W = (DEVICE_WIDTH - 20 )/3;
    [self.type_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(view_W, 40));
        make.left.offset(10);
        make.centerY.equalTo(self.contentView);
    }];

    [self.yihuan_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(view_W, 20));
        make.left.equalTo(self.type_lab.mas_right);
        make.centerY.equalTo(self.contentView);
    }];
    [self.fanxian_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(view_W, 20));
        make.left.equalTo(self.yihuan_lab.mas_right);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.offset(0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
