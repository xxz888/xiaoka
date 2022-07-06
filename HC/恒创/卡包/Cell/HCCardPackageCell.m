//
//  HCCardPackageCell.m
//  HC
//
//  Created by tuibao on 2021/11/11.
//

#import "HCCardPackageCell.h"

@implementation HCCardPackageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadUI];
}
- (void)loadUI{
    [self.bg_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(10);
        make.right.bottom.offset(-10);
    }];
    
    [self.icon_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(self.bg_image.mas_top).offset(15.5);
        make.left.equalTo(self.bg_image.mas_left).offset(25);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.top.equalTo(self.icon_image.mas_bottom).offset(50);
        make.left.equalTo(self.bg_image.mas_left).offset(20);
        make.right.equalTo(self.bg_image.mas_right).offset(-20);
    }];
    
    [self.moren_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line.mas_left).offset(2);
        make.bottom.equalTo(self.line.mas_top).offset(-10);
    }];
    
    
    [self.yinhang_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bg_image.mas_top).offset(17.5);
        make.left.equalTo(self.icon_image.mas_right).offset(25);
    }];
    
    [self.name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yinhang_lab.mas_bottom).offset(12);
        make.left.equalTo(self.yinhang_lab.mas_left).offset(2);
    }];
    
    [self.weihao_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.name_lab);
        make.left.equalTo(self.name_lab.mas_right).offset(23.5);
    }];
    
    [self.yinlang_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(43, 27));
        make.centerY.equalTo(self.yinhang_lab);
        make.right.equalTo(self.bg_image.mas_right).offset(-18);
    }];
    
    [self.xiugai_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 17));
        make.right.equalTo(self.bg_image.mas_right).offset(-20);
        make.top.equalTo(self.yinlang_lab.mas_bottom).offset(12.5);
    }];
    
    [self.delete_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 17));
        make.centerX.equalTo(self.xiugai_btn);
        make.top.equalTo(self.xiugai_btn.mas_bottom).offset(6);
    }];
    
    
    double lab_W = (DEVICE_WIDTH - 20 - 34)/3;
    
    [self.center_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(lab_W, 20));
        make.centerX.equalTo(self.bg_image);
        make.top.equalTo(self.line.mas_bottom).offset(10);
        make.bottom.equalTo(self.bg_image.mas_bottom).offset(-10);
    }];
    
    [self.left_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(lab_W, 20));
        make.centerY.equalTo(self.center_lab);
        make.left.equalTo(self.bg_image.mas_left).offset(17);
        make.right.equalTo(self.center_lab.mas_left);
    }];
    [self.right_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(lab_W, 20));
        make.centerY.equalTo(self.center_lab);
        make.left.equalTo(self.center_lab.mas_right);
        make.right.equalTo(self.bg_image.mas_right).offset(-17);
    }];
    
    self.xiugai_btn.layer.masksToBounds = YES;
    self.xiugai_btn.layer.cornerRadius = 5;
    self.xiugai_btn.layer.borderColor = [UIColor colorWithHexString:@"#F4CA99" alpha:0.5].CGColor;
    self.xiugai_btn.layer.borderWidth = 0.5;
    [self.xiugai_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3.5];
    self.delete_btn.layer.masksToBounds = YES;
    self.delete_btn.layer.cornerRadius = 5;
    self.delete_btn.layer.borderColor = [UIColor colorWithHexString:@"#F4CA99" alpha:0.5].CGColor;
    self.delete_btn.layer.borderWidth = 0.5;
    [self.delete_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3.5];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
