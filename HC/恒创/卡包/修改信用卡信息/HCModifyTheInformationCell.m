//
//  HCModifyTheInformationCell.m
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import "HCModifyTheInformationCell.h"

@interface  HCModifyTheInformationCell()<UITextFieldDelegate>

@end

@implementation HCModifyTheInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.content_textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


- (void)setModel:(HCConfirmPayModel *)model{
    _model = model;

    self.title_lab.text = model.name;
    self.content_textfield.placeholder = model.placeholder;
    self.content_textfield.text = model.content;
    
    if([self.title_lab.text isEqualToString:@"银行卡号"] && model.content.length != 0){
        self.content_textfield.text = [NSString getSecrectStringWithAccountNo:model.content];
    }
    _content_textfield.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    self.content_textfield.delegate = self;
    
    if([self.title_lab.text isEqualToString:@"有效期"]){
        //设置密码框
        self.content_textfield.secureTextEntry = YES;
        _content_textfield.tag = 300;
    }else if([self.title_lab.text isEqualToString:@"安全码"]){
        //设置密码框
        self.content_textfield.secureTextEntry = YES;
        _content_textfield.tag = 400;
    }
}


//返回NO以禁止编辑。
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 300 || textField.tag == 400) {
        return YES;
    }
    return NO;
}
// 控制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.model.content = [textField.text stringByAppendingFormat:@"%@", string];
    if(textField.tag == 300 && self.content_textfield.text.length > 3 && ![string isEqualToString:@""]){
        return NO;
    }else if(textField.tag == 400 && self.content_textfield.text.length > 2 && ![string isEqualToString:@""]){
        return NO;
    }
    return YES;
}




- (void)setIndex:(NSIndexPath *)index{
    
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80);
        make.centerY.equalTo(self.contentView);
        make.left.offset(10);
    }];
    [self.content_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_lab.mas_right).offset(10);
        make.height.offset(40);
        make.centerY.equalTo(self.contentView);
        make.right.offset(-10);
    }];
    
    [self.line_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH - 30 - 20);
        make.height.offset(0.5);
        make.bottom.offset(0);
        make.centerX.equalTo(self.contentView);
    }];
    
    
}

@end
