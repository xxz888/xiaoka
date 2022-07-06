//
//  HCSwipeFenRunCell.m
//  HC
//
//  Created by tuibao on 2021/11/19.
//

#import "HCSwipeFenRunCell.h"

@implementation HCSwipeFenRunCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    double view_W = (DEVICE_WIDTH - 20 - 50)/4;
    [self.dengji_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.center.equalTo(self.contentView);
    }];
    
    [self.name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(view_W);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.dengji_lab.mas_left);
    }];
    [self.time_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(view_W);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.name_lab.mas_left);
    }];
    
    [self.huankuan_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(view_W);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.dengji_lab.mas_right);
    }];
    [self.fenrun_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(view_W);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.huankuan_lab.mas_right);
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
