//
//  HCRegisterViewController.m
//  HC
//
//  Created by tuibao on 2021/11/6.
//

#import "HCRegisterViewController.h"

@interface HCRegisterViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIView *navigation_View;
@property (weak, nonatomic) IBOutlet UIButton *nav_back;

@property (weak, nonatomic) IBOutlet UIImageView *topImg;

@property (weak, nonatomic) IBOutlet UILabel *title_lab;

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIView *phoneLineView;

@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *passwordLineView;
@property (weak, nonatomic) IBOutlet UIButton *passwordBtn;

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIView *codeLineView;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIView *tuijianView;
@property (weak, nonatomic) IBOutlet UITextField *tuijianTf;
@property (weak, nonatomic) IBOutlet UIImageView *tuijianImv;
@property (weak, nonatomic) IBOutlet UIView *tuijianLine;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIView *agreementView;
@property (weak, nonatomic) IBOutlet UILabel *agreementLeftlLab;
@property (weak, nonatomic) IBOutlet UIButton *agreementRightLab;

@end

@implementation HCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.passwordTextField.secureTextEntry = YES;
    
    [self loadUI];
}


// 获取验证码
- (IBAction)getCodeAction:(UIButton *)sender {
    NSString *phone = self.phoneTextField.text;
    if (phone.length != 11) {
        [XHToast showBottomWithText:@"请输入正确的手机号"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phone forKey:@"phone"];
    [params setValue:@"0" forKey:@"type"];
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/notice/pass/sms/send" Params:params success:^(id  _Nonnull responseObject) {
        if([responseObject[@"code"] intValue] == 0){
            //已注册开始请求验证码
            [weakSelf changeSendBtnText];
            [XHToast showBottomWithText:responseObject[@"message"]];
        }else{
            [XHToast showBottomWithText:@"请求失败！"];
        }
        

    } failure:^(NSString * _Nonnull error) {}];

}


#pragma 密码显示隐藏
- (IBAction)ShowHiddenAction:(UIButton *)sender {
    self.passwordTextField.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
}

// 注册
- (IBAction)registerBtnAction:(UIButton *)sender {
    NSString *phone = self.phoneTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *code = self.codeTextField.text;
    if (phone.length != 11) {
        [XHToast showBottomWithText:@"请输入正确的手机号"];
        return;
    }
    if (password.length == 0) {
        [XHToast showBottomWithText:@"请输入密码"];
        return;
    }
    if (code.length != 6) {
        [XHToast showBottomWithText:@"请输入6位数字验证码"];
        return;
    }
    if (self.tuijianTf.text.length != 11) {
        [XHToast showBottomWithText:@"请输入推荐人手机号"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:brandId forKey:@"brandId"];
    [params setValue:phone forKey:@"username"];
    [params setValue:[NSString MD5ForUpper32Bate:password] forKey:@"password"];
    [params setValue:code forKey:@"smsCode"];
    [params setValue:self.tuijianTf.text forKey:@"prePhone"];
    
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/pass/register" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [XHToast showBottomWithText:@"注册成功" duration:1.0];
            [self.xp_rootNavigationController popViewControllerAnimated:YES];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {}];
    

}
//------ 验证码发送按钮动态改变文字 ------//
- (void)changeSendBtnText {
    
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
                
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds", second] forState:UIControlStateNormal];
                [self.codeBtn setUserInteractionEnabled:NO];
                second--;
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



- (void)loadUI{
    
    [self.navigation_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44));
        make.top.equalTo(self.view.mas_top).offset(kStatusBarHeight);
        make.left.equalTo(self.view);
    }];

    [self.nav_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.centerY.equalTo(self.navigation_View);
    }];
    
    [self.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset(0);
        make.height.offset(Ratio(202));
    }];
    
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(28);
        make.top.equalTo(self.topImg.mas_bottom).offset(Ratio(30));
        
    }];
    
    double view_jj = 13.0;

    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH-65);
        make.height.offset(46);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.title_lab.mas_bottom).offset(Ratio(20));
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
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH-65);
        make.height.offset(46);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.phoneView.mas_bottom).offset(Ratio(20));
    }];
    [self.passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.passwordView);
        make.left.offset(view_jj);
    }];
    [self.passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0.5);
        make.height.offset(12);
        make.centerY.equalTo(self.passwordView);
        make.left.equalTo(self.passwordImageView.mas_right).offset(view_jj);
    }];
    [self.passwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.passwordView);
        make.right.offset(-view_jj);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.left.equalTo(self.passwordLineView.mas_right).offset(view_jj);
        make.right.equalTo(self.passwordBtn.mas_left).offset(-view_jj);
        make.centerY.equalTo(self.passwordView);
    }];
    

    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH-65);
        make.height.offset(46);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.passwordView.mas_bottom).offset(Ratio(20));
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
    
    
    [self.tuijianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH-65);
        make.height.offset(46);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.codeView.mas_bottom).offset(Ratio(20));
    }];
    [self.tuijianImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tuijianView);
        make.left.offset(view_jj);
    }];
    [self.tuijianLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0.5);
        make.height.offset(view_jj);
        make.centerY.equalTo(self.tuijianView);
        make.left.equalTo(self.tuijianImv.mas_right).offset(view_jj);
    }];
    [self.tuijianTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.left.equalTo(self.tuijianLine.mas_right).offset(view_jj);
        make.centerY.equalTo(self.tuijianView);
        make.right.offset(-view_jj);
    }];

    
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(46);
        make.width.offset(DEVICE_WIDTH-65);
        make.top.equalTo(self.tuijianView.mas_bottom).offset(Ratio(35));
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
    
    [self.phoneView AddViewTypeRadius:23];
    [self.passwordView AddViewTypeRadius:23];
    [self.codeView AddViewTypeRadius:23];
    [self.tuijianView AddViewTypeRadius:23];
    
    [self.agreementRightLab bk_whenTapped:^{
        // 协议
        MCProtocolViewController * vc = [MCProtocolViewController new];
        vc.whereCome = @"1";
        [self.xp_rootNavigationController pushViewController:vc animated:YES];
    }];
    
    [self.nav_back bk_whenTapped:^{
        [self.xp_rootNavigationController popViewControllerAnimated:YES];
    }];
    self.codeTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.tuijianTf.delegate = self;
    
    self.codeTextField.tag = 100;
    self.phoneTextField.tag = 200;
    self.tuijianTf.tag = 300;
}

// 控制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.tag == 100 && self.codeTextField.text.length > 5 && ![string isEqualToString:@""]){
        return NO;
    }else if (textField.tag == 200 && self.phoneTextField.text.length > 10 && ![string isEqualToString:@""]){
        return NO;
    }else if (textField.tag == 300 && self.tuijianTf.text.length > 10 && ![string isEqualToString:@""]){
        return NO;
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

@end
