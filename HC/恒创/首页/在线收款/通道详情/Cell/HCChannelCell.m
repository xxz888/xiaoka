//
//  HCChannelCell.m
//  HC
//
//  Created by tuibao on 2021/11/8.
//

#import "HCChannelCell.h"

@implementation HCChannelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    [self loadUI];
}
- (void)loadUI{
    
    
    self.bg_view.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
    self.bg_view.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
    self.bg_view.layer.shadowRadius = 3;// 阴影半径，默认3
    self.bg_view.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    self.bg_view.layer.cornerRadius = 10;
    
    [self.bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.offset(-10);
    }];
    
    [self.icon_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.offset(10);
        make.left.offset(10);
    }];
    
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.icon_image);
        make.left.equalTo(self.icon_image.mas_right).offset(10);
    }];
    
    [self.chakan_lab getPartOfTheCornerRadius:CGRectMake(0, 0, 67, 28) CornerRadius:10 UIRectCorner:UIRectCornerTopRight];
    
    [self.chakan_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(67, 28));
        make.top.right.offset(0);
    }];
    
    double lab_W = (DEVICE_WIDTH - 50) / 2;
    
    [self.dbxe_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W);
        make.top.equalTo(self.icon_image.mas_bottom).offset(10);
        make.left.offset(10);
    }];
    [self.drxe_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W);
        make.centerY.equalTo(self.dbxe_lab);
        make.left.equalTo(self.dbxe_lab.mas_right).offset(10);
    }];
    
    [self.jysj_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W);
        make.top.equalTo(self.dbxe_lab.mas_bottom).offset(10);
        make.left.offset(10);
        make.bottom.offset(-10);
    }];
    [self.feilv_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W);
        make.centerY.equalTo(self.jysj_lab);
        make.left.equalTo(self.jysj_lab.mas_right).offset(10);
    }];
    
}


@end
