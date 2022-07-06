//
//  HCBuyDownCell.m
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import "HCBuyDownCell.h"

@implementation HCBuyDownCell

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
    [self.quanyi_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(10);
    }];
    [self.quanyi_ma_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.quanyi_lab);
        make.left.equalTo(self.quanyi_lab.mas_right).offset(10);
    }];
    [self.pingtai_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(self.quanyi_lab.mas_bottom).offset(10);
        make.bottom.offset(-10);
    }];
    [self.number_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pingtai_lab);
        make.left.equalTo(self.pingtai_lab.mas_right).offset(10);
    }];
    [self.time_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pingtai_lab);
        make.right.offset(-10);
    }];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
