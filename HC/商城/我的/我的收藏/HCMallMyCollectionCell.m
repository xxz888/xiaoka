//
//  HCMallMyCollectionCell.m
//  HC
//
//  Created by tuibao on 2021/12/24.
//

#import "HCMallMyCollectionCell.h"

@implementation HCMallMyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self LoadUI];
}

- (void)LoadUI{
    
    self.bg_view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.bg_view.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
    self.bg_view.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
    self.bg_view.layer.shadowRadius = 3;// 阴影半径，默认3
    self.bg_view.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    self.bg_view.layer.cornerRadius = 10;
    
    [self.bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10);
        make.right.bottom.offset(-10);
    }];
    self.min_icon.ylCornerRadius = 5.0;
    [self.min_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.top.left.offset(10);
    }];
    
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.min_icon);
        make.left.equalTo(self.min_icon.mas_right).offset(10);
        make.right.offset(-80);
    }];
    
    [self.clean_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 18));
        make.right.offset(-10);
        make.centerY.equalTo(self.min_icon);
    }];
    
    self.max_icon.ylCornerRadius = 10.0;
    [self.max_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.top.equalTo(self.min_icon.mas_bottom).offset(10);
        make.left.offset(10);
        make.bottom.offset(-10);
    }];
    
    [self.name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.max_icon.mas_top);
        make.left.equalTo(self.max_icon.mas_right).offset(10);
        make.right.offset(-10);
    }];
    
    [self.price_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.max_icon.mas_bottom);
        make.left.equalTo(self.max_icon.mas_right).offset(10);
        make.right.offset(-10);
    }];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
