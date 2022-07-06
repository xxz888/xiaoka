//
//  HCTheHistoricalRecordCell.m
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import "HCTheHistoricalRecordCell.h"

@implementation HCTheHistoricalRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bg_view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.bg_view.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
    self.bg_view.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
    self.bg_view.layer.shadowRadius = 3;// 阴影半径，默认3
    self.bg_view.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    self.bg_view.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
