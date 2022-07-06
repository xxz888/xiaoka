//
//  HCLoginViewController.m
//  HC
//
//  Created by tuibao on 2021/11/6.
//

#import "HCLoginViewController.h"
#import "AppDelegate.h"
#import "HCResetPasswordController.h"
#define SegmentBtn_COLOR    [UIColor colorWithHexString:@"#DF8E40"]
@interface HCLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *topImg;

@property (weak, nonatomic) IBOutlet UIButton *segmentBtn1;
@property (weak, nonatomic) IBOutlet UIButton *segmentBtn2;
@property (weak, nonatomic) IBOutlet UIView *segmentLine1;
@property (weak, nonatomic) IBOutlet UIView *segmentLine2;

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIView *phoneLineView;

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIView *codeLineView;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registeredBtn;


@property (weak, nonatomic) IBOutlet UIView *agreementView;
@property (weak, nonatomic) IBOutlet UILabel *agreementLeftlLab;
@property (weak, nonatomic) IBOutlet UIButton *agreementRightLab;

@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
//登陆类型
@property (assign, nonatomic) BOOL loginType;

@end

@implementation HCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self InitialSetup];
//    MCAccreditation3ViewController *vc = [MCAccreditation3ViewController new];
//    [self.xp_rootNavigationController pushViewController:vc animated:YES];
}

//初始设置 为密码登陆
- (void)InitialSetup{
    
    self.loginType = YES;
    self.segmentBtn1.titleLabel.font = [UIFont getUIFontSize:18 IsBold:YES];
    self.segmentLine1.backgroundColor = SegmentBtn_COLOR;
    [self.segmentBtn1 setTitleColor:SegmentBtn_COLOR forState:UIControlStateNormal];
    
    self.segmentBtn2.titleLabel.font = [UIFont getUIFontSize:18 IsBold:NO];
    self.segmentLine2.backgroundColor = [UIColor clearColor];
    [self.segmentBtn2 setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"icon_login_xianshi"] forState:UIControlStateNormal];
    [self.codeBtn setTitle:@"" forState:UIControlStateNormal];
    [self.forgetBtn setHidden:NO];
    self.codeTextField.placeholder = @"请输入密码";
    
    self.codeBtn.titleLabel.font = [UIFont getUIFontSize:14 IsBold:NO];
    self.codeTextField.secureTextEntry = YES;
    
    self.codeImageView.image = [UIImage imageNamed:@"KD_Login_Pwd"];
    
    self.codeTextField.keyboardType = UIKeyboardTypeDefault;
    
}
// 密码登录验证码登陆切换
- (IBAction)segmentAction:(UIButton *)selectBtn{
    [self.codeTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];

    self.codeTextField.text = @"";
    
    
    if (self.segmentBtn1 == selectBtn) {
        [self InitialSetup];
    }
    else{
        self.loginType = NO;
        self.segmentBtn2.titleLabel.font = [UIFont getUIFontSize:18 IsBold:YES];
        self.segmentLine2.backgroundColor = SegmentBtn_COLOR;
        [self.segmentBtn2 setTitleColor:SegmentBtn_COLOR forState:UIControlStateNormal];
        [self.codeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.codeBtn setTitleColor:SegmentBtn_COLOR forState:UIControlStateNormal];
        
        self.segmentBtn1.titleLabel.font = [UIFont getUIFontSize:18 IsBold:NO];
        self.segmentLine1.backgroundColor = [UIColor clearColor];
        [self.segmentBtn1 setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        self.codeTextField.placeholder = @"请输入验证码";
        [self.forgetBtn setHidden:YES];
        self.codeImageView.image = [UIImage imageNamed:@"KD_Login_Yzm"];
        self.codeTextField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    }
}

// 获取验证码
- (IBAction)getCodeAction:(UIButton *)sender {
    if (self.loginType){
        self.codeTextField.secureTextEntry = !self.codeTextField.secureTextEntry;
        if (self.codeTextField.secureTextEntry) {
            [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"icon_login_xianshi"] forState:UIControlStateNormal];
        }else{
            [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"icon_login_yincang"] forState:UIControlStateNormal];
        }
        return;
    }
    
    NSString *phone = self.phoneTextField.text;
    if (phone.length != 11) {
        [XHToast showBottomWithText:@"请输入正确的手机号"];
        return;
    }else if(phone.length == 0){
        [XHToast showBottomWithText:@"请输入手机号"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phone forKey:@"phone"];
    [params setValue:@"0" forKey:@"type"];
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/notice/pass/sms/send" Params:params success:^(id  _Nonnull responseObject) {
        if([responseObject[@"code"] intValue] == 0){
            [weakSelf.forgetBtn setHidden:NO];
            //已注册开始请求验证码
            [weakSelf changeSendBtnText];
        }
        [XHToast showBottomWithText:responseObject[@"message"]];
    } failure:^(NSString * _Nonnull error) {}];
}

// 登录
- (IBAction)loginBtnAction:(UIButton *)sender {
    

    NSString *phone = self.phoneTextField.text;
    NSString *code = self.codeTextField.text;
    __weak typeof(self) weakSelf = self;
    if (phone.length != 11) {
        [XHToast showBottomWithText:@"手机号码错误,请重新核对并输入正确的手机号"];
        return;
    }
    
    //密码登录
    if (self.loginType) {
        if (code.length == 0) {
            [XHToast showBottomWithText:@"请输入密码"];
            return;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:brandId forKey:@"brandId"];
        [params setValue:phone forKey:@"username"];
        [params setValue:[NSString MD5ForUpper32Bate:code] forKey:@"password"];
        
//        [params setValue:@"8E51903014CD8B62CD0F0D2B71F77E5D" forKey:@"password"];

        [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/pass/login/password" Params:params success:^(id  _Nonnull responseObject) {
            if([responseObject[@"code"] intValue] == 0){
                [weakSelf loginSucess:responseObject[@"data"]];
            }
            [XHToast showBottomWithText:responseObject[@"message"] duration:2.0];
        } failure:^(NSString * _Nonnull error) {}];
    
    }
    else{
        //验证码登录
        if (code.length != 6) {
            [XHToast showBottomWithText:@"短信验证码错误,请重新核对并输入正确的验证码"];
            return;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:brandId forKey:@"brandId"];
        [params setValue:phone forKey:@"username"];
        [params setValue:code forKey:@"vericode"];

        [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/pass/login/vericode" Params:params success:^(id  _Nonnull responseObject) {

            if([responseObject[@"code"] intValue] == 0){
                [weakSelf loginSucess:responseObject[@"data"]];
            }
            [XHToast showBottomWithText:responseObject[@"message"] duration:2.0];

        } failure:^(NSString * _Nonnull error) {}];
    }
    
}
#pragma 保存登录信息
-(void)loginSucess:(NSDictionary *) result{
    
    
    
    //写入用户登陆数据
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setObject:result forKey:@"UserData"];
    [standardDefaults synchronize];//写完别忘了同步
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if ([result allKeys].count > 0 && ![result[@"username"] isEqualToString:@"17365299215"] && ![[result[@"preUserId"] stringValue] isEqualToString:@"236323487"]) {
        HCTabberController *tabber = [HCTabberController new];
        delegate.window.rootViewController = tabber;
        //登陆的时候加上别名 (极光推送)
        [JPUSHService setAlias:[result[@"id"] stringValue] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            if (iResCode == 0) {
                NSLog(@"添加别名成功");
            }
        } seq:0];
    }else{
        // 直接进入商城
        delegate.window.rootViewController = [delegate rootViewController];
    }
}

// 注册
- (IBAction)registerAction:(id)sender {
    [self.xp_rootNavigationController pushViewController:[HCRegisterViewController new] animated:YES];
}

//------ 验证码发送按钮动态改变文字 ------//
- (void)changeSendBtnText{

    __block NSInteger second = 60;
    // 全局队列 默认优先级
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 定时器模式 事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // NSEC_PER_SEC是秒 *1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (second >= 0) {
                if (self.loginType) {
                    dispatch_source_cancel(timer);
                    [self.codeBtn setTitle:@"" forState:(UIControlStateNormal)];
                    [self.codeBtn setUserInteractionEnabled:YES];
                }else{
                    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds", second] forState:UIControlStateNormal];
                    [self.codeBtn setUserInteractionEnabled:NO];
                    second--;
                }
                
            }else {
                dispatch_source_cancel(timer);
                [self.codeBtn setTitle:@"重新发送" forState:(UIControlStateNormal)];
                [self.codeBtn setUserInteractionEnabled:YES];
            }
            
        });
    });
    // 启动源
    dispatch_resume(timer);
}

//忘记密码
- (IBAction)forgetAction:(id)sender {
    HCResetPasswordController *VC = [HCResetPasswordController new];
    VC.isOneEnabled = YES;
    [self.xp_rootNavigationController pushViewController:VC animated:YES];
}

- (void)loadUI{
    
    if(self.xp_rootNavigationController.viewControllers.count > 1){
        [self.navigation_View setHidden:NO];
    }else{
        [self.navigation_View setHidden:YES];
    }
    
    [self.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset(0);
        make.height.offset(Ratio(202));
    }];
    
    [self.navigation_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44));
        make.top.equalTo(self.topImg.mas_top).offset(kStatusBarHeight);
        make.left.equalTo(self.view);
    }];
    [self.nav_back setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self.nav_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.centerY.equalTo(self.navigation_View);
    }];
    [self.nav_back bk_whenTapped:^{
        [self.xp_rootNavigationController popViewControllerAnimated:YES];
    }];
    
    
    [self.segmentBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(17);
        make.left.offset(50);
        make.top.equalTo(self.topImg.mas_bottom).offset(Ratio(38));
    }];
    
    [self.segmentLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(2);
        make.left.equalTo(self.segmentBtn1.mas_left);
        make.right.equalTo(self.segmentBtn1.mas_right);
        make.top.equalTo(self.segmentBtn1.mas_bottom).offset(Ratio(3));
    }];
    
    [self.segmentBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(17);
        make.left.equalTo(self.segmentBtn1.mas_right).offset(22);
        make.centerY.equalTo(self.segmentBtn1);
    }];
    [self.segmentLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(2);
        make.left.equalTo(self.segmentBtn2.mas_left);
        make.right.equalTo(self.segmentBtn2.mas_right);
        make.top.equalTo(self.segmentBtn2.mas_bottom).offset(Ratio(3));
    }];
    
    double view_jj = 13.0;

    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH-65);
        make.height.offset(46);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.segmentLine2.mas_bottom).offset(Ratio(21));
    }];
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneView);
        make.left.offset(view_jj);
    }];
    [self.phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0.5);
        make.height.offset(view_jj);
        make.centerY.equalTo(self.phoneView);
        make.left.equalTo(self.phoneImageView.mas_right).offset(view_jj);
    }];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.left.equalTo(self.phoneLineView.mas_right).offset(view_jj);
        make.centerY.equalTo(self.phoneView);
        make.right.offset(-view_jj);
    }];

    self.phoneView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.phoneView.layer.shadowColor = [UIColor colorWithRed:61/255.0 green:46/255.0 blue:35/255.0 alpha:0.05].CGColor;
    self.phoneView.layer.shadowOffset = CGSizeMake(0,4);
    self.phoneView.layer.shadowOpacity = 1;
    self.phoneView.layer.shadowRadius = 6;
    self.phoneView.layer.cornerRadius = 23;



    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH-65);
        make.height.offset(46);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.phoneView.mas_bottom).offset(Ratio(21));
    }];
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeView);
        make.left.offset(view_jj);
    }];
    [self.codeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0.5);
        make.height.offset(12);
        make.centerY.equalTo(self.codeView);
        make.left.equalTo(self.codeImageView.mas_right).offset(view_jj);
    }];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {


        make.centerY.equalTo(self.codeView);
        make.right.offset(-view_jj);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset(150);
        make.left.equalTo(self.codeLineView.mas_right).offset(view_jj);
        make.centerY.equalTo(self.codeView);
    }];
    self.codeView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.codeView.layer.shadowColor = [UIColor colorWithRed:61/255.0 green:46/255.0 blue:35/255.0 alpha:0.05].CGColor;
    self.codeView.layer.shadowOffset = CGSizeMake(0,4);
    self.codeView.layer.shadowOpacity = 1;
    self.codeView.layer.shadowRadius = 6;
    self.codeView.layer.cornerRadius = 23;

    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeView.mas_bottom).offset(14);
        make.right.equalTo(self.codeView.mas_right).offset(-5);
    }];

    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(46);
        make.width.offset(DEVICE_WIDTH-65);
        make.top.equalTo(self.forgetBtn.mas_bottom).offset(Ratio(19));
        make.centerX.equalTo(self.view);
    }];


    [self.registeredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(Ratio(19));
        make.centerX.equalTo(self.view);
    }];

    [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.offset(-KBottomHeight-40);
    }];
    [self.agreementLeftlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreementView);
        make.left.offset(0);
    }];
    [self.agreementRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreementView);
        make.right.top.bottom.offset(0);
        make.left.equalTo(self.agreementLeftlLab.mas_right).offset(0);
    }];

    [self.agreementRightLab bk_whenTapped:^{
        // 协议
        MCProtocolViewController * vc = [MCProtocolViewController new];
        vc.whereCome = @"1";
        [self.xp_rootNavigationController pushViewController:vc animated:YES];
    }];
    self.codeTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.codeTextField.tag = 100;
    self.phoneTextField.tag = 200;
}

// 控制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.tag == 100 && !self.loginType && self.codeTextField.text.length > 5 && ![string isEqualToString:@""]){
        return NO;
    }else if(textField.tag == 200 && self.phoneTextField.text.length > 10 && ![string isEqualToString:@""]){
        return NO;
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
@end
