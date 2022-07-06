//
//  HCHelpHKTableViewCell.m
//  HC
//
//  Created by tuibao on 2021/12/30.
//

#import "HCHelpHKTableViewCell.h"

@implementation HCHelpHKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self LoadUI];
}

- (void)LoadUI{
    
    [self.bg_view setViewTypeshadow];
    
    
    [self.bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10);
        make.right.bottom.offset(-10);
    }];
    [self.touxiang_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.top.offset(20);
        make.left.offset(10);
        make.bottom.offset(-20);
    }];
    [self.clean_btn setEnlargeEdgeWithTop:20 right:15 bottom:20 left:15];
    [self.clean_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bg_view);
        make.right.offset(-15);
    }];
    
    [self.name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(17);
        make.left.equalTo(self.touxiang_image.mas_right).offset(10);
    }];
    [self.phone_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name_lab.mas_right).offset(10);
        make.centerY.equalTo(self.name_lab);
    }];
    self.Customer_lab.ylCornerRadius = 5;
    [self.Customer_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.width.offset(65);
        make.right.equalTo(self.clean_btn.mas_left).offset(-26);
        make.centerY.equalTo(self.name_lab);
    }];
    
    [self.zxjihua_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name_lab.mas_bottom).offset(10);
        make.left.equalTo(self.touxiang_image.mas_right).offset(10);
    }];
    
    [self.yichangjihua_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.zxjihua_lab);
        make.centerX.equalTo(self.Customer_lab);
        
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
