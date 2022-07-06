//
//  HCReflectController.m
//  HC
//
//  Created by tuibao on 2021/11/12.
//

#import "HCReflectController.h"
#import "HCAddModificationController.h"

#import "HCWithdrawalSuccessView.h"
@interface HCReflectController ()


@property (nonatomic , strong) UIView *zfb_view;
@property (nonatomic , strong) UIButton *zfb_select_btn;
@property (nonatomic , strong) UILabel *zfb_title_lab;
@property (nonatomic , strong) UILabel *zfb_name_lab;
@property (nonatomic , strong) UIButton *zfb_modify;
@property (nonatomic , strong) UIButton *zfb_add;

@property (nonatomic , strong) UIView *yh_view;
@property (nonatomic , strong) UIButton *yh_select_btn;
@property (nonatomic , strong) UILabel *yh_title_lab;
@property (nonatomic , strong) UILabel *yh_name_lab;
@property (nonatomic , strong) UIImageView *yh_right_img;
@property (nonatomic , strong) UIImageView *yh_yl_img;

@property (nonatomic , strong) UIView *content_view;
@property (nonatomic , strong) UILabel *content_title_lab;
@property (nonatomic , strong) UIView *content_line;
@property (nonatomic , strong) UILabel *content_qian_lab;
@property (nonatomic , strong) UITextField *content_textfield;
@property (nonatomic , strong) UILabel *content_tishi_lab;

@property (nonatomic , strong) UILabel *tishi_title_lab;
@property (nonatomic , strong) UILabel *tishi_lab;

@property (nonatomic , strong) UIButton *finishBtn;

///提现类型 yes 为支付宝
@property (nonatomic , assign) BOOL WithdrawalType;
//储蓄卡信息
@property (nonatomic , strong) NSDictionary *CashData;
//支付宝信息
@property (nonatomic , strong) NSArray *AlipayArr;


@end

@implementation HCReflectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if([self.Reflect_type isEqualToString:@"空卡"]){
        self.navigationItem.title = @"空卡退还金";
        
        self.tishi_lab.text = @"退还手续费按照累计支付退还金的总额×0.56%+3收取。";
        
    }else{
        self.navigationItem.title = @"提现";
    }
    
    //默认支付宝
    self.WithdrawalType = YES;
    [self.zfb_modify setHidden:YES];
    
    [self LoadUI];
    [self viewAction];
    [self GetCashCard];
    [self getDeterMineAction];
    
}


#pragma 提现
- (void)getRefiectAction{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (self.WithdrawalType) {
        if ([self.zfb_name_lab.text isEqualToString:@"请添加支付宝"]) {
            [XHToast showBottomWithText:@"请添加支付宝" duration:2.0];
            return;
        }
        [dic setValue:self.zfb_name_lab.text forKey:@"payId"];
    }
    else{
        if (self.CashData.count == 0) {
            [XHToast showBottomWithText:@"请添加结算卡" duration:2.0];
            return;
        }
        [dic setValue:self.CashData[@"cardNo"] forKey:@"payId"];
    }
    
    if (self.content_textfield.text.length == 0) {
        [XHToast showBottomWithText:@"请输入提现金额" duration:2.0];
        return;
    }
    
    if ([self.content_textfield.text doubleValue] < 100) {
        [XHToast showBottomWithText:@"每次提现不能低于100" duration:2.0];
        return;
    }
    
    
    [dic setValue:self.content_textfield.text forKey:@"amount"];
    
    if(self.WithdrawalType){
        [dic setValue:@"2" forKey:@"type"];
        
    }else{
        [dic setValue:@"1" forKey:@"type"];
    }
    if ([self 是否超级会员提现]) {
        [self addRewardsView];
    }else{
        [self NetWorkingPostWithAddressURL:self hiddenHUD:NO url:@"/api/payment/withdraw" Params:dic success:^(id  _Nonnull responseObject) {
            if ([responseObject[@"code"] intValue] == 0) {
                [self addRewardsView];
            }else{
                [XHToast showBottomWithText:responseObject[@"message"]];
            }
        } failure:^(NSString * _Nonnull error) {
            
        }];
    }
    


}


- (BOOL)是否超级会员提现{
    NSDictionary *dicUser = [self loadUserData];
    
    if ([dicUser[@"agent"] intValue] == 1) {
        NSDictionary *dic = [self loadSuperMembersData];
        if ([dic[@"IsSwitch"] intValue] == 1) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
#pragma 体现成功弹窗
- (void)addRewardsView{
    @weakify(self);
    HCWithdrawalSuccessView *trading = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HCWithdrawalSuccessView class]) owner:nil options:nil] lastObject];
    trading.frame =CGRectMake(0, 0, DEVICE_WIDTH - 40, 320);
    
    trading.title_lab.text = [NSString stringWithFormat:@"%@元",self.content_textfield.text];
    trading.layer.cornerRadius = 8;
    //弹窗实例创建
    LSTPopView *popView = [LSTPopView initWithCustomView:trading
                                                  popStyle:LSTPopStyleSpringFromTop
                                              dismissStyle:LSTDismissStyleSmoothToTop];
    LSTPopViewWK(popView)
    [trading.btn bk_whenTapped:^{
        
        NSString *amount = [[NSString stringWithFormat:@"%f",[weak_self.CanCarry_amount doubleValue] - [weak_self.content_textfield.text doubleValue]] removeUnwantedZero];
        weak_self.content_tishi_lab.attributedText = [UILabel setupAttributeString:[NSString stringWithFormat:@"可提余额%@元",amount] rangeText:amount textColor:[UIColor colorWithHexString:@"#F4CA99"] textFont:[UIFont getUIFontSize:12 IsBold:YES]];
        weak_self.content_textfield.text = @"";
        [wk_popView dismiss];
    }];
    

    [popView pop];
    
    
}



#pragma 点击事件
- (void)viewAction{
    @weakify(self);
    
    //添加支付宝
    [self.zfb_add bk_whenTapped:^{
        HCAddModificationController *VC = [HCAddModificationController new];
        VC.typeStr = @"添加";
        VC.block = ^{
            [self getDeterMineAction];
        };
        [self.xp_rootNavigationController pushViewController:VC animated:YES];
    }];
    //修改支付宝
    [self.zfb_modify bk_whenTapped:^{
        HCAddModificationController *VC = [HCAddModificationController new];
        VC.typeStr = @"修改";
        VC.zhanghao = self.zfb_name_lab.text;
        VC.block = ^{
            [self getDeterMineAction];
        };
        [self.xp_rootNavigationController pushViewController:VC animated:YES];
    }];
    //修改银行
    [self.yh_view bk_whenTapped:^{
        HCSavingsListController *VC = [HCSavingsListController new];
        VC.block = ^(NSDictionary * _Nullable dataDic) {
            
            self.CashData = [NSDictionary dictionaryWithDictionary:dataDic];
            [self CashCardTheAssignment];
        };
        [weak_self.xp_rootNavigationController pushViewController:VC animated:YES];
    }];
    
    //提现选中状态切换
    [_zfb_select_btn bk_whenTapped:^{
        weak_self.WithdrawalType = YES;
        [weak_self selectType:weak_self.WithdrawalType];
    }];
    [_yh_select_btn bk_whenTapped:^{
        weak_self.WithdrawalType = NO;
        [weak_self selectType:weak_self.WithdrawalType];
    }];
    
    //
    
    [_finishBtn bk_whenTapped:^{
        [self getRefiectAction];
    }];
    
    
}
#pragma 获取支付宝列表
- (void)getDeterMineAction{

    [self NetWorkingPostWithURL:self hiddenHUD:YES url:@"/api/user/alipay/list" Params:[NSMutableDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            self.AlipayArr = [NSArray arrayWithArray:responseObject[@"data"]];
            if (self.AlipayArr.count > 0){
                self.zfb_name_lab.text = self.AlipayArr[0][@"payId"];
                [self.zfb_add setHidden:YES];
                [self.zfb_modify setHidden:NO];
            }
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
#pragma 获取默认储蓄卡
- (void)GetCashCard{
    @weakify(self);
    [self NetWorkingPostWithURL:self hiddenHUD:YES url:@"/api/user/debit/card/def" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        
        if ([responseObject[@"code"] intValue] == 0) {
            weak_self.CashData = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
            [weak_self CashCardTheAssignment];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
#pragma 储蓄卡赋值
- (void)CashCardTheAssignment{
    self.yh_title_lab.text = self.CashData[@"bankName"];
    self.yh_name_lab.text = [NSString stringWithFormat:@"尾号:%@",getAfterFour([self.CashData[@"cardNo"] stringValue])];
}

#pragma 提现选中状态调整
- (void)selectType:(BOOL)bol{
    
    if (bol) {
        [self.zfb_select_btn setImage:[UIImage imageNamed:@"icon_reflect_select"] forState:UIControlStateNormal];
        [self.yh_select_btn setImage:[UIImage imageNamed:@"icon_reflect_unselect"] forState:UIControlStateNormal];
        
    }else{
        [self.zfb_select_btn setImage:[UIImage imageNamed:@"icon_reflect_unselect"] forState:UIControlStateNormal];
        [self.yh_select_btn setImage:[UIImage imageNamed:@"icon_reflect_select"] forState:UIControlStateNormal];
    }
}
- (void)LoadUI{
    
    
    self.content_tishi_lab.attributedText = [UILabel setupAttributeString:[NSString stringWithFormat:@"可提余额%@元",self.CanCarry_amount] rangeText:self.CanCarry_amount textColor:[UIColor colorWithHexString:@"#F4CA99"] textFont:[UIFont getUIFontSize:12 IsBold:YES]];
    
    
    double view_W = (DEVICE_WIDTH - 30) / 2;
    [self.view addSubview:self.zfb_view];
    [self.zfb_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(view_W, 70));
        make.left.offset(10);
        make.top.equalTo(self.view.mas_top).offset(10);
    }];
    [self.zfb_view addSubview:self.zfb_select_btn];
    [self.zfb_select_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
    }];
    [self.zfb_view addSubview:self.zfb_title_lab];
    [self.zfb_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zfb_select_btn.mas_right).offset(10);
        make.top.offset(15);
    }];
    [self.zfb_view addSubview:self.zfb_name_lab];
    [self.zfb_name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zfb_select_btn.mas_right).offset(10);
        make.top.equalTo(self.zfb_title_lab.mas_bottom).offset(10);
    }];
    [self.zfb_view addSubview:self.zfb_modify];
    [self.zfb_modify mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 18));
        make.centerY.equalTo(self.zfb_title_lab);
        make.right.offset(-15);
    }];
    [self.zfb_view addSubview:self.zfb_add];
    [self.zfb_add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 18));
        make.centerY.equalTo(self.zfb_title_lab);
        make.right.offset(-15);
    }];
    
    [self.view addSubview:self.yh_view];
    [self.yh_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(view_W, 70));
        make.right.offset(-10);
        make.top.offset(10);
    }];
    [self.yh_view addSubview:self.yh_select_btn];
    [self.yh_select_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
    }];
    [self.yh_view addSubview:self.yh_title_lab];
    [self.yh_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yh_select_btn.mas_right).offset(10);
        make.top.offset(15);
    }];
    [self.yh_view addSubview:self.yh_name_lab];
    [self.yh_name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yh_select_btn.mas_right).offset(10);
        make.top.equalTo(self.yh_title_lab.mas_bottom).offset(10);
    }];
    [self.yh_view addSubview:self.yh_right_img];
    [self.yh_right_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.yh_view);
        make.right.offset(-15);
    }];
    [self.yh_view addSubview:self.yh_yl_img];
    [self.yh_yl_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.yh_title_lab);
        make.right.equalTo(self.yh_right_img.mas_left).offset(-10);
    }];
    
    [self.view addSubview:self.content_view];
    [self.content_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 20, 100));
        make.left.offset(10);
        make.top.equalTo(self.zfb_view.mas_bottom).offset(10);
    }];
    [self.content_view addSubview:self.content_title_lab];
    [self.content_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(10);
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
    
    [self.view addSubview:self.tishi_title_lab];
    [self.tishi_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content_view.mas_bottom).offset(20);
        make.left.equalTo(self.content_view.mas_left).offset(5);
    }];
    [self.view addSubview:self.tishi_lab];
    [self.tishi_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tishi_title_lab.mas_bottom).offset(10);
        make.left.equalTo(self.content_view.mas_left).offset(5);
        make.right.equalTo(self.content_view.mas_right).offset(-5);
    }];
    
    [self.view addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 46));
        make.left.offset(16);
        make.top.equalTo(self.tishi_lab.mas_bottom).offset(50);
    }];
}
#pragma 懒加载
- (UIView *)zfb_view{
    if (!_zfb_view) {
        _zfb_view = [UIView new];
        _zfb_view.backgroundColor = [UIColor colorWithHexString:@"#1F2025"];
        _zfb_view.layer.cornerRadius = 7.5;
    }
    return _zfb_view;
}
- (UIButton *)zfb_select_btn{
    if (!_zfb_select_btn) {
        _zfb_select_btn = [UIButton new];
        [_zfb_select_btn setImage:[UIImage imageNamed:@"icon_reflect_select"] forState:UIControlStateNormal];
        [_zfb_select_btn setEnlargeEdgeWithTop:15 right:15 bottom:30 left:15];
    }
    return _zfb_select_btn;
}
- (UILabel *)zfb_title_lab{
    if (!_zfb_title_lab) {
        _zfb_title_lab = [UILabel new];
        _zfb_title_lab.text = @"支付宝";
        _zfb_title_lab.textColor = [UIColor colorWithHexString:@"#F4CA99"];
        _zfb_title_lab.font = [UIFont getUIFontSize:15 IsBold:YES];
    }
    return _zfb_title_lab;
}
- (UILabel *)zfb_name_lab{
    if (!_zfb_name_lab) {
        _zfb_name_lab = [UILabel new];
        _zfb_name_lab.text = @"请添加支付宝";
        _zfb_name_lab.textColor = [UIColor colorWithHexString:@"#F4CA99"];
        _zfb_name_lab.font = [UIFont getUIFontSize:12 IsBold:NO];
    }
    return _zfb_name_lab;
}
- (UIButton *)zfb_modify{
    if (!_zfb_modify) {
        _zfb_modify = [UIButton new];
        [_zfb_modify setTitle:@"修改" forState:UIControlStateNormal];
        [_zfb_modify setTitleColor:[UIColor colorWithHexString:@"#F4CA99"] forState:UIControlStateNormal];
        [_zfb_modify setImage:[UIImage imageNamed:@"icon_xiugai_h"] forState:UIControlStateNormal];
        _zfb_modify.titleLabel.font = [UIFont getUIFontSize:12 IsBold:NO];
        self.zfb_modify.layer.masksToBounds = YES;
        self.zfb_modify.layer.cornerRadius = 5;
        self.zfb_modify.layer.borderColor = [UIColor colorWithHexString:@"#F4CA99" alpha:0.5].CGColor;
        self.zfb_modify.layer.borderWidth = 0.5;
        [self.zfb_modify layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3.5];
    }
    return _zfb_modify;
}
- (UIButton *)zfb_add{
    if (!_zfb_add) {
        _zfb_add = [UIButton new];
        [_zfb_add setTitle:@"添加" forState:UIControlStateNormal];
        [_zfb_add setTitleColor:[UIColor colorWithHexString:@"#F4CA99"] forState:UIControlStateNormal];
        [_zfb_add setImage:[UIImage imageNamed:@"icon_tianjia_h"] forState:UIControlStateNormal];
        _zfb_add.titleLabel.font = [UIFont getUIFontSize:12 IsBold:NO];
        self.zfb_add.layer.masksToBounds = YES;
        self.zfb_add.layer.cornerRadius = 5;
        self.zfb_add.layer.borderColor = [UIColor colorWithHexString:@"#F4CA99" alpha:0.5].CGColor;
        self.zfb_add.layer.borderWidth = 0.5;
        [self.zfb_add layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3.5];
    }
    return _zfb_add;
}
- (UIView *)yh_view{
    if (!_yh_view) {
        _yh_view = [UIView new];
        _yh_view.backgroundColor = [UIColor colorWithHexString:@"#1F2025"];
        _yh_view.layer.cornerRadius = 7.5;
    }
    return _yh_view;
}
- (UIButton *)yh_select_btn{
    if (!_yh_select_btn) {
        _yh_select_btn = [UIButton new];
        [_yh_select_btn setImage:[UIImage imageNamed:@"icon_reflect_unselect"] forState:UIControlStateNormal];
        [_yh_select_btn setEnlargeEdgeWithTop:15 right:15 bottom:30 left:15];
    }
    return _yh_select_btn;
}
- (UILabel *)yh_title_lab{
    if (!_yh_title_lab) {
        _yh_title_lab = [UILabel new];
        _yh_title_lab.text = @"空";
        _yh_title_lab.textColor = [UIColor colorWithHexString:@"#F4CA99"];
        _yh_title_lab.font = [UIFont getUIFontSize:15 IsBold:YES];
    }
    return _yh_title_lab;
}
- (UILabel *)yh_name_lab{
    if (!_yh_name_lab) {
        _yh_name_lab = [UILabel new];
        _yh_name_lab.text = @"空";
        _yh_name_lab.textColor = [UIColor colorWithHexString:@"#F4CA99"];
        _yh_name_lab.font = [UIFont getUIFontSize:12 IsBold:NO];
    }
    return _yh_name_lab;
}
- (UIImageView *)yh_right_img{
    if (!_yh_right_img) {
        _yh_right_img = [UIImageView getUIImageView:@"icon_you_h"];
    }
    return _yh_right_img;
}
- (UIImageView *)yh_yl_img{
    if (!_yh_yl_img) {
        _yh_yl_img = [UIImageView getUIImageView:@"icon_yinlian"];
    }
    return _yh_yl_img;
}
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
        _content_tishi_lab.text = @"可提余额0元";
        _content_tishi_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        _content_tishi_lab.font = [UIFont getUIFontSize:10 IsBold:NO];
    }
    return _content_tishi_lab;
}
- (UILabel *)tishi_title_lab{
    if (!_tishi_title_lab) {
        _tishi_title_lab = [UILabel new];
        _tishi_title_lab.text = @"温馨提示：";
        _tishi_title_lab.textColor = [UIColor colorWithHexString:@"#D79F65"];
        _tishi_title_lab.font = [UIFont getUIFontSize:12 IsBold:YES];
    }
    return _tishi_title_lab;
}
- (UILabel *)tishi_lab{
    if (!_tishi_lab) {
        _tishi_lab = [UILabel new];
        _tishi_lab.text = @"提现时间：每日9:00:00-18:00:00\n提现规则：需大于100元，2元/笔，每日/次\n到账时间：支付宝秒到，储蓄卡第二个工作日12:00前到账";
        _tishi_lab.textColor = [UIColor colorWithHexString:@"#666666"];
        _tishi_lab.font = [UIFont getUIFontSize:12 IsBold:NO];
        _tishi_lab.numberOfLines = 10;
        [UILabel changeLineSpaceForLabel:self.tishi_lab WithSpace:10];
    }
    return _tishi_lab;
}
- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton new];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"KD_BindCardBtn"] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"确定提现" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont getUIFontSize:18 IsBold:YES];
        
    }
    return _finishBtn;
}

@end
