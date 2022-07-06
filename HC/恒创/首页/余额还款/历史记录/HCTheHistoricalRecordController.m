//
//  HCTheHistoricalRecordController.m
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import "HCTheHistoricalRecordController.h"
#import "HCTheHistoricalRecordCell.h"
#import "HCPlanDetailsController.h"
@interface HCTheHistoricalRecordController ()<UITableViewDelegate, UITableViewDataSource , DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic , strong) UITableView *tableView;
//信用卡还款历史记录数据
@property (nonatomic , strong) NSArray *CreditData;
@end

@implementation HCTheHistoricalRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"历史记录";
    
    [self LoadUI];
    
    [self GetLoadData];
}

#pragma 获取信用卡还款历史
- (void)GetLoadData{
    @weakify(self);
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.cardData[@"cardNo"] forKey:@"cardNo"];
    if (self.empowerToken.length > 0) {
        [params setObject:self.empowerToken forKey:@"empowerToken"];
    }
    [self NetWorkingPostWithAddressURL:self hiddenHUD:NO url:@"/api/credit/get/all/plan" Params:params success:^(id  _Nonnull responseObject) {
        
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.CreditData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Identifier = @"HCTheHistoricalRecordCell";
    HCTheHistoricalRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCTheHistoricalRecordCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.name_lab.text = [NSString stringWithFormat:@"%@(%@)",self.cardData[@"bankName"],getAfterFour([self.cardData[@"cardNo"] stringValue])];
    
    cell.log_image.image = [UIImage imageNamed:getBankLogo(self.cardData[@"bankAcronym"])];
    
    NSDictionary *dic = self.CreditData[indexPath.row];
    if ([dic[@"status"] intValue] == 1) {
        cell.type_lab.text = @"新建";
    }
    else if([dic[@"status"] intValue] == 2){
        cell.type_lab.text = @"执行中";
        cell.type_lab.textColor = [UIColor colorWithHexString:@"#FF9426"];
    }
    else if([dic[@"status"] intValue] == 3){
        cell.type_lab.text = @"已完成";
        cell.type_lab.textColor = [UIColor colorWithHexString:@"#209E2F"];
    }
    else if([dic[@"status"] intValue] == 4){
        cell.type_lab.text = @"还款失败";
        cell.type_lab.textColor = [UIColor redColor];
    }
    else if([dic[@"status"] intValue] == 5){
        cell.type_lab.text = @"取消中";
        cell.type_lab.textColor = [UIColor redColor];
    }
    else if([dic[@"status"] intValue] == 6){
        cell.type_lab.text = @"已取消";
        cell.type_lab.textColor = [UIColor colorWithHexString:@"#2741AD"];
    }
    else if([dic[@"status"] intValue] == 7){
        cell.type_lab.text = @"取消失败";
        cell.type_lab.textColor = [UIColor redColor];
    }
    else if([dic[@"status"] intValue] == 8){
        cell.type_lab.text = @"执行完成";
        cell.type_lab.textColor = [UIColor colorWithHexString:@"#209E2F"];
    }
    //还款笔数
    cell.bishu_lab.text = [NSString stringWithFormat:@"%@笔",dic[@"completedCount"]];
    //账单金额
    cell.zd_amount_lab.text = [NSString stringWithFormat:@"%@",dic[@"taskAmount"]];
    //剩余应还
    double should = [dic[@"taskAmount"] doubleValue] - [dic[@"repaymentedAmount"] doubleValue];
    cell.sy_ShouldAlso_lab.text = should < 0 ? @"0" : [[NSString stringWithFormat:@"%f",should] removeUnwantedZero];
    //创建时间
    cell.time_lab.text = [NSString stringWithFormat:@"%@",dic[@"createTime"]];
//    //订单号
//    cell.order_lab.text = isBlankString(dic[@"orderCode"]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.CreditData[indexPath.row];
    //计划详情
    HCPlanDetailsController *VC = [HCPlanDetailsController new];
    VC.cardData = self.cardData;
    VC.planIDStr = [NSString stringWithFormat:@"%@",dic[@"id"]];
    VC.empowerToken = self.empowerToken;
    [self.xp_rootNavigationController pushViewController:VC animated:YES];
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"tableView_Placeholder"];
}
#pragma 无数据点击刷新
-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self GetLoadData];
}

- (void)LoadUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.left.offset(0);
        make.top.offset(0);
        make.bottom.offset(-KBottomHeight);
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
            [weak_self GetLoadData];
            [weak_self.tableView.mj_header endRefreshing];
        }];
        //上拉加载更多
        _tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weak_self GetLoadData];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
    }
    return _tableView;
}




@end
