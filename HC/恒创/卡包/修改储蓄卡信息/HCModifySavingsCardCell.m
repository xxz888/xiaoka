//
//  HCModifySavingsCardCell.m
//  HC
//
//  Created by tuibao on 2021/11/11.
//

#import "HCModifySavingsCardCell.h"
@interface HCModifySavingsCardCell ()<UITextFieldDelegate>

@property (strong, nonatomic) WLCardNoFormatter *cardNoFormatter;

@end
@implementation HCModifySavingsCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self LoadUI];
    
}
- (void)setModel:(HCConfirmPayModel *)model{
    _model = model;

    self.title_lab.text = model.name;
    self.content_textfield.placeholder = model.placeholder;
    if ([self.title_lab.text isEqualToString:@"身份证"]) {
        self.content_textfield.text = [model.content replaceStringWithAsterisk:4 length:10];
    }else{
        self.content_textfield.text = model.content;
    }
    _content_textfield.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    if([self.title_lab.text isEqualToString:@"姓名"]){
        _content_textfield.tag = 100;
    }else if([self.title_lab.text isEqualToString:@"身份证"]){
        _content_textfield.tag = 200;
    }else if([self.title_lab.text isEqualToString:@"储蓄卡号"]){
        _content_textfield.tag = 300;
    }else if([self.title_lab.text isEqualToString:@"储蓄卡预留电话"]){
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


// 显示长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    self.model.content = [textField.text stringByAppendingFormat:@"%@", string];
    
    if(textField.tag == 300 && self.content_textfield.text.length > 18 && ![string isEqualToString:@""]){
        return NO;
    }else if(textField.tag == 400 && self.content_textfield.text.length > 10 && ![string isEqualToString:@""]){
        return NO;
    }
    
    return YES;
}
- (void)LoadUI{
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(110);
        make.centerY.equalTo(self.contentView);
        make.left.offset(15);
    }];
    self.content_textfield.delegate = self;
    [self.content_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.title_lab.mas_right);
        make.right.offset(-15);
    }];
    
    [self.line_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH - 20);
        make.height.offset(0.5);
        make.bottom.offset(0);
        make.centerX.equalTo(self.contentView);
    }];
}




@end
