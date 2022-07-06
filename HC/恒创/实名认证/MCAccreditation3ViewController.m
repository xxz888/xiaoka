//
//  MCAccreditation3ViewController.m
//  OEMSDK
//
//  Created by tuibao on 2021/11/4.
//

#import "MCAccreditation3ViewController.h"

#import "liveness/Liveness.h"

@interface MCAccreditation3ViewController ()<LivenessDetectDelegate>

@end

@implementation MCAccreditation3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //添加约束
    [self loadUI];
    
}

- (void)getRLSBaction{
    
    // UI设置，默认不用设置
    NSDictionary *uiConfig = @{
       @"bottomAreaBgColor":@"F08300"    //屏幕下方颜色 026a86
       ,@"navTitleColor": @"FFFFFF"      // 导航栏标题颜色 FFFFFF
       ,@"navBgColor": @"F08300"         // 导航栏背景颜色 0186aa
       ,@"navTitle": @"人脸识别"          // 导航栏标题 活体检测
       ,@"navTitleSize":@"18"            // 导航栏标题大小 20
    };
    NSDictionary *bizData = @{
       @"liveness_app_id":@"tyTht9CbbhCQUnGN",
       @"liveness_app_secrect": @"tyTht9CbbhCQUnGNOpC4ClmN9uCUjCRq"
    };
    NSDictionary *param = @{@"actions":@"1279",
                            @"actionsNum":@"3",
                            @"bizData":bizData,
                            @"uiConfig":uiConfig};
    //不支持模拟器运行的方法
    [[Liveness shareInstance] startProcess:self withParam:param withDelegate:self];

    
}

- (void)backAction{
    [self backToAppointedController:[HCHomeViewController new]];
}



#pragma mark -----------活物识别完成,回调到这个界面---------------
- (void)onLiveDetectCompletion:(NSDictionary *)result{
    
    //code = 0;等于检测成功
    if ([result[@"code"] intValue] == 0) {
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:result[@"passImgPath"]];
        
//        UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
//        imageview.frame = CGRectMake(100, 100, 200, 200);
//        [self.view addSubview:imageview];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:image forKey:@"file"];


        [self NetWorkingPostWithImageURL:self hiddenHUD:YES url:@"/api/user/face/upload" Params:params success:^(id  _Nonnull responseObject) {
            if ([responseObject[@"code"] intValue] == 0) {
                
                // 得到个人信息，判断token
                NSMutableDictionary *UserData = [NSMutableDictionary dictionaryWithDictionary:[self loadUserData]];
                [UserData setObject:@"2" forKey:@"selfLevel"];
                [UserData setObject:self.user_name forKey:@"fullname"];
                
                [self updateUserData:UserData];
                
                
                [self.xp_rootNavigationController pushViewController:[MCAccreditation4ViewController new] animated:YES];
                
            }else{
                [XHToast showBottomWithText:responseObject[@"message"]];
            }
        } failure:^(NSString * _Nonnull error) {
            [XHToast showBottomWithText:error];
        }];
    }else{
        [XHToast showBottomWithText:@"识别错误，请重试"];
    }
    
    
    /*----------------增加活体检验------------------*/
    [self NetWorkingPostWithURL:self hiddenHUD:YES url:@"/api/user/bioassay/add/count" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject[@"code"]);
    } failure:^(NSString * _Nonnull error) {
        [XHToast showBottomWithText:error];
    }];
    
    
}

- (void)loadUI{
    
    
    [self.view addSubview:self.top_image];
    [self.top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(Ratio(161));
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    [self.view addSubview:self.navigation_View];
    [self.navigation_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44));
        make.top.equalTo(self.top_image.mas_top).offset(kStatusBarHeight);
        make.left.equalTo(self.view);
    }];
    
    [self.view addSubview:self.nav_back];
    [self.nav_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.centerY.equalTo(self.navigation_View);
    }];
    [self.view addSubview:self.nav_title];
    [self.nav_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navigation_View);
    }];
    
    [self.view addSubview:self.rlsb_image];
    [self.rlsb_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(self.top_image.mas_top).offset(Ratio(100));
        make.centerX.equalTo(self.view);
    }];
    [self.view addSubview:self.rlsb_lab];
    [self.rlsb_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rlsb_image.mas_bottom).offset(Ratio(7.5));
        make.centerX.equalTo(self.rlsb_image);
    }];

    [self.view addSubview:self.sfz_image];
    [self.sfz_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.rlsb_image);
        make.left.offset(61);
    }];
    [self.view addSubview:self.sfz_lab];
    [self.sfz_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sfz_image.mas_bottom).offset(Ratio(7.5));
        make.centerX.equalTo(self.sfz_image);
    }];
    [self.view addSubview:self.xyk_image];
    [self.xyk_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.rlsb_image);
        make.right.equalTo(self.top_image.mas_right).offset(-61);
    }];
    [self.view addSubview:self.txyk_lab];
    [self.txyk_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyk_image.mas_bottom).offset(Ratio(7.5));
        make.centerX.equalTo(self.xyk_image);
    }];
    [self.view addSubview:self.left_line_View];
    [self.left_line_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.centerY.equalTo(self.rlsb_image);
        make.left.equalTo(self.sfz_image.mas_right).offset(5);
        make.right.equalTo(self.rlsb_image.mas_left).offset(-5);
    }];
    [self.view addSubview:self.right_line_View];
    [self.right_line_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.centerY.equalTo(self.rlsb_image);
        make.left.equalTo(self.rlsb_image.mas_right).offset(5);
        make.right.equalTo(self.xyk_image.mas_left).offset(-5);
    }];
    
    
    [self.view addSubview:self.tishi_lab];
    [self.tishi_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top_image.mas_bottom).offset(Ratio(24));
        make.centerX.equalTo(self.view);
    }];
    [self.view addSubview:self.rlsb_center_imageView];
    [self.rlsb_center_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tishi_lab.mas_bottom).offset(Ratio(18));
        make.centerX.equalTo(self.view);
    }];
    [self.view addSubview:self.jingshi1_lab];
    [self.jingshi1_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rlsb_center_imageView.mas_bottom).offset(Ratio(20));
        make.centerX.equalTo(self.view);
    }];
    [self.view addSubview:self.jingshi2_lab];
    [self.jingshi2_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jingshi1_lab.mas_bottom).offset(Ratio(10));
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.shouji_center_view];
    self.shouji_center_view.layer.cornerRadius = Ratio(41)/2;
    [self.shouji_center_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Ratio(41), Ratio(41)));
        make.top.equalTo(self.jingshi2_lab.mas_bottom).offset(Ratio(20));
        make.centerX.equalTo(self.view);
    }];
    [self.view addSubview:self.shouji_center_imageView];
    [self.shouji_center_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Ratio(24), Ratio(24)));
        make.center.equalTo(self.shouji_center_view);
    }];
    [self.view addSubview:self.shouji_center_lab];
    [self.shouji_center_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shouji_center_view.mas_bottom).offset(Ratio(10));
        make.centerX.equalTo(self.shouji_center_view);
    }];

    [self.view addSubview:self.shouji_left_view];
    self.shouji_left_view.layer.cornerRadius = Ratio(41)/2;
    [self.shouji_left_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Ratio(41), Ratio(41)));
        make.right.equalTo(self.shouji_center_view.mas_left).offset(-Ratio(54));
        make.centerY.equalTo(self.shouji_center_view);
    }];
    [self.view addSubview:self.shouji_left_imageView];
    [self.shouji_left_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Ratio(24), Ratio(24)));
        make.center.equalTo(self.shouji_left_view);
    }];
    [self.view addSubview:self.shouji_left_lab];
    [self.shouji_left_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shouji_left_view.mas_bottom).offset(Ratio(10));
        make.centerX.equalTo(self.shouji_left_view);
    }];



    [self.view addSubview:self.shouji_right_view];
    self.shouji_right_view.layer.cornerRadius = Ratio(41)/2;
    [self.shouji_right_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Ratio(41), Ratio(41)));
        make.left.equalTo(self.shouji_center_view.mas_right).offset(Ratio(54));
        make.centerY.equalTo(self.shouji_center_view);
    }];
    [self.view addSubview:self.shouji_right_imageView];
    [self.shouji_right_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Ratio(24), Ratio(24)));
        make.center.equalTo(self.shouji_right_view);
    }];
    [self.view addSubview:self.shouji_right_lab];
    [self.shouji_right_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shouji_right_view.mas_bottom).offset(Ratio(10));
        make.centerX.equalTo(self.shouji_right_view);
    }];


    [self.view addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 46));
        make.left.offset(16);
        make.top.equalTo(self.shouji_center_view.mas_bottom).offset(50);
    }];
    

    
}


#pragma 懒加载
- (UIImageView *)top_image{
    if (!_top_image) {
        _top_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HC_TOP_bg"]];
        _top_image.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _top_image;
}
- (UIView *)navigation_View{
    if (!_navigation_View) {
        _navigation_View = [UIView new];
    }
    return _navigation_View;
}
- (UIButton *)nav_back{
    if (!_nav_back) {
        _nav_back = [UIButton new];
        [_nav_back setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_nav_back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_nav_back setEnlargeEdgeWithTop:10 right:20 bottom:10 left:10];
    }
    return _nav_back;
}
- (UILabel *)nav_title{
    if (!_nav_title) {
        _nav_title = [UILabel new];
        _nav_title.text = @"人脸识别";
        _nav_title.textColor = FontThemeColor;
        _nav_title.font = [UIFont boldSystemFontOfSize:18];
    }
    return _nav_title;
}


- (UIImageView *)sfz_image{
    if (!_sfz_image) {
        _sfz_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HC_top_unselect"]];
    }
    return _sfz_image;
}
- (UIView *)left_line_View{
    if (!_left_line_View) {
        _left_line_View = [UIView new];
        _left_line_View.backgroundColor = [UIColor whiteColor];
    }
    return _left_line_View;
}
- (UIImageView *)rlsb_image{
    if (!_rlsb_image) {
        _rlsb_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HC_top_select"]];
    }
    return _rlsb_image;
}
- (UIView *)right_line_View{
    if (!_right_line_View) {
        _right_line_View = [UIView new];
        _right_line_View.backgroundColor = [UIColor whiteColor];
    }
    return _right_line_View;
}
- (UIImageView *)xyk_image{
    if (!_xyk_image) {
        _xyk_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HC_top_unselect"]];
    }
    return _xyk_image;
}
- (UILabel *)sfz_lab{
    if (!_sfz_lab) {
        _sfz_lab = [UILabel new];
        _sfz_lab.text = @"添加身份证";
        _sfz_lab.textColor = [UIColor whiteColor];
        _sfz_lab.font = [UIFont systemFontOfSize:12];
        _sfz_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _sfz_lab;
}

- (UILabel *)rlsb_lab{
    if (!_rlsb_lab) {
        _rlsb_lab = [UILabel new];
        _rlsb_lab.text = @"人脸识别";
        _rlsb_lab.textColor = FontThemeColor;
        _rlsb_lab.font = [UIFont systemFontOfSize:12];
        _rlsb_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _rlsb_lab;
}

- (UILabel *)txyk_lab{
    if (!_txyk_lab) {
        _txyk_lab = [UILabel new];
        _txyk_lab.text = @"添加结算卡";
        _txyk_lab.textColor = [UIColor whiteColor];
        _txyk_lab.font = [UIFont systemFontOfSize:12];
        _txyk_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _txyk_lab;
}

- (UILabel *)tishi_lab{
    if (!_tishi_lab) {
        _tishi_lab = [UILabel new];
        _tishi_lab.text = @"拿起手机，眨眨眼";
        _tishi_lab.textColor = [UIColor colorWithHexString:@"333333"];
        _tishi_lab.font = [UIFont systemFontOfSize:15];
        _tishi_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _tishi_lab;
}

- (UIImageView *)rlsb_center_imageView{
    if (!_rlsb_center_imageView) {
        _rlsb_center_imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_renlian"]];
    }
    return _rlsb_center_imageView;
}
- (UILabel *)jingshi1_lab{
    if (!_jingshi1_lab) {
        _jingshi1_lab = [UILabel new];
        _jingshi1_lab.text = @"确认本人操作";
        _jingshi1_lab.textColor = [UIColor colorWithHexString:@"9E9E9E"];
        _jingshi1_lab.font = [UIFont systemFontOfSize:12];
        _jingshi1_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _jingshi1_lab;
}
- (UILabel *)jingshi2_lab{
    if (!_jingshi2_lab) {
        _jingshi2_lab = [UILabel new];
        _jingshi2_lab.text = @"保持正脸在取景框中根据屏幕指示完成";
        _jingshi2_lab.textColor = [UIColor colorWithHexString:@"9E9E9E"];
        _jingshi2_lab.font = [UIFont systemFontOfSize:12];
        _jingshi2_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _jingshi2_lab;
}


- (UIView *)shouji_left_view{
    if (!_shouji_left_view) {
        _shouji_left_view = [UIView new];
        _shouji_left_view.backgroundColor = [UIColor colorWithHexString:@"FDF5EC"];
    }
    return _shouji_left_view;
}
- (UIImageView *)shouji_left_imageView{
    if (!_shouji_left_imageView) {
        _shouji_left_imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_renlian_left"]];
    }
    return _shouji_left_imageView;
}
- (UILabel *)shouji_left_lab{
    if (!_shouji_left_lab) {
        _shouji_left_lab = [UILabel new];
        _shouji_left_lab.text = @"正对手机";
        _shouji_left_lab.textColor = [UIColor colorWithHexString:@"535353"];
        _shouji_left_lab.font = [UIFont systemFontOfSize:12];
        _shouji_left_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _shouji_left_lab;
}

- (UIView *)shouji_center_view{
    if (!_shouji_center_view) {
        _shouji_center_view = [UIView new];
        _shouji_center_view.backgroundColor = [UIColor colorWithHexString:@"FDF5EC"];
    }
    return _shouji_center_view;
}
- (UIImageView *)shouji_center_imageView{
    if (!_shouji_center_imageView) {
        _shouji_center_imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_renlian_center"]];
    }
    return _shouji_center_imageView;
}
- (UILabel *)shouji_center_lab{
    if (!_shouji_center_lab) {
        _shouji_center_lab = [UILabel new];
        _shouji_center_lab.text = @"光线充足";
        _shouji_center_lab.textColor = [UIColor colorWithHexString:@"535353"];
        _shouji_center_lab.font = [UIFont systemFontOfSize:12];
        _shouji_center_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _shouji_center_lab;
}

- (UIView *)shouji_right_view{
    if (!_shouji_right_view) {
        _shouji_right_view = [UIView new];
        _shouji_right_view.backgroundColor = [UIColor colorWithHexString:@"FDF5EC"];
    }
    return _shouji_right_view;
}
- (UIImageView *)shouji_right_imageView{
    if (!_shouji_right_imageView) {
        _shouji_right_imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_renlian_right"]];
    }
    return _shouji_right_imageView;
}
- (UILabel *)shouji_right_lab{
    if (!_shouji_right_lab) {
        _shouji_right_lab = [UILabel new];
        _shouji_right_lab.text = @"脸无遮挡";
        _shouji_right_lab.textColor = [UIColor colorWithHexString:@"535353"];
        _shouji_right_lab.font = [UIFont systemFontOfSize:12];
        _shouji_right_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _shouji_right_lab;
}

- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton new];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"KD_BindCardBtn"] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"开始检测" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_finishBtn addTarget:self action:@selector(getRLSBaction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _finishBtn;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
@end
