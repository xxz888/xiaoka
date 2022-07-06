//
//  HCTheEmptyDetailController.m
//  HC
//
//  Created by tuibao on 2022/1/12.
//

#import "HCTheEmptyDetailController.h"
#import "HCTheEmptyDetailCell.h"
@interface HCTheEmptyDetailController ()<UITableViewDelegate, UITableViewDataSource , DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic , strong) UITableView *tableView;

@end

@implementation HCTheEmptyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"明细";
    self.view.backgroundColor = [UIColor whiteColor];
    [self LoadUI];
    
}
#pragma 获取空卡明细
- (void)GetLoadData{
    @weakify(self);
    
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    [params setValue:self.cardData[@"cardNo"] forKey:@"cardNo"];
//    if (self.empowerToken.length > 0) {
//        [params setObject:self.empowerToken forKey:@"empowerToken"];
//    }
//    [self NetWorkingPostWithAddressURL:self hiddenHUD:NO url:@"/api/credit/get/all/plan" Params:params success:^(id  _Nonnull responseObject) {
//
//        if ([responseObject[@"code"] intValue] == 0) {
//            weak_self.CreditData = [NSArray arrayWithArray:responseObject[@"data"]];
//            [weak_self.tableView reloadData];
//        }else{
//            [XHToast showBottomWithText:responseObject[@"message"]];
//        }
//    } failure:^(NSString * _Nonnull error) {
//
//    }];
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Identifier = @"HCTheEmptyDetailCell";
    HCTheEmptyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCTheEmptyDetailCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
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
