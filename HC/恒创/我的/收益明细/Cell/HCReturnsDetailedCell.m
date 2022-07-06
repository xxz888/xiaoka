//
//  HCReturnsDetailedCell.m
//  HC
//
//  Created by tuibao on 2021/11/18.
//

#import "HCReturnsDetailedCell.h"

@implementation HCReturnsDetailedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    [_bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.offset(0);
        make.centerX.equalTo(_bgview);
    }];

    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.centerX.equalTo(_bgview);
        make.top.equalTo(_image.mas_bottom).offset(5);
        make.bottom.offset(0);
    }];
    
    
}

@end
