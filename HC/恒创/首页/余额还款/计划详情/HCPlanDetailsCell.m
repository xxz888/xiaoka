//
//  HCPlanDetailsCell.m
//  HC
//
//  Created by tuibao on 2021/11/9.
//

#import "HCPlanDetailsCell.h"

@implementation HCPlanDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    [self.image_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.centerY.equalTo(self.contentView);
        make.left.offset(10);
    }];
    
    [self.xuxian_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(1);
        make.top.bottom.offset(0);
        make.centerX.equalTo(self.image_img);
    }];
    
    double lab_W = (DEVICE_WIDTH - 30 - 32 )/5;
    [self.time_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W*2+5);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.image_img.mas_right).offset(5);
    }];
    [self.type_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.time_lab.mas_right);
    }];
    [self.money_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.type_lab.mas_right);
    }];
    [self.plan_type_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.money_lab.mas_right);
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
