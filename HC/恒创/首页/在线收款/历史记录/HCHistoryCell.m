//
//  HCHistoryCell.m
//  HC
//
//  Created by tuibao on 2021/11/8.
//

#import "HCHistoryCell.h"

@implementation HCHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

    self.bg_view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.bg_view.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
    self.bg_view.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
    self.bg_view.layer.shadowRadius = 3;// 阴影半径，默认3
    self.bg_view.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    self.bg_view.layer.cornerRadius = 10;
    
    [self.bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(10);
        make.right.bottom.offset(-10);
    }];
    
    [self.icon_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.bg_view);
        make.left.offset(25);
    }];
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(120);
        make.top.offset(20);
        make.left.equalTo(self.icon_image.mas_right).offset(25);
    }];
    
    [self.content_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(28);
        make.top.equalTo(self.title_lab.mas_bottom).offset(15);
        make.left.equalTo(self.icon_image.mas_right).offset(25);
    }];
    [self.content_number_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.content_lab);
        make.left.equalTo(self.content_lab.mas_right).offset(0);
    }];
    
    [self.number_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(120);
        make.centerY.equalTo(self.title_lab);
        make.right.equalTo(self.bg_view.mas_right).offset(-15);
    }];
    
    
    [self.type_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(120);
        make.centerY.equalTo(self.content_lab);
        make.right.equalTo(self.bg_view.mas_right).offset(-15);
        make.bottom.offset(-15);
    }];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
