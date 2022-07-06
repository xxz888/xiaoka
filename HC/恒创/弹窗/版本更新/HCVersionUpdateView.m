//
//  HCVersionUpdateView.m
//  HC
//
//  Created by tuibao on 2021/11/26.
//

#import "HCVersionUpdateView.h"

@implementation HCVersionUpdateView

- (void)awakeFromNib{
    [super awakeFromNib];
    

    self.bg_view.layer.cornerRadius = 17;
    [self.bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.frame.size.width - 20);
        make.top.left.offset(10);
        make.right.offset(-10);
        make.bottom.offset(-10);
    }];
    [self.bg_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(-0.5);
        make.left.offset(-0.5);
        make.right.offset(0);
    }];
    
    [self.version_image mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bg_image.mas_top).offset(40);
        make.left.equalTo(self.bg_image.mas_left).offset(30);
    }];
    
    self.title_lab.layer.masksToBounds = YES;
    self.title_lab.layer.cornerRadius = 12;
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55, 24));
        make.top.equalTo(self.version_image.mas_top).offset(8);
        make.left.equalTo(self.version_image.mas_left).offset(100);
    }];
    
    [self.content_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bg_image.mas_bottom).offset(20);
        make.left.offset(30);
        make.right.offset(-30);
    }];
    
    [self.upgrade_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.top.equalTo(self.content_lab.mas_bottom).offset(20);
        make.left.offset(20);
        make.right.offset(-20);
    }];
    
    [self.tishi_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.top.equalTo(self.upgrade_btn.mas_bottom).offset(10);
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.offset(-10);
    }];
    
}

@end
