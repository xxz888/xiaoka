//
//  HCMyViewController.m
//  HC
//
//  Created by tuibao on 2021/11/6.
//

#import "HCMyViewController.h"
#import "HCMyTableViewCell.h"
#import "HCReturnsDetailedController.h"
#import "HCPersonalCenterController.h"
#import "HCMaterialController.h"
#import "HCAboutUsController.h"
#import "HCAuthorizedAgentsView.h"
@interface HCMyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UIImageView *top_imageView;
@property(strong, nonatomic) UIImageView *top_HeadPortrait;
@property(strong, nonatomic) UILabel *top_title;
@property(strong, nonatomic) UILabel *top_members;
@property(strong, nonatomic) UILabel *top_phone;
@property(strong, nonatomic) UILabel *top_id;
@property(strong, nonatomic) UIButton *top_personalData;
@property(strong, nonatomic) UISwitch *TopSwitch;
@property(strong, nonatomic) UISwitch *bottomSwitch;
@property(strong, nonatomic) UIView *content_line_gold;

@property(strong, nonatomic) UIView *content_Views;
@property(strong, nonatomic) NSArray *TitleArr;

@property(strong, nonatomic) UIView *operation_Views;
@property(strong, nonatomic) UITableView *tableView;

@property(strong, nonatomic) NSArray *dataArr;

@end

@implementation HCMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self LoadUI];
}
#pragma 开启中介授权
- (void)AuthorizedAgents:(UISwitch *)sw{
    
    if (!sw.on) {
        [self agents];
    }else{
        @weakify(self);
        HCAuthorizedAgentsView *trading = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HCAuthorizedAgentsView class]) owner:nil options:nil] lastObject];
        trading.frame = CGRectMake(0, 0, DEVICE_WIDTH - 40, 320);
        
        trading.layer.cornerRadius = 8;
        //弹窗实例创建
        LSTPopView *popView = [LSTPopView initWithCustomView:trading
                                                      popStyle:LSTPopStyleSpringFromTop
                                                  dismissStyle:LSTDismissStyleSmoothToTop];
        LSTPopViewWK(popView)
        [trading.left_btn bk_whenTapped:^{
            weak_self.TopSwitch.on = NO;
            [wk_popView dismiss];
        }];
        [trading.right_btn bk_whenTapped:^{
            [wk_popView dismiss];
            [weak_self agents];
        }];
        [popView pop];
    }
}


- (void)agents{
    @weakify(self);
    [self NetWorkingPostWithAddressURL:self hiddenHUD:NO url:@"/api/user/empower/switch" Params:@{@"status":@(self.TopSwitch.on)} success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            if (self.TopSwitch.on) {
                [XHToast showBottomWithText:@"开启成功"];
            }else{
                [XHToast showBottomWithText:@"关闭成功"];
            }
            
        }else{
            weak_self.TopSwitch.on = !weak_self.TopSwitch.on;
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
#pragma 开启分润
- (void)FenRunVoice:(UISwitch *)sw{
    
    @weakify(self);
    [self NetWorkingPostWithAddressURL:self hiddenHUD:NO url:@"/api/user/msg/sound/switch" Params:@{@"status":@(sw.on)} success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            if (sw.on) {
                [XHToast showBottomWithText:@"开启成功"];
            }else{
                [XHToast showBottomWithText:@"关闭成功"];
            }
            NSMutableDictionary *UserData = [NSMutableDictionary dictionaryWithDictionary:[self loadUserData]];
            [UserData setObject:[NSString stringWithFormat:@"%i",sw.on] forKey:@"msgSound"];
            [self updateUserData:UserData];
        }else{
            weak_self.bottomSwitch.on = !weak_self.bottomSwitch.on;
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
- (void)getTitleAction:(NSInteger)index{
    
    //收益明细
    if (index == 1) {
        [self.xp_rootNavigationController pushViewController:[HCReturnsDetailedController new] animated:YES];
    }
    //素材管理
    else if(index == 2) {
//        [self.xp_rootNavigationController pushViewController:[HCMaterialController new] animated:YES];
        [self.xp_rootNavigationController pushViewController:[HCTheQueryMaterrialController new] animated:YES];
        
    }
    //收益规则
    else if(index == 0) {
        [self.xp_rootNavigationController pushViewController:[HCTheRulesController new] animated:YES];
    }
    //我的团队
    else if(index == 3) {
        HCBetweenStraightController *VC = [HCBetweenStraightController new];
        VC.type = @"团队";
        [self.xp_rootNavigationController pushViewController:VC animated:YES];
    }
    
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"HCMyTableViewCell";
    HCMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCMyTableViewCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.name_lab.text = self.dataArr[indexPath.row][@"name"];
    cell.icon_image.image = [UIImage imageNamed:self.dataArr[indexPath.row][@"image"]];
    
    if (indexPath.row == 5) {
        [cell.contentView addSubview:self.TopSwitch];
        [self.TopSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 30));
            make.centerY.equalTo(cell.contentView);
            make.right.offset(-15);
        }];
        [cell.right_but setHidden:YES];
    }else if (indexPath.row == 6) {
        [cell.contentView addSubview:self.bottomSwitch];
        [self.bottomSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 30));
            make.centerY.equalTo(cell.contentView);
            make.right.offset(-15);
        }];
        [cell.right_but setHidden:YES];
    }else{
        [cell.right_but setHidden:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //邀请好友
    if (indexPath.row == 0) {
        [self.xp_rootNavigationController pushViewController:[HCInviteFriendsController new] animated:YES];
    }
    //使用帮助
    else if(indexPath.row == 1) {
        [self.xp_rootNavigationController pushViewController:[HCHelpController new] animated:YES];
    }
    //客服中心
    else if(indexPath.row == 2) {
        [self.xp_rootNavigationController pushViewController:[HCCustomerServiceController new] animated:YES];
    }
    //关于我们
    else if(indexPath.row == 3) {
        [self.xp_rootNavigationController pushViewController:[HCAboutUsController new] animated:YES];
    }
    //设置
    else if(indexPath.row == 4) {
        [self.xp_rootNavigationController pushViewController:[HCSetUpTheController new] animated:YES];
    }

}
- (void)LoadUI{
    
    self.TitleArr = [NSArray arrayWithObjects:
                     @{@"name":@"收益规则",@"image":@"icon_guize"},
                     @{@"name":@"收益明细",@"image":@"icon_mingxi"},
                     @{@"name":@"素材管理",@"image":@"icon_shucai"},
                     @{@"name":@"我的团队",@"image":@"icon_tuandui"}, nil];
    
    self.dataArr = [NSArray arrayWithObjects:
                     @{@"name":@"邀请好友",@"image":@"icon_yaoqinghaoyou"},
                     @{@"name":@"使用帮助",@"image":@"icon_help"},
                     @{@"name":@"客服中心",@"image":@"icon_kefu"},
                     @{@"name":@"关于我们",@"image":@"icon_guanyu"},
                     @{@"name":@"系统设置",@"image":@"icon_shezhi"},
                    @{@"name":@"开启上级权限",@"image":@"HC_My_authorization"},
                    @{@"name":@"开启分润声音",@"image":@"HC_My_ voice"},nil];
    
    [self.view addSubview:self.top_imageView];
    [self.top_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 150 + kTopHeight));
        make.top.right.left.offset(0);
    }];
    self.top_HeadPortrait.layer.masksToBounds = YES;
    self.top_HeadPortrait.layer.cornerRadius = 31;
    [self.view addSubview:self.top_HeadPortrait];
    [self.top_HeadPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(62, 62));
        make.left.offset(15);
        make.top.equalTo(self.top_imageView.mas_top).offset(kTopHeight-9);
    }];
    [self.view addSubview:self.top_title];
    [self.top_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.top_HeadPortrait.mas_right).offset(12);
        make.top.equalTo(self.top_HeadPortrait.mas_top).offset(8);
    }];
    
    self.top_members.layer.masksToBounds = YES;
    self.top_members.layer.cornerRadius = 10;
    [self.view addSubview:self.top_members];
    [self.top_members mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.top_title.mas_right).offset(10);
        make.centerY.equalTo(self.top_title);
    }];
    
    [self.view addSubview:self.top_phone];
    [self.top_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.top_title.mas_left).offset(0);
        make.top.equalTo(self.top_title.mas_bottom).offset(5);
    }];
    [self.view addSubview:self.top_id];
    [self.top_id mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.top_phone.mas_left).offset(0);
        make.top.equalTo(self.top_phone.mas_bottom).offset(5);
    }];
    [self.view addSubview:self.top_personalData];
    [self.top_personalData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.top_HeadPortrait);
    }];
    
    [self.view addSubview:self.content_line_gold];
    [self.content_line_gold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 1.0));
        make.left.offset(0);
        make.top.equalTo(self.top_imageView.mas_bottom).offset(0);
    }];
    
    UIView *content_line = [UIView new];
    content_line.backgroundColor = [UIColor colorWithHexString:@"#f9bb00"];
    [self.view addSubview:content_line];
    [content_line getPartOfTheCornerRadius:CGRectMake(0, 0, DEVICE_WIDTH - 28, 63) CornerRadius:10 UIRectCorner:UIRectCornerTopLeft | UIRectCornerTopRight];
    [content_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 28, 63));
        make.left.offset(14);
        make.bottom.equalTo(self.top_imageView.mas_bottom);
    }];
    
    
    [self.view addSubview:self.content_Views];
    [self.content_Views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 124));
        make.left.offset(15);
        make.top.equalTo(self.top_imageView.mas_bottom).offset(-62);
    }];
    
    [self.view addSubview:self.operation_Views];
    [self.operation_Views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, self.dataArr.count * 44 + 10));
        make.left.offset(15);
        make.top.equalTo(self.content_Views.mas_bottom).offset(10);
    }];
    
    [self.operation_Views addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, self.dataArr.count * 44));
        make.left.offset(0);
        make.centerY.equalTo(self.operation_Views);
    }];
    
    
}

- (UIView *)content_line_gold{
    if (!_content_line_gold) {
        _content_line_gold = [UIView new];
        _content_line_gold.backgroundColor = [UIColor colorWithHexString:@"#f9bb00"];
    }
    return _content_line_gold;
}

- (UIImageView *)top_imageView{
    if (!_top_imageView) {
        _top_imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_my_topBG"]];
        _top_imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _top_imageView;
}
- (UIImageView *)top_HeadPortrait{
    if (!_top_HeadPortrait) {
        _top_HeadPortrait = [UIImageView getUIImageView:@"icon_touxiang"];
    }
    return _top_HeadPortrait;
}

- (UILabel *)top_title{
    if (!_top_title) {
        _top_title = [UILabel new];
        _top_title.text = @"熊威";
        _top_title.font = [UIFont getUIFontSize:15 IsBold:YES];
        _top_title.textColor = [UIColor colorWithHexString:@"#F9D8AE"];
    }
    return _top_title;
}
- (UILabel *)top_members{
    if (!_top_members) {
        _top_members = [UILabel new];
        _top_members.text = @"V1";
        _top_members.textAlignment = NSTextAlignmentCenter;
        _top_members.font = [UIFont getUIFontSize:10 IsBold:YES];
        _top_members.backgroundColor = [UIColor colorWithHexString:@"#F9D8AE"];
        _top_members.textColor = [UIColor blackColor];
    }
    return _top_members;
}
- (UILabel *)top_phone{
    if (!_top_phone) {
        _top_phone = [UILabel new];
        _top_phone.text = @"152****0828";
        _top_phone.font = [UIFont getUIFontSize:10 IsBold:YES];
        _top_phone.textColor = [UIColor colorWithHexString:@"#F9D8AE"];
    }
    return _top_phone;
}

- (UILabel *)top_id{
    if (!_top_id) {
        _top_id = [UILabel new];
//        _top_id.text = @"ID:2002020202";
        _top_id.font = [UIFont getUIFontSize:9 IsBold:NO];
        _top_id.textColor = FontThemeColor;
    }
    return _top_id;
}

- (UIButton *)top_personalData{
    if (!_top_personalData) {
        _top_personalData = [[UIButton alloc]init];
        [_top_personalData setTitle:@"个人资料" forState:UIControlStateNormal];
        [_top_personalData setTitleColor:[UIColor colorWithHexString:@"#FAE0BC"] forState:UIControlStateNormal];
        _top_personalData.titleLabel.font = [UIFont getUIFontSize:12 IsBold:NO];
        [_top_personalData setImage:[UIImage imageNamed:@"icon_you_h"] forState:UIControlStateNormal];
        [_top_personalData layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
        [_top_personalData bk_whenTapped:^{
            [self.xp_rootNavigationController pushViewController:[HCPersonalCenterController new] animated:YES];
        }];
    }
    return _top_personalData;
}
- (UIView *)content_Views{
    if (!_content_Views) {
        _content_Views = [UIView new];
        self.content_Views.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        self.content_Views.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
        self.content_Views.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
        self.content_Views.layer.shadowRadius = 3;// 阴影半径，默认3
        self.content_Views.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
        self.content_Views.layer.cornerRadius = 10;
        
        
        
 
        CGFloat X = 0;
        double view_W = (DEVICE_WIDTH-30)/4;
        for (int i = 0; i < _TitleArr.count; i++) {
            
            NSDictionary *dic = _TitleArr[i];
            
            UIView *views = [UIView new];
            views.backgroundColor = [UIColor whiteColor];
            views.userInteractionEnabled = YES;
            [views bk_whenTapped:^{
                [self getTitleAction:i];
            }];
            [_content_Views addSubview:views];
            [views mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(view_W);
                make.left.offset(X);
                make.centerY.equalTo(_content_Views);
            }];
            
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dic[@"image"]]];
            [views addSubview:image];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.centerX.equalTo(views);
            }];
            UILabel *title = [UILabel new];
            title.font = [UIFont getUIFontSize:15 IsBold:YES];
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = [UIColor blackColor];
            title.text = dic[@"name"];
            [views addSubview:title];
            [title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(20);
                make.centerX.equalTo(views);
                make.top.equalTo(image.mas_bottom).offset(5);
                make.bottom.offset(0);
            }];
            
            X = X + view_W;

        }
    }
    return _content_Views;
}



- (UIView *)operation_Views{
    if (!_operation_Views) {
        _operation_Views = [UIView new];
        self.operation_Views.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        self.operation_Views.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
        self.operation_Views.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
        self.operation_Views.layer.shadowRadius = 3;// 阴影半径，默认3
        self.operation_Views.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
        self.operation_Views.layer.cornerRadius = 10;
    }
    return _operation_Views;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        
    }
    return _tableView;
}
- (UISwitch *)TopSwitch{
    if (!_TopSwitch) {
        _TopSwitch = [UISwitch new];
        [_TopSwitch addTarget:self action:@selector(AuthorizedAgents:)forControlEvents:UIControlEventTouchUpInside];
    }
    return _TopSwitch;
}
- (UISwitch *)bottomSwitch{
    if (!_bottomSwitch) {
        _bottomSwitch = [UISwitch new];
        [_bottomSwitch addTarget:self action:@selector(FenRunVoice:)forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *UserData = [self loadUserData];
        _bottomSwitch.on = [UserData[@"msgSound"] boolValue];
    }
    return _bottomSwitch;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //得到个人信息，
    NSDictionary *UserData = [self loadUserData];
    
    
    self.top_phone.text = [NSString getSecrectStringWithPhoneNumber:UserData[@"username"]];
    
    self.TopSwitch.on = [UserData[@"empower"] boolValue];
    
    
    if ([NSString isBlankString:[UserData[@"nick"] stringValue]]) {
        self.top_title.text = [UserData[@"fullname"] length] == 0 ? @"未实名" : UserData[@"fullname"];
    }else{
        self.top_title.text = UserData[@"nick"];
    }
    if ([UserData[@"vipLevel"] intValue] == 0) {
        self.top_members.text = @"普通";
        [self.top_members mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(30);
        }];
    }else{
        self.top_members.text = [NSString stringWithFormat:@"V%@",UserData[@"vipLevel"]];
        [self.top_members mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(20);
        }];
    }
    //禁止单个界面侧滑返回
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}
@end
