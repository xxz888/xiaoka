//
//  HCSigningCell.m
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import "HCSigningCell.h"

@interface HCSigningCell()<UITextFieldDelegate>

@end

@implementation HCSigningCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(HCConfirmPayModel *)model{
    _model = model;
    self.title_lab.text = model.name;
    
    self.content_textfield.text = model.content;
    //设置密码框
    if([self.title_lab.text isEqualToString:@"有效期"] || [self.title_lab.text isEqualToString:@"安全码"]){
        self.content_textfield.secureTextEntry = YES;
    }else{
        self.content_textfield.secureTextEntry = NO;
    }
    //卡号隐藏
    if([self.title_lab.text isEqualToString:@"卡号"]){
        self.content_textfield.text = [NSString getSecrectStringWithAccountNo:model.content];
    }
    
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80);
        make.centerY.equalTo(self.contentView);
        make.left.offset(10);
    }];
    if ([model.name isEqualToString:@"验证码"]) {
        self.content_textfield.userInteractionEnabled = YES;
        [self.textfield_lab setHidden:NO];
//        self.textfield_lab.delegate = self;
//        self.textfield_lab.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        [self.line_view setHidden:YES];
        self.content_textfield.textColor = [UIColor colorWithHexString:@"#FF9426"];
        [self.content_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(80);
            make.centerY.equalTo(self.contentView);
            make.right.offset(-10);
        }];
        [self.textfield_lab addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.textfield_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.content_textfield.mas_left).offset(-10);
            make.left.equalTo(self.title_lab.mas_right).offset(10);
        }];
        
    }else{
        self.content_textfield.userInteractionEnabled = NO;
        [self.line_view setHidden:NO];
        [self.textfield_lab setHidden:YES];
        self.content_textfield.textColor = [UIColor colorWithHexString:@"#666666"];
        [self.content_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.offset(-10);
            make.left.equalTo(self.title_lab.mas_right).offset(10);
        }];
        
        [self.line_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(DEVICE_WIDTH - 30 - 20);
            make.height.offset(0.5);
            make.bottom.offset(0);
            make.centerX.equalTo(self.contentView);
        }];
    }
    self.content_textfield.delegate = self;
}
- (void)textFieldDidChange:(UITextField *)textField {
    self.model.placeholder = textField.text;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"这里返回为NO。则为禁止编辑");
    return NO;
}


@end
