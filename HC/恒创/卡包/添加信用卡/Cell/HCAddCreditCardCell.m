//
//  HCAddCreditCardCell.m
//  HC
//
//  Created by tuibao on 2021/11/11.
//

#import "HCAddCreditCardCell.h"

@interface HCAddCreditCardCell() <UITextFieldDelegate>

@property (strong, nonatomic) WLCardNoFormatter *cardNoFormatter;

@end

@implementation HCAddCreditCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(HCConfirmPayModel *)model{
    
    _model = model;
    
    self.title_lab.text = model.name;
    self.content_textfield.placeholder = model.placeholder;
    self.content_textfield.text = model.content;
    
    
    if ([self.title_lab.text isEqualToString:@"卡号"]) {
        [self.right_btn setHidden:NO];
    }else{
        [self.right_btn setHidden:YES];
    }
    
    if ([model.name containsString:@"日"]  ||  [model.name isEqualToString:@"持卡人"]) {
        self.content_textfield.delegate = self;
    }
    
    if ([self.title_lab.text isEqualToString:@"卡号"] ||
        [self.title_lab.text isEqualToString:@"预留手机号"] ||
        [self.title_lab.text isEqualToString:@"有效期"] ||
        [self.title_lab.text isEqualToString:@"安全码"]) {
        
        _content_textfield.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        _content_textfield.delegate = self;
        
        if([self.title_lab.text isEqualToString:@"卡号"]){
            _content_textfield.tag = 100;
        }else if([self.title_lab.text isEqualToString:@"预留手机号"]){
            _content_textfield.tag = 200;
        }else if([self.title_lab.text isEqualToString:@"有效期"]){
            //设置密码框
            self.content_textfield.secureTextEntry = YES;
            _content_textfield.tag = 300;
        }else if([self.title_lab.text isEqualToString:@"安全码"]){
            //设置密码框
            self.content_textfield.secureTextEntry = YES;
            _content_textfield.tag = 400;
        }
    }
}

//返回NO以禁止编辑。
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 100 || textField.tag == 200 || textField.tag == 300 || textField.tag == 400) {
        return YES;
    }
    return NO;
}


// 显示长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    self.model.content = [textField.text stringByAppendingFormat:@"%@", string];
    if ( textField.tag == 200 && self.content_textfield.text.length > 10 && ![string isEqualToString:@""]) {
        return NO;
    }else if(textField.tag == 100){
        [self.cardNoFormatter bankNoField:textField shouldChangeCharactersInRange:range replacementString:string];
        return NO;
    }else if(textField.tag == 300 && self.content_textfield.text.length > 3 && ![string isEqualToString:@""]){
        return NO;
    }else if(textField.tag == 400 && self.content_textfield.text.length > 2 && ![string isEqualToString:@""]){
        return NO;
    }
    
    return YES;
}




- (WLCardNoFormatter *)cardNoFormatter {
    if(_cardNoFormatter == nil) {
        _cardNoFormatter = [[WLCardNoFormatter alloc] init];
    }
    return _cardNoFormatter;
}





- (void)setIndex:(NSIndexPath *)index{
    
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(75);
        make.centerY.equalTo(self.contentView);
        make.left.offset(10);
    }];
    
    
    [self.right_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-10);
    }];
    [self.right_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
    
    
    [self.content_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(200);
        make.height.offset(40);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.title_lab.mas_right);
    }];
    
    
    [self.line_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH - 30 - 20);
        make.height.offset(0.5);
        make.bottom.offset(0);
        make.centerX.equalTo(self.contentView);
    }];
    
    
}

@end
