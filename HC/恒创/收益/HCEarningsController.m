//
//  HCEarningsController.m
//  HC
//
//  Created by tuibao on 2021/11/6.
//

#import "HCEarningsController.h"
#import "HCEarningsCell.h"

@interface HCEarningsController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UIImageView *top_image;
@property (strong, nonatomic) UIButton *title_btn;
@property (strong, nonatomic) UILabel *Earnings_lab;

@property (strong, nonatomic) UILabel *left_lab;
@property (strong, nonatomic) UILabel *center_lab;
@property (strong, nonatomic) UILabel *right_lab;
@property (strong, nonatomic) UILabel *rightTop_lab;

@property (nonatomic , strong) UILabel *left_Segment_lab;
@property (nonatomic , strong) UIView *left_Segment_view;
@property (nonatomic , strong) UILabel *right_Segment_lab;
@property (nonatomic , strong) UIView *right_Segment_view;

@property (nonatomic , strong) UITableView *tableView;

//是否每日收益 yes为每日收益
@property (nonatomic , assign) BOOL isSelectType;
//头部数据
@property (nonatomic , strong) NSDictionary *Top_data;
//每日收益数据
@property (nonatomic , strong) NSMutableArray *left_Arr;
@property (nonatomic , assign) NSInteger left_page;
//体现记录数据
@property (nonatomic , strong) NSMutableArray *right_Arr;
@property (nonatomic , assign) NSInteger right_page;

@end

@implementation HCEarningsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isSelectType = YES;
    self.left_page = 1;
    self.right_page = 1;
    [self loadUI];
    [self AddAction];
    
}
- (void)AddAction{
    @weakify(self);
    [_left_Segment_lab bk_whenTapped:^{
        weak_self.left_Segment_lab.textColor = [UIColor blackColor];
        weak_self.left_Segment_view.backgroundColor = FontThemeColor;
        weak_self.right_Segment_view.backgroundColor = [UIColor whiteColor];
        weak_self.right_Segment_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        weak_self.isSelectType = YES;
        [weak_self getTableViewData];
    }];
    [_right_Segment_lab bk_whenTapped:^{
        weak_self.left_Segment_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        weak_self.left_Segment_view.backgroundColor = [UIColor whiteColor];
        weak_self.right_Segment_view.backgroundColor = FontThemeColor;
        weak_self.right_Segment_lab.textColor = [UIColor blackColor];
        weak_self.isSelectType = NO;
        [weak_self getTableViewData];
    }];
    
    [_rightTop_lab bk_whenTapped:^{
        
        HCReflectController *VC = [HCReflectController new];
        VC.CanCarry_amount = [NSString stringWithFormat:@"%@",[NSString isBlankString:[self.Top_data[@"currentBalance"] stringValue]] ? @"0.00" : self.Top_data[@"currentBalance"]];
        [weak_self.xp_rootNavigationController pushViewController:VC animated:YES];
    }];
    [_right_lab bk_whenTapped:^{
        HCReflectController *VC = [HCReflectController new];
        VC.CanCarry_amount = [NSString stringWithFormat:@"%@",[NSString isBlankString:[self.Top_data[@"currentBalance"] stringValue]] ? @"0.00" : self.Top_data[@"currentBalance"]];
        [weak_self.xp_rootNavigationController pushViewController:VC animated:YES];
    }];
    
    [self.title_btn bk_whenTapped:^{
        self.title_btn.selected = !self.title_btn.selected;
        if (!self.title_btn.selected) {
            //总收益
            self.Earnings_lab.text = [NSString stringWithFormat:@"%.2f",[self.Top_data[@"totalBalance"] doubleValue]];
        }else{
            //总收益
            self.Earnings_lab.text = @"*** ***";
        }
    }];
    
}
#pragma 请求总收益数据
- (void)getTheCreditCardData{
    [self NetWorkingPostWithURL:self hiddenHUD:YES url:@"/api/user/get/account" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            
            NSDictionary *dicUser = [self loadUserData];
            
            if ([dicUser[@"agent"] intValue] == 1) {
                NSDictionary *dic = [self loadSuperMembersData];
                if ([dic[@"IsSwitch"] intValue] == 1) {
                    self.Top_data = dic;
                }else{
                    self.Top_data = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                }
            }else{
                self.Top_data = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
            }
            
            //总收益
            self.Earnings_lab.text = [NSString stringWithFormat:@"%.2f",[self.Top_data[@"totalBalance"] doubleValue]];
            //今天收益
            self.left_lab.text = [NSString stringWithFormat:@"今日收益\n%.2f",[self.Top_data[@"todayTotal"] doubleValue]];
            //昨天收益
            self.center_lab.text = [NSString stringWithFormat:@"昨日收益\n%.2f",[self.Top_data[@"yesterdayTotal"] doubleValue]];
            //可提现余额
            self.right_lab.text = [NSString stringWithFormat:@"可提现\n%.2f",[self.Top_data[@"currentBalance"] doubleValue]];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

#pragma 请求列表数据
- (void)getTableViewData{
    
    if (self.isSelectType) {
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"20" forKey:@"pageSize"];
        [dic setValue:[NSString stringWithFormat:@"%li",(long)self.left_page] forKey:@"currentPage"];
        
        [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/turnover/get/profit" Params:dic success:^(id  _Nonnull responseObject) {
           
            if ([responseObject[@"code"] integerValue] == 0) {
                NSArray * array = responseObject[@"data"];
                
                NSMutableArray *arrData = [NSMutableArray array];
                NSDictionary *dicUser = [self loadUserData];
                if ([dicUser[@"agent"] intValue] == 1) {
                    NSDictionary *dic = [self loadSuperMembersData];
                    if ([dic[@"IsSwitch"] intValue] == 1) {
                        for (int i = 0; i < array.count; i++) {
                            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:array[i]];
                            if (i == 0) {
                                [data setObject:dic[@"yesterdayTotal"] forKey:@"amount"];
                            }else{
                                double m = [dic[@"yesterdayTotal"] doubleValue] - 200;
                                double n = [dic[@"yesterdayTotal"] doubleValue] + 200;
                                double x = [self randomBetween:m AndBigNum:n AndPrecision:100];
                                [data setObject:[NSString stringWithFormat:@"%.2f",x] forKey:@"amount"];
                            }
                            [arrData addObject:data];
                        }
                    }else{
                        [arrData addObjectsFromArray:array];
                    }
                }else{
                    [arrData addObjectsFromArray:array];
                }
                
                if (self.left_page == 1) {
                    self.left_Arr = [NSMutableArray arrayWithArray:arrData];
                    [self.tableView.mj_footer endRefreshing];
                }
                else {
                    //没有更多数据
                    if (![responseObject[@"data"] count]) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [self.left_Arr addObjectsFromArray:arrData];
                }
                
                [self.tableView reloadData];

            }else{
                [XHToast showBottomWithText:responseObject[@"message"] duration:2];
            }
        } failure:^(NSString * _Nonnull error) {
            
        }];
    }
    else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"20" forKey:@"pageSize"];
        [dic setValue:[NSString stringWithFormat:@"%li",(long)self.right_page] forKey:@"currentPage"];
        
        [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/turnover/get/withdraw" Params:dic success:^(id  _Nonnull responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSArray * array = responseObject[@"data"];
                if (self.right_page == 1) {
                    self.right_Arr = [NSMutableArray arrayWithArray:array];
                    [self.tableView.mj_footer endRefreshing];
                }
                else {
                    //没有更多数据
                    if (![responseObject[@"data"] count]) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [self.right_Arr addObjectsFromArray:array];
                }
                [self.tableView reloadData];

            }else{
                [XHToast showBottomWithText:responseObject[@"message"] duration:2];
            }
        } failure:^(NSString * _Nonnull error) {
            
        }];
    }
    
    
}



#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isSelectType ? self.left_Arr.count : self.right_Arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    static NSString *Identifier = @"HCEarningsCell";
    HCEarningsCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCEarningsCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *date = [NSDictionary dictionary];
    NSString *type = @"";
    if (self.isSelectType) {
        cell.left_title_lab.text = @"收益(元)";
        date = self.left_Arr[indexPath.row];
        type = @"+";
    }else{
        cell.left_title_lab.text = @"提现金额(元)";
        date = self.right_Arr[indexPath.row];
        type = @"-";
    }
    
    cell.left_number_lab.text = [NSString stringWithFormat:@"%@%.2f",type,[date[@"amount"] doubleValue]];
    cell.right_number_lab.text = [NSString stringWithFormat:@"%@",date[@"createTime"]];
    
    return cell;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"tableView_Placeholder"];
}
#pragma 无数据点击刷新
-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self getTableViewData];
}

- (void)loadUI{
    
    [self.view addSubview:self.top_image];
    [self.top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kTopHeight + 120);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    
    
    
    [self.view addSubview:self.title_btn];
    [self.title_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(kTopHeight-10);
    }];
    [self.view addSubview:self.Earnings_lab];
    [self.Earnings_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.title_btn.mas_bottom).offset(8);
    }];
    
    double lab_W = (DEVICE_WIDTH - 40) / 3;
    [self.view addSubview:self.center_lab];
    [self.center_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(lab_W, 40));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.Earnings_lab.mas_bottom).offset(12);
    }];
    
    [self.view addSubview:self.left_lab];
    [self.left_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(lab_W, 40));
        make.centerY.equalTo(self.center_lab);
        make.right.equalTo(self.center_lab.mas_left).offset(-10);
    }];
    [self.view addSubview:self.right_lab];
    [self.right_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(lab_W, 40));
        make.centerY.equalTo(self.center_lab);
        make.left.equalTo(self.center_lab.mas_right).offset(10);
    }];
    [self.view addSubview:self.rightTop_lab];
    [self.rightTop_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 13));
        make.centerX.equalTo(self.right_lab);
        make.bottom.equalTo(self.right_lab.mas_top).offset(0);
    }];
    
    
    [self.view addSubview:self.left_Segment_lab];
    [self.left_Segment_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17.5);
        make.top.equalTo(self.top_image.mas_bottom).offset(19);
    }];
    [self.view addSubview:self.left_Segment_view];
    [self.left_Segment_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(3);
        make.left.equalTo(self.left_Segment_lab.mas_left).offset(2);
        make.top.equalTo(self.left_Segment_lab.mas_bottom).offset(5);
        make.right.equalTo(self.left_Segment_lab.mas_right).offset(-2);
    }];
    

    [self.view addSubview:self.right_Segment_lab];
    [self.right_Segment_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left_Segment_lab.mas_right).offset(30);
        make.centerY.equalTo(self.left_Segment_lab);
    }];
    [self.view addSubview:self.right_Segment_view];
    [self.right_Segment_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(3);
        make.left.equalTo(self.right_Segment_lab.mas_left).offset(2);
        make.top.equalTo(self.right_Segment_lab.mas_bottom).offset(5);
        make.right.equalTo(self.right_Segment_lab.mas_right).offset(-2);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.left.offset(0);
        make.top.equalTo(self.left_Segment_view.mas_bottom).offset(10);
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
        _tableView.showsVerticalScrollIndicator = NO;
        
        
        @weakify(self);
        //下拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (self.isSelectType) {
                self.left_page = 1;
            }else{
                self.right_page = 1;
            }
            [weak_self getTableViewData];
            [weak_self.tableView.mj_header endRefreshing];
        }];
        //上拉加载更多
        _tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (self.isSelectType) {
                self.left_page ++;
            }else{
                self.right_page ++;
            }
            [weak_self getTableViewData];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
    }
    return _tableView;
}
- (UILabel *)Earnings_lab{
    if (!_Earnings_lab) {
        _Earnings_lab = [UILabel new];
        _Earnings_lab.text = @"0.0";
        _Earnings_lab.textColor = FontThemeColor;
        _Earnings_lab.font = [UIFont boldSystemFontOfSize:33];
        
    }
    return _Earnings_lab;
}
- (UIButton *)title_btn{
    if (!_title_btn) {
        _title_btn = [UIButton new];
        [_title_btn setTitle:@"总收益(元)" forState:UIControlStateNormal];
        [_title_btn setTitleColor:FontThemeColor forState:UIControlStateNormal];
        _title_btn.titleLabel.font = [UIFont getUIFontSize:20 IsBold:YES];
        [_title_btn setImage:[UIImage imageNamed:@"icon_according"] forState:UIControlStateNormal];
        [self.title_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:15];
    }
    return _title_btn;
}
- (UIImageView *)top_image{
    if (!_top_image) {
        _top_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_earnings_topBG"]];
    }
    return _top_image;
}

- (UILabel *)left_lab{
    if (!_left_lab) {
        _left_lab = [UILabel new];
        _left_lab.text = @"今日收益\n0.0";
        _left_lab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _left_lab.font = [UIFont getUIFontSize:14 IsBold:NO];
        _left_lab.numberOfLines = 2;
        [UILabel changeLineSpaceForLabel:_left_lab WithSpace:2];
        _left_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _left_lab;
}
- (UILabel *)center_lab{
    if (!_center_lab) {
        _center_lab = [UILabel new];
        _center_lab.text = @"昨日收益\n0.0";
        _center_lab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _center_lab.font = [UIFont getUIFontSize:14 IsBold:NO];
        _center_lab.numberOfLines = 2;
        [UILabel changeLineSpaceForLabel:_center_lab WithSpace:2];
        _center_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _center_lab;
}
- (UILabel *)right_lab{
    if (!_right_lab) {
        _right_lab = [UILabel new];
        _right_lab.text = @"可提现\n0.0";
        _right_lab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _right_lab.font = [UIFont getUIFontSize:14 IsBold:NO];
        _right_lab.numberOfLines = 2;
        [UILabel changeLineSpaceForLabel:_right_lab WithSpace:2];
        _right_lab.textAlignment = NSTextAlignmentCenter;
        _right_lab.userInteractionEnabled = YES;
        
        
    }
    return _right_lab;
}

- (UILabel *)rightTop_lab{
    if (!_rightTop_lab) {
        _rightTop_lab = [UILabel new];
        _rightTop_lab.text = @"提现";
        _rightTop_lab.textColor = [UIColor colorWithHexString:@"#2A2B2D"];
        _rightTop_lab.font = [UIFont getUIFontSize:10 IsBold:YES];
        _rightTop_lab.textAlignment = NSTextAlignmentCenter;
        _rightTop_lab.backgroundColor = [UIColor colorWithHexString:@"#F4BD84"];
        _rightTop_lab.layer.masksToBounds = YES;
        _rightTop_lab.layer.cornerRadius = 3;
        _rightTop_lab.userInteractionEnabled = YES;
        
    }
    return _rightTop_lab;
}

- (UILabel *)left_Segment_lab{
    if (!_left_Segment_lab) {
        _left_Segment_lab = [UILabel new];
        _left_Segment_lab.text = @"每日收益";
        _left_Segment_lab.textColor = [UIColor blackColor];
        _left_Segment_lab.font = [UIFont getUIFontSize:16 IsBold:YES];
        _left_Segment_lab.userInteractionEnabled = YES;
        
    }
    return _left_Segment_lab;
}
- (UIView *)left_Segment_view{
    if (!_left_Segment_view) {
        _left_Segment_view = [UIView new];
        _left_Segment_view.backgroundColor = FontThemeColor;
    }
    return _left_Segment_view;
}

- (UILabel *)right_Segment_lab{
    if (!_right_Segment_lab) {
        _right_Segment_lab = [UILabel new];
        _right_Segment_lab.text = @"提现记录";
        _right_Segment_lab.textColor = [UIColor colorWithHexString:@"#999999"];
        _right_Segment_lab.font = [UIFont getUIFontSize:16 IsBold:YES];
        _right_Segment_lab.userInteractionEnabled = YES;
        
    }
    return _right_Segment_lab;
}
- (UIView *)right_Segment_view{
    if (!_right_Segment_view) {
        _right_Segment_view = [UIView new];
        _right_Segment_view.backgroundColor = [UIColor whiteColor];
    }
    return _right_Segment_view;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self getTableViewData];
    [self getTheCreditCardData];

    //禁止单个界面侧滑返回
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}
@end
