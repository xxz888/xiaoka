//
//  HCMallShippingAddressCell.m
//  HC
//
//  Created by tuibao on 2021/12/23.
//

#import "HCMallShippingAddressCell.h"

@implementation HCMallShippingAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clean_but.ylCornerRadius = 3.0;
    self.clean_but.layer.borderColor = [UIColor colorWithHexString:@"#B7B7B7"].CGColor;
    self.clean_but.layer.borderWidth = 0.5;
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10);
    }];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.name);
        make.left.equalTo(self.name.mas_right).offset(10);
    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(10);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    [self.clean_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 26));
        make.right.offset(-10);
        make.top.equalTo(self.content.mas_bottom).offset(10);
        make.bottom.offset(-10);
    }];
    
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
