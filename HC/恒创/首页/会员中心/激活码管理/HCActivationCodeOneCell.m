//
//  HCActivationCodeOneCell.m
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import "HCActivationCodeOneCell.h"

@implementation HCActivationCodeOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
    
    [self.right_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.offset(-10);
        make.centerY.equalTo(self.bg_view);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.5, 44));
        make.top.offset(10);
        make.bottom.offset(-10);
        make.right.equalTo(self.right_btn.mas_left).offset(-10);
    }];
    
    
    [self.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.left.offset(10);
        make.top.offset(12);
    }];
    [self.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab1.mas_right).offset(10);
        make.right.equalTo(self.line.mas_left).offset(-10);
        make.centerY.equalTo(self.lab1);
    }];
    
    [self.lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.left.offset(10);
        make.top.equalTo(self.lab1.mas_bottom).offset(12);
    }];
    [self.lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab3.mas_right).offset(10);
        make.right.equalTo(self.line.mas_left).offset(-10);
        make.centerY.equalTo(self.lab3);
    }];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
