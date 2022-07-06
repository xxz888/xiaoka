//
//  HCMallMyController.m
//  HC
//
//  Created by tuibao on 2021/12/13.
//

#import "HCMallMyController.h"
#import "HCMallMyTableViewCell.h"
#import "HCAboutUsController.h"
#import "HCSetUpTheController.h"
#import "HCMallCustomerController.h"
#import "HCNicknameView.h"
#import "HCMallMyCollectionController.h"
#import "HCTabberController.h"
@interface HCMallMyController ()<UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate>

@property(strong, nonatomic) UIImageView *top_imageView;
@property(strong, nonatomic) UIImageView *top_HeadPortrait;
@property(strong, nonatomic) UILabel *top_title;

@property(strong, nonatomic) UIView *content_Views;
@property(strong, nonatomic) NSArray *TitleArr;

@property(strong, nonatomic) UIView *HC_view;


@property(strong, nonatomic) UIView *operation_Views;
@property(strong, nonatomic) UITableView *tableView;

@property(strong, nonatomic) NSArray *dataArr;

@end

@implementation HCMallMyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F0F2F5"];
    [self LoadUI];
    
}


#pragma 跳转恒创
- (void)PushConstantAction{
    
    // 得到个人信息，判断token
    NSDictionary *UserData = [self loadUserData];
    if ([UserData allKeys].count > 0 && ![UserData[@"username"] isEqualToString:@"17365299215"] && ![[UserData[@"preUserId"] stringValue] isEqualToString:@"236323487"]) {
        HCTabberController *tabber = [HCTabberController new];
        //退出到登录页
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController = tabber;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
    self.navigationController.navigationBarHidden = YES;
    
    if([self 去登录]){
        NSDictionary *Userdic = [self loadUserData];
        self.top_title.text = [Userdic[@"nick"] length] == 0 ? @"暂无昵称": Userdic[@"nick"];
    }
    [self PushConstantAction];
}

- (void)addNick{
    if (![self 去登录]) return;
    @weakify(self);
    HCNicknameView *trading = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HCNicknameView class]) owner:nil options:nil] lastObject];
    trading.width = DEVICE_WIDTH - 40;
    trading.height = 320;
    trading.layer.cornerRadius = 8;
    //弹窗实例创建
    LSTPopView *popView = [LSTPopView initWithCustomView:trading
                                                  popStyle:LSTPopStyleSpringFromTop
                                              dismissStyle:LSTDismissStyleSmoothToTop];
    LSTPopViewWK(popView)
    [trading.btn bk_whenTapped:^{
        if (trading.textfield.text.length > 0 ) {
            [weak_self NetWorkingPostWithAddressURL:self hiddenHUD:NO url:@"/api/user/update/nick" Params:@{@"nick":trading.textfield.text} success:^(id  _Nonnull responseObject) {
                if ([responseObject[@"code"] intValue] == 0) {
                    self.top_title.text = trading.textfield.text;
                    [XHToast showBottomWithText:responseObject[@"message"]];
                    
                    // 得到个人信息，判断token
                    NSMutableDictionary *UserData = [NSMutableDictionary dictionaryWithDictionary:[self loadUserData]];
                    [UserData setObject:trading.textfield.text forKey:@"nick"];
                    [self updateUserData:UserData];
                    
                }else{
                    [XHToast showBottomWithText:responseObject[@"message"]];
                }
            } failure:^(NSString * _Nonnull error) {
                
            }];
        }
        [wk_popView dismiss];
    }];
    popView.bgClickBlock = ^{
        [wk_popView dismiss];
    };
    [popView pop];
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"HCMallMyTableViewCell";
    HCMallMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCMallMyTableViewCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.name_lab.text = self.dataArr[indexPath.row][@"name"];
    cell.icon_image.image = [UIImage imageNamed:self.dataArr[indexPath.row][@"image"]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //关于我们
    if(indexPath.row == 2){
        [self.xp_rootNavigationController pushViewController:[HCAboutUsController new] animated:YES];
    }
    //设置
    else if(indexPath.row == 3) {
        if (![self 去登录]) return;
        [self.xp_rootNavigationController pushViewController:[HCSetUpTheController new] animated:YES];
    }
    //客服中心
    else if(indexPath.row == 1) {
        [self.xp_rootNavigationController pushViewController:[HCMallCustomerController new] animated:YES];
    }
    //我的收藏
    else if(indexPath.row == 0) {
        if (![self 去登录]) return;
        [self.xp_rootNavigationController pushViewController:[HCMallMyCollectionController new] animated:YES];
    }

}

- (void)LoadUI{
    

    self.TitleArr = [NSArray arrayWithObjects:
                     @{@"name":@"待支付",@"image":@"mall_my_daizhifu"},
                     @{@"name":@"待发货",@"image":@"mall_my_daifahuo"},
                     @{@"name":@"已发货",@"image":@"mall_my_yifahuo"},
                     @{@"name":@"已完成",@"image":@"mall_my_yiwancheng"}, nil];

    self.dataArr = [NSArray arrayWithObjects:
                    @{@"name":@"我的收藏",@"image":@"mall_icon_collection"},
                     @{@"name":@"客服中心",@"image":@"icon_kefu"},
                     @{@"name":@"关于我们",@"image":@"icon_guanyu"},
                     @{@"name":@"系统设置",@"image":@"icon_shezhi"},nil];
    
    [self.view addSubview:self.top_imageView];
    [self.top_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 130 + kTopHeight));
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
        make.centerY.equalTo(self.top_HeadPortrait);
    }];

    
    
    [self.view addSubview:self.content_Views];
    [self.content_Views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 100));
        make.left.offset(15);
        make.top.equalTo(self.top_imageView.mas_bottom).offset(-50);
    }];
    
    [self.view addSubview:self.HC_view];
    [self.HC_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.left.offset(0);
        make.top.equalTo(self.content_Views.mas_bottom).offset(15);
    }];
    
    
    
    [self.view addSubview:self.operation_Views];
    [self.operation_Views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, self.dataArr.count * 50 + 20));
        make.left.offset(15);
        make.top.equalTo(self.HC_view.mas_bottom).offset(15);
    }];
    
    [self.operation_Views addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, self.dataArr.count * 50));
        make.left.offset(0);
        make.centerY.equalTo(self.operation_Views);
    }];
}

- (void)getTitleAction:(NSInteger)index{
    if (![self 去登录]) return;
    HCMallOrderController *VC = [HCMallOrderController new];
    VC.index = index;
    [self.xp_rootNavigationController pushViewController:VC animated:YES];
    
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
        _top_title.text = @"暂无昵称";
        _top_title.font = [UIFont getUIFontSize:15 IsBold:YES];
        _top_title.textColor = [UIColor whiteColor];
        _top_title.userInteractionEnabled = YES;
        [_top_title bk_whenTapped:^{
            [self addNick];
        }];
    }
    return _top_title;
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
            [_content_Views addSubview:views];
            [views mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(view_W);
                make.left.offset(X);
                make.centerY.equalTo(_content_Views);
            }];
            [views bk_whenTapped:^{
                [self getTitleAction:i];
            }];
            
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dic[@"image"]]];
            [views addSubview:image];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.centerX.equalTo(views);
            }];
            UILabel *title = [UILabel new];
            title.font = [UIFont getUIFontSize:14 IsBold:NO];
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = [UIColor blackColor];
            title.text = dic[@"name"];
            [views addSubview:title];
            [title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(20);
                make.centerX.equalTo(views);
                make.top.equalTo(image.mas_bottom).offset(8);
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

- (UIView *)HC_view{
    if (!_HC_view) {
        _HC_view = [UIView new];
        UIImageView *icon_BG = [UIImageView getUIImageView:@"mall_HC_BG"];
        icon_BG.ylCornerRadius = 10;
        [_HC_view addSubview:icon_BG];
        [icon_BG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.offset(15);
            make.right.offset(-15);
        }];
        
        UIView *content = [UIView new];
        [_HC_view addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_HC_view);
            make.top.bottom.offset(0);
            make.height.offset(80);
        }];
        UIImageView *icon_img = [UIImageView getUIImageView:@"mall_HC_Icon"];
        [content addSubview:icon_img];
        [icon_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(content);
            make.left.offset(0);
        }];
        UIImageView *name_img = [UIImageView getUIImageView:@"mall_HC_Name"];
        [content addSubview:name_img];
        [name_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(content);
            make.left.equalTo(icon_img.mas_right).offset(5);
            make.right.offset(0);
        }];
        [_HC_view bk_whenTapped:^{
            [self PushConstantAction];
        }];
    }
    return _HC_view;
}


@end
