//
//  HCTheMemberController.m
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import "HCTheMemberController.h"
#import "HCActivationCodeController.h"



@interface HCTheMemberController ()

@property (weak, nonatomic) IBOutlet UIImageView *top_image;
@property (weak, nonatomic) IBOutlet UIView *navigation_View;
@property (weak, nonatomic) IBOutlet UIButton *nav_back;
@property (weak, nonatomic) IBOutlet UILabel *nav_title;
@property (weak, nonatomic) IBOutlet UILabel *jhm_lab;

@property (weak, nonatomic) IBOutlet UIView *top_view;
@property (weak, nonatomic) IBOutlet UIImageView *tx_image;
@property (weak, nonatomic) IBOutlet UILabel *name_lab;

@property (weak, nonatomic) IBOutlet UIImageView *hg_lab;
@property (weak, nonatomic) IBOutlet UIImageView *bg_U_image;
@property (weak, nonatomic) IBOutlet UIButton *dj_btn;
@property (weak, nonatomic) IBOutlet UILabel *ktfs_lab;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *xz_ktfs_lab;
@property (weak, nonatomic) IBOutlet UIView *zfb_view;
@property (weak, nonatomic) IBOutlet UILabel *zfb_title_lab;
@property (weak, nonatomic) IBOutlet UILabel *zfb_number_lab;
@property (weak, nonatomic) IBOutlet UILabel *zfb_gq_number_lab;


@property (weak, nonatomic) IBOutlet UIView *jhm_view;
@property (weak, nonatomic) IBOutlet UILabel *jhm_view_lab;
@property (weak, nonatomic) IBOutlet UIView *sr_jhm_view;
@property (weak, nonatomic) IBOutlet UIView *sr_jhm_view_title;
@property (weak, nonatomic) IBOutlet UITextField *sr_jhm_view_textfield;
@property (weak, nonatomic) IBOutlet UIButton *kaitong_btn;
@property (weak, nonatomic) IBOutlet UILabel *quanyi_Vip_lab;


@property (weak, nonatomic) IBOutlet UILabel *quanyi_lab;


//开通方式 yes 默认支付包
@property (nonatomic , assign) BOOL isType;

@end

@implementation HCTheMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#2E2F37"];
    self.isType = YES;
    [self loadUI];
    [self ViewAction];
    [self getActivationCodeData];
    
    
    
}

#pragma 获取激活码数量
- (void)getActivationCodeData{
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/key/get/count" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            if ([responseObject[@"data"] intValue] > 0) {
                [self.jhm_lab setHidden:NO];
            }
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

- (void)backAction{
    [self.xp_rootNavigationController popViewControllerAnimated:YES];
}



- (void)ViewAction{
    
    
    
    [self.zfb_view bk_whenTapped:^{
        [self.sr_jhm_view setHidden:YES];
        [self.quanyi_Vip_lab setHidden:NO];
        self.zfb_view.layer.borderColor = [UIColor colorWithHexString:@"#F6D58B"].CGColor;
        self.jhm_view.layer.borderColor = [UIColor colorWithHexString:@"#000000"].CGColor;
        self.isType = YES;
    }];
    
    
    [self.jhm_view bk_whenTapped:^{
        [self.sr_jhm_view setHidden:NO];
        [self.quanyi_Vip_lab setHidden:YES];
        self.zfb_view.layer.borderColor = [UIColor colorWithHexString:@"#000000"].CGColor;
        self.jhm_view.layer.borderColor = [UIColor colorWithHexString:@"#F6D58B"].CGColor;
        self.isType = NO;
    }];
    
    [self.kaitong_btn bk_whenTapped:^{
        if (self.isType) {
            [self 支付宝支付];
        }else{
            [self 使用激活码];
        }
        
    }];

    [self.quanyi_lab bk_whenTapped:^{
        [self.xp_rootNavigationController pushViewController:[HCTheRulesController new] animated:YES];
    }];
    //接收刷新的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadData) name:@"RefreshAlipay" object:nil];
    
}

- (void)支付宝支付{
    
    
    if(![self.dj_btn.titleLabel.text isEqualToString:@"普通"]){
        [XHToast showBottomWithText:@"您已是V1及以上会员，无需充值购买"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"100" forKey:@"amount"];
    [dic setObject:@"0" forKey:@"type"];//支付方式 0 是支付宝
    [dic setObject:@"0" forKey:@"orderType"];//升级V1传0，空卡传1

    [self NetWorkingPostWithAddressURL:self hiddenHUD:YES url:@"/api/payment/invest" Params:dic success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            // NOTE: 如果加签成功，则继续执行支付
        
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"HCAlipay";

            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = responseObject[@"data"];

            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
            
        }
    } failure:^(NSString * _Nonnull error) {

    }];
    
    
    


}

- (void)使用激活码{
    //实名信息判断
    if(![self RealNameAuthentication]){
        return;
    }
    if (self.sr_jhm_view_textfield.text.length == 0) {
        [XHToast showBottomWithText:@"激活码不能为空" duration:1.5];
        return;
    }
    
    @weakify(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.sr_jhm_view_textfield.text forKey:@"key"];
    [self NetWorkingPostWithAddressURL:self hiddenHUD:YES url:@"/api/user/key/use" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            weak_self.sr_jhm_view_textfield.text = @"";
            [self LoadData];
            [XHToast showBottomWithText:responseObject[@"message"]];
            
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}
- (void)LoadData{
    
    //得到个人信息，
    NSDictionary *UserData = [self loadUserData];
    
    [self NetWorkingPostWithURL:self hiddenHUD:YES url:[NSString stringWithFormat:@"/api/user/get/%@",UserData[@"id"]] Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            
            [self updateUserData:responseObject[@"data"]];
            
            self.name_lab.text = UserData[@"fullname"];
            
            if ([UserData[@"vipLevel"] intValue] == 0) {
                [self.dj_btn setTitle:@"普通" forState:UIControlStateNormal];
                
                [self.dj_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(30);
                }];
            }else{
                [self.dj_btn setTitle:[NSString stringWithFormat:@"V%@",UserData[@"vipLevel"]] forState:UIControlStateNormal];
                [self.dj_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(25);
                }];
            }
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];

}


- (void)loadUI{
    
    [self.sr_jhm_view setHidden:YES];
    [self.top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(Ratio(220));
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    [self.navigation_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44));
        make.top.equalTo(self.top_image.mas_top).offset(kStatusBarHeight);
        make.left.equalTo(self.view);
    }];
    [self.nav_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.centerY.equalTo(self.navigation_View);
    }];
    [self.nav_back bk_whenTapped:^{
        [self backAction];
    }];
    [self.nav_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navigation_View);
    }];
    self.jhm_lab.userInteractionEnabled = YES;
    [self.jhm_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.centerY.equalTo(self.navigation_View);
    }];
    [self.jhm_lab bk_whenTapped:^{
        [self.xp_rootNavigationController pushViewController:[HCActivationCodeController new] animated:YES];
    }];
    
    self.top_view.layer.masksToBounds = 10;
    [self.top_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.equalTo(self.top_image.mas_bottom).offset(0);
    }];
    [self.bg_U_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(55);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    self.tx_image.layer.masksToBounds = YES;
    self.tx_image.layer.cornerRadius = 22;
    [self.tx_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.top.offset(20);
        make.left.offset(30);
        make.bottom.equalTo(self.bg_U_image.mas_top).offset(-9);
    }];
    
    [self.name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tx_image.mas_right).offset(14);
        make.centerY.equalTo(self.tx_image);
    }];
    self.dj_btn.layer.masksToBounds = YES;
    self.dj_btn.layer.cornerRadius = 5;
    [self.dj_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(25);
        make.right.offset(-30);
        make.centerY.equalTo(self.tx_image);
    }];
    
    [self.hg_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    
    [self.ktfs_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top_image.mas_bottom).offset(30);
        make.left.offset(30);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.equalTo(self.ktfs_lab.mas_right).offset(30);
        make.right.offset(0);
        make.centerY.equalTo(self.ktfs_lab);
    }];
    self.xz_ktfs_lab.text  = @"还款30万自动开通V1\n选择以下方式抢先开通V1可省至少140元还款手续费";
    [self.xz_ktfs_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ktfs_lab.mas_bottom).offset(3);
        make.left.offset(30);
        make.right.offset(-20);
    }];
    
    double view_W = (DEVICE_WIDTH - 90) / 2;
    self.zfb_view.layer.borderColor = [UIColor colorWithHexString:@"#F6D58B"].CGColor;
    self.zfb_view.layer.borderWidth = 0.5;
    self.zfb_view.layer.cornerRadius = 10;
    [self.zfb_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(view_W, 90));
        make.top.equalTo(self.xz_ktfs_lab.mas_bottom).offset(35);
        make.left.offset(30);
    }];
    
    
    [self.zfb_number_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.zfb_view);
    }];
    [self.zfb_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_zfb_number_lab.mas_top).offset(-2);
        make.centerX.equalTo(self.zfb_view);
    }];
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"¥299" attributes:attribtDic];
    self.zfb_gq_number_lab.attributedText = attribtStr;
    [self.zfb_gq_number_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_zfb_number_lab.mas_bottom).offset(2);
        make.centerX.equalTo(self.zfb_view);
    }];
    
    self.jhm_view.layer.borderColor = [UIColor colorWithHexString:@"#000000"].CGColor;
    self.jhm_view.layer.borderWidth = 0.5;
    self.jhm_view.layer.cornerRadius = 10;
    [self.jhm_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(view_W, 90));
        make.centerY.equalTo(self.zfb_view);
        make.right.offset(-30);
    }];
    
    [self.jhm_view_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.jhm_view);
    }];
    self.sr_jhm_view.layer.borderColor = [UIColor colorWithHexString:@"#F6D58B"].CGColor;
    self.sr_jhm_view.layer.borderWidth = 0.5;
    self.sr_jhm_view.layer.cornerRadius = 10;
    [self.sr_jhm_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-60, 40));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.zfb_view.mas_bottom).offset(25);
    }];
    [self.sr_jhm_view_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(76, 20));
        make.centerY.equalTo(self.sr_jhm_view);
        make.left.offset(10);
    }];
    [self.sr_jhm_view_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(35);
        make.centerY.equalTo(self.sr_jhm_view);
        make.left.equalTo(self.sr_jhm_view_title.mas_right).offset(0);
        make.right.offset(-10);
    }];
    
    
    self.quanyi_Vip_lab.text =  @"V1特权：\n收款手续降低，还款每万元赚8元\n邀请好友升级V1，可获得激活奖励";
    [UILabel changeLineSpaceForLabel:self.quanyi_Vip_lab WithSpace:3];
    
    
    [self.quanyi_Vip_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH-60);
        make.left.offset(40);
        make.top.equalTo(self.zfb_view.mas_bottom).offset(22);
    }];
    
    
    [self.kaitong_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-60, 46));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.sr_jhm_view.mas_bottom).offset(30);
    }];
    [self.kaitong_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-60, 46));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.sr_jhm_view.mas_bottom).offset(30);
    }];
    [self.quanyi_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 33));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.kaitong_btn.mas_bottom).offset(5);
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self LoadData];
    //实名信息判断
    [self RealNameAuthentication];
}

@end
