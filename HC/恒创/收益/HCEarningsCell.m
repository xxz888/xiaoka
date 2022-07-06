//
//  HCEarningsCell.m
//  HC
//
//  Created by tuibao on 2021/11/11.
//

#import "HCEarningsCell.h"

@implementation HCEarningsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.left_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(18);
    }];
    
    [self.left_number_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.left_title_lab.mas_bottom).offset(10);
        make.left.offset(21);
        make.bottom.offset(-10);
    }];
    
    
    [self.right_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(75);
        make.top.offset(10);
        make.right.offset(-20);
    }];
    [self.right_number_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(76, 40));
        make.centerY.equalTo(self.left_number_lab);
        make.centerX.equalTo(self.right_title_lab);
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
