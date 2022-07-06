//
//  HCActivationCodeController.m
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import "HCActivationCodeController.h"
#import "HCActivationCodeOneCell.h"
#import "HCActivationCodeTwoCell.h"
#import "HCBuyDownController.h"
@interface HCActivationCodeController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic , strong) UILabel *left_lab;
@property (nonatomic , strong) UIView *left_view;
@property (nonatomic , strong) UILabel *right_lab;
@property (nonatomic , strong) UIView *right_view;
@property (nonatomic , strong) UILabel *right1_lab;
@property (nonatomic , strong) UIView *right1_view;

@property (nonatomic , strong) UITableView *tableView;
//1未使用 2已使用 3已过期
@property (nonatomic , assign) NSInteger isSelectType;
//未使用
@property (nonatomic , strong) NSMutableArray *left_Arr;
@property (nonatomic , assign) NSInteger left_page;
//已使用
@property (nonatomic , strong) NSMutableArray *right_Arr;
@property (nonatomic , assign) NSInteger right_page;
//已过期
@property (nonatomic , strong) NSMutableArray *right1_Arr;
@property (nonatomic , assign) NSInteger right1_page;

@end

@implementation HCActivationCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"激活码管理";
    self.isSelectType = 1;//未使用
    self.left_page = 1;
    self.right_page = 1;
    self.right1_page = 1;
    
    UIButton *btn = [UIButton new];
    [btn setTitle:@"购买记录" forState:UIControlStateNormal];
    [btn setTitleColor:FontThemeColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont getUIFontSize:12 IsBold:YES];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    [btn bk_whenTapped:^{
        [self.xp_rootNavigationController pushViewController:[HCBuyDownController new] animated:YES];
    }];
    
    
    [self LoadUI];
    [self AddAction];
    [self getTableViewData];
}
#pragma 请求列表数据
- (void)getTableViewData{
    @weakify(self);
    if (self.isSelectType == 1) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"10" forKey:@"pageSize"];
        [dic setValue:[NSString stringWithFormat:@"%li",self.left_page] forKey:@"currentPage"];
        
        [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/key/get/unused" Params:dic success:^(id  _Nonnull responseObject) {
           
            if ([responseObject[@"code"] integerValue] == 0) {
                weak_self.left_lab.text = [NSString stringWithFormat:@"未使用(%@)",responseObject[@"data"][@"unCount"]];
                NSArray * array = responseObject[@"data"][@"list"];
                if (weak_self.left_page == 1) {
                    weak_self.left_Arr = [NSMutableArray arrayWithArray:array];
                    [weak_self.tableView.mj_footer endRefreshing];
                }
                else {
                    //没有更多数据
                    if (![responseObject[@"data"][@"list"] count]) {
                        [weak_self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [weak_self.left_Arr addObjectsFromArray:array];
                }
                [weak_self.tableView reloadData];

            }else{
                [XHToast showBottomWithText:responseObject[@"message"] duration:2];
            }
        } failure:^(NSString * _Nonnull error) {
            
        }];
    }
    else if(self.isSelectType == 2){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"10" forKey:@"pageSize"];
        [dic setValue:[NSString stringWithFormat:@"%li",self.right_page] forKey:@"currentPage"];
        
        [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/key/get/used" Params:dic success:^(id  _Nonnull responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                weak_self.right_lab.text = [NSString stringWithFormat:@"已使用(%@)",responseObject[@"data"][@"usedCount"]];
                NSArray * array = responseObject[@"data"][@"list"];
                if (weak_self.right_page == 1) {
                    weak_self.right_Arr = [NSMutableArray arrayWithArray:array];
                    [weak_self.tableView.mj_footer endRefreshing];
                }
                else {
                    //没有更多数据
                    if (![responseObject[@"data"][@"list"] count]) {
                        [weak_self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [weak_self.right_Arr addObjectsFromArray:array];
                }
            }else{
                [XHToast showBottomWithText:responseObject[@"message"] duration:2];
            }
            [weak_self.tableView reloadData];
        } failure:^(NSString * _Nonnull error) {
            
        }];
    }
    else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"10" forKey:@"pageSize"];
        [dic setValue:[NSString stringWithFormat:@"%li",self.right1_page] forKey:@"currentPage"];
        
        [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/key/get/out/used" Params:dic success:^(id  _Nonnull responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                weak_self.right1_lab.text = [NSString stringWithFormat:@"已过期(%@)",responseObject[@"data"][@"outCount"]];
                NSArray * array = responseObject[@"data"][@"list"];
                if (weak_self.right1_page == 1) {
                    weak_self.right1_Arr = [NSMutableArray arrayWithArray:array];
                    [weak_self.tableView.mj_footer endRefreshing];
                }
                else {
                    //没有更多数据
                    if (![responseObject[@"data"][@"list"] count]) {
                        [weak_self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [weak_self.right1_Arr addObjectsFromArray:array];
                }
            }else{
                [XHToast showBottomWithText:responseObject[@"message"] duration:2];
            }
            [weak_self.tableView reloadData];
        } failure:^(NSString * _Nonnull error) {
            
        }];
    }
    
    
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSelectType == 1) {
        return self.left_Arr.count;
    }
    else if(self.isSelectType == 2){
        return self.right_Arr.count;
    }else{
        return self.right1_Arr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSelectType == 1 ) {
         
        static NSString *Identifier = @"HCActivationCodeOneCell";
        HCActivationCodeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(!cell){
            cell=[[[NSBundle mainBundle] loadNibNamed:@"HCActivationCodeOneCell" owner:nil options:nil] lastObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSDictionary *dic = self.left_Arr[indexPath.row];
        
        cell.lab2.text = [NSString stringWithFormat:@"激活码：%@",dic[@"key"]];
        
        NSArray *arr = [dic[@"invalidTime"] componentsSeparatedByString:@" "];
        if (arr.count == 2) {
            cell.lab4.text = [NSString stringWithFormat:@"有效期：%@", arr[0]];
            [cell.right_btn bk_whenTapped:^{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = dic[@"key"];
                [XHToast showBottomWithText:@"复制成功" duration:1.0];
            }];
        }
        
        return cell;
    }
    else if(self.isSelectType == 2){
        static NSString *Identifier = @"HCActivationCodeTwoCell";
        HCActivationCodeTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(!cell){
            cell=[[[NSBundle mainBundle] loadNibNamed:@"HCActivationCodeTwoCell" owner:nil options:nil] lastObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        NSDictionary *dic = self.right_Arr[indexPath.row];
        
        cell.name_lab.text = dic[@"fullname"];
        
        if ([dic[@"vipLevel"] intValue] == 0) {
            cell.dengji_lab.text = @"普通";
        }else{
            cell.dengji_lab.text = [NSString stringWithFormat:@"V%@",dic[@"vipLevel"]];
        }
        
        [cell.phone_btn setTitle:[NSString getSecrectStringWithPhoneNumber:dic[@"username"]] forState:UIControlStateNormal];
        
        NSArray *arr = [dic[@"invalidTime"] componentsSeparatedByString:@" "];
        if (arr.count == 2) {
            cell.time_lab.text = [NSString stringWithFormat:@"激活时间：%@", arr[0]];
        }
        
        cell.lab1.text = [NSString stringWithFormat:@"直推人数：%@", dic[@"firstCount"]];
        cell.lab2.text = [NSString stringWithFormat:@"团队人数：%@", dic[@"teamCount"]];
        cell.lab3.text = [NSString stringWithFormat:@"直推激活：%@", dic[@"firstActivationCount"]];
        cell.lab4.text = [NSString stringWithFormat:@"本月交易量(元)：%@", [NSString stringChineseFormat:[dic[@"curMonthAllAmount"] doubleValue]]];
        
        
        cell.lab1.attributedText = [UILabel setupAttributeString:cell.lab1.text rangeText:@"直推人数：" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
        
        cell.lab2.attributedText = [UILabel setupAttributeString:cell.lab2.text rangeText:@"团队人数：" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];

        cell.lab3.attributedText = [UILabel setupAttributeString:cell.lab3.text rangeText:@"直推激活：" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
        cell.lab4.attributedText = [UILabel setupAttributeString:cell.lab4.text rangeText:@"本月交易量(元)：" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
        
        
        [cell.phone_btn setEnlargeEdgeWithTop:10 right:10 bottom:20 left:20];
        [cell.phone_btn bk_whenTapped:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",dic[@"username"]]] options:@{} completionHandler:nil];
        }];
        return cell;
    }
    else{
        static NSString *Identifier = @"HCActivationCodeOneCell";
        HCActivationCodeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(!cell){
            cell=[[[NSBundle mainBundle] loadNibNamed:@"HCActivationCodeOneCell" owner:nil options:nil] lastObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSDictionary *dic = self.right1_Arr[indexPath.row];
        
        cell.lab2.text = [NSString stringWithFormat:@"激活码：%@",dic[@"key"]];
        
        NSArray *arr = [dic[@"invalidTime"] componentsSeparatedByString:@" "];
        if (arr.count == 2) {
            cell.lab4.text = @"有效期：已过期";
            cell.right_btn.userInteractionEnabled = NO;
            [cell.right_btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        }
        
        return cell;
        
    }
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"tableView_Placeholder"];
}
#pragma 无数据点击刷新
-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self getTableViewData];
}

- (void)AddAction{
    @weakify(self);
    [_left_lab bk_whenTapped:^{
        weak_self.left_lab.textColor = [UIColor blackColor];
        weak_self.left_view.backgroundColor = FontThemeColor;
        weak_self.right_view.backgroundColor = [UIColor whiteColor];
        weak_self.right_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        weak_self.right1_view.backgroundColor = [UIColor whiteColor];
        weak_self.right1_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        weak_self.isSelectType = 1;
        [weak_self getTableViewData];
    }];
    [_right_lab bk_whenTapped:^{
        weak_self.left_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        weak_self.left_view.backgroundColor = [UIColor whiteColor];
        weak_self.right_view.backgroundColor = FontThemeColor;
        weak_self.right_lab.textColor = [UIColor blackColor];
        weak_self.right1_view.backgroundColor = [UIColor whiteColor];
        weak_self.right1_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        weak_self.isSelectType = 2;
        [weak_self getTableViewData];
    }];
    
    [_right1_lab bk_whenTapped:^{
        weak_self.left_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        weak_self.left_view.backgroundColor = [UIColor whiteColor];
        weak_self.right1_view.backgroundColor = FontThemeColor;
        weak_self.right1_lab.textColor = [UIColor blackColor];
        weak_self.right_view.backgroundColor = [UIColor whiteColor];
        weak_self.right_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        weak_self.isSelectType = 3;
        [weak_self getTableViewData];
    }];}

- (void)LoadUI{
    
    [self.view addSubview:self.left_lab];
    [self.left_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(30);
    }];
    [self.view addSubview:self.left_view];
    [self.left_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(3);
        make.left.equalTo(self.left_lab.mas_left).offset(2);
        make.top.equalTo(self.left_lab.mas_bottom).offset(5);
        make.right.equalTo(self.left_lab.mas_right).offset(-2);
    }];
    

    [self.view addSubview:self.right_lab];
    [self.right_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left_lab.mas_right).offset(15);
        make.centerY.equalTo(self.left_lab);
    }];
    [self.view addSubview:self.right_view];
    [self.right_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(3);
        make.left.equalTo(self.right_lab.mas_left).offset(2);
        make.top.equalTo(self.right_lab.mas_bottom).offset(5);
        make.right.equalTo(self.right_lab.mas_right).offset(-2);
    }];
    
    [self.view addSubview:self.right1_lab];
    [self.right1_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.right_lab.mas_right).offset(15);
        make.centerY.equalTo(self.left_lab);
    }];
    [self.view addSubview:self.right1_view];
    [self.right1_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(3);
        make.left.equalTo(self.right1_lab.mas_left).offset(2);
        make.top.equalTo(self.right1_lab.mas_bottom).offset(5);
        make.right.equalTo(self.right1_lab.mas_right).offset(-2);
    }];
    
    
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.left.offset(0);
        make.top.equalTo(self.left_view.mas_bottom).offset(10);
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
            if (self.isSelectType == 0) {
                self.left_page = 1;
            }else if(self.isSelectType == 1){
                self.right_page = 1;
            }else{
                self.right1_page = 1;
            }
            [weak_self getTableViewData];
            [weak_self.tableView.mj_header endRefreshing];
        }];
        //上拉加载更多
        _tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (self.isSelectType == 1) {
                self.left_page ++;
            }else if(self.isSelectType == 2){
                self.right_page ++;
            }else{
                self.right1_page ++;
            }
            [weak_self getTableViewData];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
        
    }
    return _tableView;
}

- (UILabel *)left_lab{
    if (!_left_lab) {
        _left_lab = [UILabel new];
        _left_lab.text = @"未使用";
        _left_lab.textColor = [UIColor blackColor];
        _left_lab.font = [UIFont getUIFontSize:18 IsBold:YES];
        _left_lab.userInteractionEnabled = YES;
        
    }
    return _left_lab;
}
- (UIView *)left_view{
    if (!_left_view) {
        _left_view = [UIView new];
        _left_view.backgroundColor = FontThemeColor;
    }
    return _left_view;
}

- (UILabel *)right_lab{
    if (!_right_lab) {
        _right_lab = [UILabel new];
        _right_lab.text = @"已使用";
        _right_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        _right_lab.font = [UIFont getUIFontSize:18 IsBold:YES];
        _right_lab.userInteractionEnabled = YES;
        
    }
    return _right_lab;
}
- (UIView *)right_view{
    if (!_right_view) {
        _right_view = [UIView new];
        _right_view.backgroundColor = [UIColor whiteColor];
    }
    return _right_view;
}

- (UILabel *)right1_lab{
    if (!_right1_lab) {
        _right1_lab = [UILabel new];
        _right1_lab.text = @"已过期";
        _right1_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        _right1_lab.font = [UIFont getUIFontSize:18 IsBold:YES];
        _right1_lab.userInteractionEnabled = YES;
        
    }
    return _right1_lab;
}
- (UIView *)right1_view{
    if (!_right1_view) {
        _right1_view = [UIView new];
        _right1_view.backgroundColor = [UIColor whiteColor];
    }
    return _right1_view;
}

@end
