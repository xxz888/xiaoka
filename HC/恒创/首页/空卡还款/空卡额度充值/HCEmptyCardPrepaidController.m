//
//  HCEmptyCardPrepaidController.m
//  HC
//
//  Created by tuibao on 2022/1/12.
//

#import "HCEmptyCardPrepaidController.h"

@interface HCEmptyCardPrepaidController ()

@property (nonatomic , strong) UIView *content_view;
@property (nonatomic , strong) UIImageView *content_icon;
@property (nonatomic , strong) UILabel *content_title_lab;
@property (nonatomic , strong) UIView *content_line;
@property (nonatomic , strong) UILabel *content_qian_lab;
@property (nonatomic , strong) UITextField *content_textfield;
@property (nonatomic , strong) UILabel *content_tishi_lab;

@property (nonatomic , strong) UIButton *finishBtn;

@end

@implementation HCEmptyCardPrepaidController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"空卡额度充值";
    self.view.backgroundColor = [UIColor whiteColor];
    [self LoadUI];
}

- (void)LoadUI{

    
    [self.view addSubview:self.content_view];
    [self.content_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 20, 100));
        make.left.offset(10);
        make.top.equalTo(self.view.mas_top).offset(30);
    }];
    
    [self.content_view addSubview:self.content_title_lab];
    [self.content_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(62);
        make.top.offset(10);
    }];
    
    [self.content_view addSubview:self.content_icon];
    [self.content_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.content_title_lab);
        make.left.offset(10);
    }];
    
    
    [self.content_view addSubview:self.content_line];
    [self.content_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.offset(8.5);
        make.right.offset(-8.5);
        make.top.equalTo(self.content_title_lab.mas_bottom).offset(10);
    }];
    [self.content_view addSubview:self.content_qian_lab];
    [self.content_qian_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(self.content_line.mas_bottom).offset(10);
    }];
    [self.content_view addSubview:self.content_textfield];
    [self.content_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.content_qian_lab);
        make.left.equalTo(self.content_qian_lab.mas_right).offset(12);
        make.right.offset(-12);
    }];
    [self.content_view addSubview:self.content_tishi_lab];
    [self.content_tishi_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content_textfield.mas_bottom).offset(10);
        make.left.equalTo(self.content_textfield.mas_left).offset(2);
    }];
    

    
    [self.view addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 46));
        make.left.offset(16);
        make.top.equalTo(self.content_view.mas_bottom).offset(50);
    }];
}

#pragma 懒加载

- (UIView *)content_view{
    if (!_content_view) {
        _content_view = [UIView new];
        self.content_view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        self.content_view.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
        self.content_view.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
        self.content_view.layer.shadowRadius = 3;// 阴影半径，默认3
        self.content_view.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
        self.content_view.layer.cornerRadius = 10;
    }
    return _content_view;
}

- (UIImageView *)content_icon{
    if (!_content_icon) {
        _content_icon = [UIImageView getUIImageView:@"HC_EmptyCard_ZFB"];
    }
    return _content_icon;
}

- (UILabel *)content_title_lab{
    if (!_content_title_lab) {
        _content_title_lab = [UILabel new];
        _content_title_lab.text = @"提现金额(元）";
        _content_title_lab.textColor = [UIColor colorWithHexString:@"#333333"];
        _content_title_lab.font = [UIFont getUIFontSize:12 IsBold:YES];
    }
    return _content_title_lab;
}
- (UIView *)content_line{
    if (!_content_line) {
        _content_line = [UIView new];
        _content_line.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
    }
    return _content_line;
}
- (UILabel *)content_qian_lab{
    if (!_content_qian_lab) {
        _content_qian_lab = [UILabel new];
        _content_qian_lab.text = @"¥";
        _content_qian_lab.textColor = [UIColor colorWithHexString:@"#333333"];
        _content_qian_lab.font = [UIFont getUIFontSize:24 IsBold:NO];
    }
    return _content_qian_lab;
}
- (UITextField *)content_textfield{
    if (!_content_textfield) {
        _content_textfield = [UITextField new];
        _content_textfield.placeholder = @"请输入金额";
        _content_textfield.font = [UIFont getUIFontSize:18 IsBold:NO];
        _content_textfield.textColor = [UIColor blackColor];
        _content_textfield.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _content_textfield;
}
- (UILabel *)content_tishi_lab{
    if (!_content_tishi_lab) {
        _content_tishi_lab = [UILabel new];
        _content_tishi_lab.text = @"充值还款金，单笔限额300-5000元";
        _content_tishi_lab.textColor = [UIColor colorWithHexString:@"#666666"];
        _content_tishi_lab.font = [UIFont getUIFontSize:10 IsBold:NO];
    }
    return _content_tishi_lab;
}

- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton new];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"KD_BindCardBtn"] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"确定充值" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont getUIFontSize:18 IsBold:YES];
        
    }
    return _finishBtn;
}

@end
