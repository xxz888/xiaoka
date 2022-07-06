//
//  HCInvestmentDetailCell.m
//  HC
//
//  Created by tuibao on 2021/11/19.
//

#import "HCInvestmentDetailCell.h"

@implementation HCInvestmentDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self LoadUI];
}
- (void)LoadUI{
    self.bg_view.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
    self.bg_view.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
    self.bg_view.layer.shadowRadius = 3;// 阴影半径，默认3
    self.bg_view.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    self.bg_view.layer.cornerRadius = 10;
    
    
    [self.bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10);
        make.right.bottom.offset(-10);
    }];
    
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(25);
        make.bottom.offset(-25);
    }];
 
    
    [self.number_lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(12);
        make.left.equalTo(self.title_lab.mas_right).offset(15);
    }];
    
    [self.number_lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.number_lab1);
        make.left.offset((DEVICE_WIDTH - 20)/2);
    }];
    
    [self.number_lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.number_lab1.mas_bottom).offset(12);
        make.left.equalTo(self.title_lab.mas_right).offset(15);
    }];
    
    [self.number_lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.number_lab3);
        make.left.offset((DEVICE_WIDTH - 20)/2);
    }];
    
    
    [self.right_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-15);
    }];
    
    
}
@end
