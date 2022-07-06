//
//  HCBalancePaymentsController.m
//  HC
//
//  Created by tuibao on 2021/11/9.
//

#import "HCBalancePaymentsController.h"
#import "HCBalancePaymentsCell.h"

@interface HCBalancePaymentsController ()<UITableViewDelegate, UITableViewDataSource , DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic , strong) UIView *top_view;
@property (nonatomic , strong) UIView *ts1_view;
@property (nonatomic , strong) UILabel *ts1_lab;
@property (nonatomic , strong) UIView *ts2_view;
@property (nonatomic , strong) UILabel *ts2_lab;

@property (nonatomic , strong) UIImageView *bottom_image;
@property (nonatomic , strong) UIView *bottom_view;
@property (nonatomic , strong) UIImageView *bottom_left_img;
@property (nonatomic , strong) UILabel *bottom_right_lab;

@property (nonatomic , strong) UITableView *tableView;

//信用卡还款数据
@property (nonatomic , strong) NSArray *CreditData;

//是否启动指示器
@property (nonatomic , assign) BOOL isIndicator;

@end

@implementation HCBalancePaymentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"余额还款";
    //默认第一次启动 启动为NO
    self.isIndicator = NO;
    //接收刷新的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetCreditCard) name:@"RefreshTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetCreditCard) name:@"RefreshCardTable" object:nil];
    [self LoadUI];
    [self GetCreditCard];
    [self GetCreditCardTopData];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.isIndicator = YES;
}

#pragma 获取余额还款首页费率
- (void)GetCreditCardTopData{
    @weakify(self);
    [self NetWorkingPostWithURL:self hiddenHUD:YES url:@"/api/user/get/balance/fee" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        
        if ([responseObject[@"code"] intValue] == 0) {
            NSDictionary *data = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
            weak_self.ts1_lab.text = [NSString stringWithFormat:@"费率：%@（每一万元80元手续费）+%@元/次",@"0.80%",data[@"fee"]];
            double amount = (0.0080 - [data[@"settle"] doubleValue]) * 10000;
            if (amount == 0) {
                weak_self.ts2_lab.text = @"升级V1即可享受，还款金额万分之8的现金";
            }else{
                weak_self.ts2_lab.text =[NSString stringWithFormat:@"每还款一笔，立返当前金额万分之%.0f的现金",amount];
            }
            
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}


#pragma 获取信用卡还款计划
- (void)GetCreditCard{
    @weakify(self);
    [self NetWorkingPostWithURL:self hiddenHUD:self.isIndicator url:@"/api/credit/get/balance/plan/list" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        
        if ([responseObject[@"code"] intValue] == 0) {
            weak_self.CreditData = [NSArray arrayWithArray:responseObject[@"data"]];
            [weak_self.tableView reloadData];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 136;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.CreditData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *Identifier = @"HCBalancePaymentsCell";
    HCBalancePaymentsCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCBalancePaymentsCell" owner:nil options:nil] lastObject];
    }
    
    NSDictionary *dic = self.CreditData[indexPath.row];
    
    cell.title_lab.text = [NSString stringWithFormat:@"%@(%@)",dic[@"bankName"],getAfterFour([dic[@"cardNo"] stringValue])];
    
    cell.yinhang_image.image = [UIImage imageNamed:getBankLogo(dic[@"bankAcronym"])];
    
    cell.content_lab.text = [NSString stringWithFormat:@"账单日 每月%@日丨还款日 每月%@日",dic[@"billDay"],dic[@"repaymentDay"]];
    
    
    //得到还款计划
    NSDictionary *balancePlan = dic[@"balancePlan"];
    
    if ([[dic allKeys] containsObject:@"balancePlan"]) {
        cell.bg_image.image = [UIImage imageNamed:@"icon_xyk_jihua"];
        cell.jihua_lab.text = [NSString stringWithFormat:@"计划执行中，已还款%@元",balancePlan[@"repaymentedAmount"]];
        
        cell.zhiding_jihua_lab.text = @"计划详情";
        
        cell.zhiding_jihua_lab.userInteractionEnabled = NO;
        
        double pro = [balancePlan[@"repaymentedAmount"] doubleValue] / [balancePlan[@"taskAmount"] doubleValue];
        
        cell.progress = [[NSString stringWithFormat:@"%.2f",pro] doubleValue];
        
    }
    else{
        cell.progress = 10000.0f;
        cell.zhiding_jihua_lab.text = @"制定计划";
        cell.zhiding_jihua_lab.userInteractionEnabled = YES;
        cell.jihua_lab.text = @"请及时设置本月还款计划";
        if (indexPath.row%2 == 0) {
            cell.bg_image.image = [UIImage imageNamed:@"icon_xyk_bg1"];
        }
        else{
            cell.bg_image.image = [UIImage imageNamed:@"icon_xyk_bg2"];
        }
    }
    
    [cell.lishi_lab bk_whenTapped:^{
        [self setPushHistoricalRecordController:indexPath.row];
    }];
    
    [cell.zhiding_jihua_lab bk_whenTapped:^{
        [self setPushMakePlanController:indexPath.row];
    }];
    
    
    return cell;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"tableView_Placeholder"];
}
#pragma 无数据点击刷新
-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self GetCreditCard];
    
}
//制定计划
- (void)setPushMakePlanController:(NSInteger)index{
    NSDictionary *dic = self.CreditData[index];
    HCMakePlanController *VC = [HCMakePlanController new];
    VC.cardData = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.xp_rootNavigationController pushViewController:VC animated:YES];
}
//查询当前卡还款计划历史记录
- (void)setPushHistoricalRecordController:(NSInteger)index{
    NSDictionary *dic = self.CreditData[index];
    HCTheHistoricalRecordController *VC = [HCTheHistoricalRecordController new];
    VC.cardData = dic;
    [self.xp_rootNavigationController pushViewController:VC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.CreditData[indexPath.row];
    
    if ([[dic allKeys] containsObject:@"balancePlan"]) {
        //计划详情
        HCPlanDetailsController *VC = [HCPlanDetailsController new];
        VC.cardData = dic;
        VC.planIDStr = dic[@"balancePlan"][@"id"];
        [self.xp_rootNavigationController pushViewController:VC animated:YES];
    }
}

- (void)LoadUI{
    [self.view addSubview:self.top_view];
    [self.top_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(15);
        make.height.offset(64);
    }];
    self.top_view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.top_view.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
    self.top_view.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
    self.top_view.layer.shadowRadius = 3;// 阴影半径，默认3
    self.top_view.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    self.top_view.layer.cornerRadius = 10;
    
    
    [self.top_view addSubview:self.ts1_lab];
    [self.ts1_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(32);
        make.right.offset(-10);
        make.top.offset(10);
        make.height.offset(17);
    }];
    [self.top_view addSubview:self.ts1_view];
    [self.ts1_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(3, 3));
        make.left.offset(22.5);
        make.centerY.equalTo(self.ts1_lab);
    }];
    
    [self.top_view addSubview:self.ts2_lab];
    [self.ts2_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(32);
        make.right.offset(-10);
        make.bottom.offset(-10);
        make.height.offset(17);
    }];
    [self.top_view addSubview:self.ts2_view];
    [self.ts2_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(3, 3));
        make.left.offset(22.5);
        make.centerY.equalTo(self.ts2_lab);
    }];
    
    [self.view addSubview:self.bottom_image];
    [self.bottom_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 46));
        make.left.offset(0);
        make.bottom.offset(-KBottomHeight);
    }];
    
    [self.view addSubview:self.bottom_view];
    [self.bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottom_image);
    }];
    
    [self.bottom_view addSubview:self.bottom_left_img];
    [self.bottom_left_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottom_view);
        make.left.offset(10);
    }];
    [self.bottom_view addSubview:self.bottom_right_lab];
    [self.bottom_right_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottom_view);
        make.left.equalTo(self.bottom_left_img.mas_right).offset(10);
        make.right.offset(-10);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.left.offset(0);
        make.top.equalTo(self.top_view.mas_bottom).offset(10);
        make.bottom.equalTo(self.bottom_image.mas_top).offset(0);
    }];
    
    
}
#pragma 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.showsVerticalScrollIndicator = NO;
        
        
        @weakify(self);
        //下拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weak_self GetCreditCard];
            [weak_self.tableView.mj_header endRefreshing];
        }];
        //上拉加载更多
        _tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weak_self GetCreditCard];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
    }
    return _tableView;
}

- (UIView *)top_view{
    if (!_top_view) {
        _top_view = [UIView new];
    }
    return _top_view;
}
- (UIView *)ts1_view{
    if (!_ts1_view) {
        _ts1_view = [UIView new];
        _ts1_view.backgroundColor = [UIColor colorWithHexString:@"#FF8A00"];
        _ts1_view.layer.cornerRadius = 1.5;
    }
    return _ts1_view;
}
- (UILabel *)ts1_lab{
    if (!_ts1_lab) {
        _ts1_lab = [UILabel new];
        _ts1_lab.text = @"费率：0.80%（每一万元80元手续费）+1元/次";
        _ts1_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        _ts1_lab.font = [UIFont getUIFontSize:12 IsBold:NO];
    }
    return _ts1_lab;
}
- (UIView *)ts2_view{
    if (!_ts2_view) {
        _ts2_view = [UIView new];
        _ts2_view.backgroundColor = [UIColor colorWithHexString:@"#FF8A00"];
        _ts2_view.layer.cornerRadius = 1.5;
    }
    return _ts2_view;
}
- (UILabel *)ts2_lab{
    if (!_ts2_lab) {
        _ts2_lab = [UILabel new];
        _ts2_lab.text = @"每还款一笔，立返当前金额千分之一的现金";
        _ts2_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        _ts2_lab.font = [UIFont getUIFontSize:12 IsBold:NO];
    }
    return _ts2_lab;
}
- (UIImageView *)bottom_image{
    if (!_bottom_image) {
        _bottom_image = [UIImageView getUIImageView:@"icon_jbbg"];
        _bottom_image.userInteractionEnabled = YES;
        [_bottom_image bk_whenTapped:^{
            [self.xp_rootNavigationController pushViewController:[HCAddCreditCardController new] animated:YES];
        }];
    }
    return _bottom_image;
}
- (UIView *)bottom_view{
    if (!_bottom_view) {
        _bottom_view = [UIView new];
    }
    return _bottom_view;
}

- (UIImageView *)bottom_left_img{
    if (!_bottom_left_img) {
        _bottom_left_img = [UIImageView getUIImageView:@"icon_xyk_add"];
    }
    return _bottom_left_img;
}
- (UILabel *)bottom_right_lab{
    if (!_bottom_right_lab) {
        _bottom_right_lab = [UILabel new];
        _bottom_right_lab.text = @"添加信用卡";
        _bottom_right_lab.textColor = [UIColor colorWithHexString:@"#333333"];
        _bottom_right_lab.font = [UIFont getUIFontSize:18 IsBold:YES];
        _bottom_right_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _bottom_right_lab;
}



@end
