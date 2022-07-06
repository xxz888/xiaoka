//
//  HCTransactionDetailsCell.m
//  HC
//
//  Created by tuibao on 2021/11/8.
//

#import "HCTransactionDetailsCell.h"

@implementation HCTransactionDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(25);
    }];
    [self.content_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-25);
    }];
    [self.icon_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.content_lab.mas_left).offset(-2);
    }];
    [self.line_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 0.5));
        make.center.equalTo(self.contentView);
    }];
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
