//
//  HCCustomerCardController.m
//  HC
//
//  Created by tuibao on 2021/12/30.
//

#import "HCCustomerCardController.h"
#import "HCBalancePaymentsCell.h"
@interface HCCustomerCardController ()<UITableViewDelegate, UITableViewDataSource , DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic , strong) UIImageView *bottom_image;
@property (nonatomic , strong) UIView *bottom_view;
@property (nonatomic , strong) UIImageView *bottom_left_img;
@property (nonatomic , strong) UILabel *bottom_right_lab;
@property (nonatomic , strong) UITableView *tableView;

//信用卡还款数据
@property (nonatomic , strong) NSArray *CreditData;

@end

@implementation HCCustomerCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.title = @"客户的卡包";
    //接收刷新客户卡包的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetCustomerCard) name:@"RefreshCustomerCardTable" object:nil];
    
    [self LoadUI];
    [self GetCustomerCard];
    
}
- (void)GetCustomerCard{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.empowerToken forKey:@"empowerToken"];
    
    @weakify(self);
    [self NetWorkingPostWithAddressURL:self hiddenHUD:NO url:@"/api/credit/get/balance/plan/list" Params:params success:^(id  _Nonnull responseObject) {
        
        if ([responseObject[@"code"] intValue] == 0) {
            weak_self.CreditData = [NSArray arrayWithArray:responseObject[@"data"]];
            [weak_self.tableView reloadData];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
        // 1s后自动调用self的 定时消除指示器 方法
        [self performSelector:@selector(定时消除指示器) withObject:nil afterDelay:1.0];
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
- (void)定时消除指示器{
     [self dismiss];
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 136;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _CreditData.count;
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

    [cell.delete_image setHidden:NO];
    [cell.delete_image bk_whenTapped:^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您是否删除该信用卡？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteCreditCard:indexPath.row];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    
    
    return cell;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"tableView_Placeholder"];
}
#pragma 无数据点击刷新
-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self GetCustomerCard];
    
}
#pragma 删除信用卡
- (void)deleteCreditCard:(NSInteger)index{
    
    NSString * cardID= self.CreditData[index][@"id"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.empowerToken forKey:@"empowerToken"];
    
    [self NetWorkingPostWithAddressURL:self hiddenHUD:NO url:[NSString stringWithFormat:@"/api/user/credit/card/delete/%@",cardID] Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [XHToast showBottomWithText:responseObject[@"message"]];
            [self GetCustomerCard];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}
//制定计划
- (void)setPushMakePlanController:(NSInteger)index{
    NSDictionary *dic = self.CreditData[index];
    HCMakePlanController *VC = [HCMakePlanController new];
    VC.cardData = [NSMutableDictionary dictionaryWithDictionary:dic];
    VC.empowerToken = self.empowerToken;
    VC.customer_Name = self.customer_Name;
    [self.xp_rootNavigationController pushViewController:VC animated:YES];
}


//查询当前卡还款计划历史记录
- (void)setPushHistoricalRecordController:(NSInteger)index{
    
    NSDictionary *dic = self.CreditData[index];
    HCTheHistoricalRecordController *VC = [HCTheHistoricalRecordController new];
    VC.cardData = dic;
    VC.empowerToken = self.empowerToken;
    [self.xp_rootNavigationController pushViewController:VC animated:YES];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.CreditData[indexPath.row];
    
    if ([[dic allKeys] containsObject:@"balancePlan"]) {
        //计划详情
        HCPlanDetailsController *VC = [HCPlanDetailsController new];
        VC.cardData = dic;
        VC.planIDStr = dic[@"balancePlan"][@"id"];
        VC.empowerToken = self.empowerToken;
        VC.customer_Name = self.customer_Name;
        [self.xp_rootNavigationController pushViewController:VC animated:YES];
    }
}
- (void)CustomerInformation{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.empowerToken forKey:@"empowerToken"];
    @weakify(self);
    [self NetWorkingPostWithAddressURL:self hiddenHUD:YES url:@"/api/user/debit/list" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {

            HCModifySavingsCardController *VC = [HCModifySavingsCardController new];
            VC.data = [responseObject[@"data"] firstObject];
            VC.empowerToken = weak_self.empowerToken;
            VC.customer_idCard = self.customer_idCard;
            [weak_self.xp_rootNavigationController pushViewController:VC animated:YES];
            
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
    
    
    
    
}
- (void)LoadUI{
   
    UIButton *leftbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [leftbutton setTitleColor:FontThemeColor forState:UIControlStateNormal];
    [leftbutton setTitle:@"客户信息" forState:UIControlStateNormal];
    leftbutton.titleLabel.font = [UIFont getUIFontSize:14 IsBold:NO];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];

    self.navigationItem.rightBarButtonItem = rightitem;
    [leftbutton bk_whenTapped:^{
        [self CustomerInformation];
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
        make.top.equalTo(self.view.mas_top).offset(0);
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
            [weak_self GetCustomerCard];
            [weak_self.tableView.mj_header endRefreshing];
        }];
        //上拉加载更多
        _tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weak_self GetCustomerCard];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
    }
    return _tableView;
}

- (UIImageView *)bottom_image{
    if (!_bottom_image) {
        _bottom_image = [UIImageView getUIImageView:@"icon_jbbg"];
        _bottom_image.userInteractionEnabled = YES;
        [_bottom_image bk_whenTapped:^{
            
            HCAddCreditCardController *VC = [HCAddCreditCardController new];
            VC.empowerToken = self.empowerToken;
            VC.customer_Name = self.customer_Name;
            [self.xp_rootNavigationController pushViewController:VC animated:YES];
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
