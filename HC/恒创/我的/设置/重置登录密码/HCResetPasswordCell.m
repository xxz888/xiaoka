//
//  HCResetPasswordCell.m
//  HC
//
//  Created by tuibao on 2021/11/18.
//

#import "HCResetPasswordCell.h"

@implementation HCResetPasswordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(70);
        make.centerY.equalTo(self.contentView);
        make.left.offset(15);
    }];
    
    [self.code_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(70);
        make.centerY.equalTo(self.contentView);
        make.right.offset(-15);
    }];
    [self.content_textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.content_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.name_lab.mas_right).offset(15);
        make.right.equalTo(self.code_btn.mas_left).offset(-15);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.offset(0);
    }];
}
- (void)setModel:(HCConfirmPayModel *)model{
    _model = model;
}
- (void)textFieldDidChange:(UITextField *)textField {
    self.model.content = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
