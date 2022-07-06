//
//  HCCardPackageController.m
//  HC
//
//  Created by tuibao on 2021/11/6.
//

#import "HCCardPackageController.h"
#import "HCCardPackageCell.h"
#import "HCCashCardCell.h"
#import "HCModifyTheInformationController.h"
@interface HCCardPackageController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic)  UIImageView *top_image;
@property (strong, nonatomic)  UIView *navigation_View;
@property (strong, nonatomic)  UILabel *nav_title;
@property (strong, nonatomic)  UISegmentedControl *segment;

@property (nonatomic , strong) UIImageView *bottom_image;
@property (nonatomic , strong) UIView *bottom_view;
@property (nonatomic , strong) UIImageView *bottom_left_img;
@property (nonatomic , strong) UILabel *bottom_right_lab;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , assign) BOOL isCardPack;

///信用卡数据
@property (nonatomic , strong) NSMutableArray *CreditCardArr;
///储蓄卡数据
@property (nonatomic , strong) NSMutableArray *CashCardArr;


///删除的cell
@property (nonatomic , strong) UIView *detele_view;
//是否启动指示器
@property (nonatomic , assign) BOOL isIndicator;

@end

@implementation HCCardPackageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isCardPack = NO;
    [self loadUI];
    [self getTheCreditCardData];
    //默认第一次启动 启动为NO
    self.isIndicator = NO;
    //接收刷新的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTheCardData) name:@"RefreshCardTable" object:nil];
    
    
}

- (void)getTheCardData{
    
    if (!self.isCardPack) {
        [self getTheCreditCardData];
    }else{
        [self getACashCardData];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    self.isIndicator = YES;
}

#pragma 请求信用卡列表数据
- (void)getTheCreditCardData{
//    @weakify(self);
    [self NetWorkingPostWithURL:self hiddenHUD:self.isIndicator url:@"/api/user/credit/card/list" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        [self.CreditCardArr removeAllObjects];
        if ([responseObject[@"code"] intValue] == 0) {
            self.CreditCardArr = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        
    }];
    

}
#pragma 设置默认信用卡
- (void)SetUpTheCreditCard:(NSInteger)index{
   
    NSString * cardID= self.CreditCardArr[index][@"id"];
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:[NSString stringWithFormat:@"/api/user/credit/card/change/def/%@",cardID] Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [self getTheCreditCardData];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
#pragma 删除信用卡
- (void)deleteCreditCard:(NSInteger)index{
    
    NSString * cardID= self.CreditCardArr[index][@"id"];
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:[NSString stringWithFormat:@"/api/user/credit/card/delete/%@",cardID] Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [self CrushingCard];
            [XHToast showBottomWithText:responseObject[@"message"]];
            [self getTheCreditCardData];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}
#pragma 修改信用卡
- (void)ModifyTheCreditCard:(NSInteger)index{
    NSDictionary * diction = self.CreditCardArr[index];
    HCModifyTheInformationController *vc = [HCModifyTheInformationController new];
    vc.CardID = diction[@"id"];
    vc.block = ^(NSString * _Nonnull zdStr, NSString * _Nonnull hkStr) {
        [self getTheCreditCardData];
    };
    [self.xp_rootNavigationController pushViewController:vc animated:YES];
}

#pragma 请求储蓄卡列表数据
- (void)getACashCardData{
    @weakify(self);
    [self NetWorkingPostWithURL:self hiddenHUD:self.isIndicator url:@"/api/user/debit/card/list" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        [weak_self.CashCardArr removeAllObjects];
        if ([responseObject[@"code"] intValue] == 0) {
            
            weak_self.CashCardArr = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        
    }];

}
#pragma 设置默认储蓄卡
- (void)SetUpTheCashCard:(NSInteger)index{
    NSString * cardID= self.CashCardArr[index][@"id"];
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:[NSString stringWithFormat:@"/api/user/debit/card/change/def/%@",cardID] Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [self getACashCardData];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    

}
#pragma 删除储蓄卡
- (void)deleteCashCard:(NSInteger)index{
    
    NSString * cardID= self.CashCardArr[index][@"id"];
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:[NSString stringWithFormat:@"/api/user/debit/card/delete/%@",cardID] Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [self CrushingCard];
            [XHToast showBottomWithText:responseObject[@"message"]];
            [self getACashCardData];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}
#pragma 修改储蓄卡
- (void)ModifyTheCashCard:(NSInteger)index{
    @weakify(self);
    NSDictionary * diction = self.CashCardArr[index];
    HCModifySavingsCardController *vc = [HCModifySavingsCardController new];
    vc.CardID = diction[@"id"];
    vc.block = ^(NSString * _Nonnull cardNo, NSString * _Nonnull phone) {
        [weak_self getACashCardData];
    };
    [weak_self.xp_rootNavigationController pushViewController:vc animated:YES];
}
#pragma 粉碎卡片
- (void)CrushingCard{
    
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return !self.isCardPack ? self.CreditCardArr.count : self.CashCardArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isCardPack) {
        static NSString *Identifier = @"HCCardPackageCell";
        HCCardPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(!cell){
            cell=[[[NSBundle mainBundle] loadNibNamed:@"HCCardPackageCell" owner:nil options:nil] lastObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSDictionary * diction = self.CreditCardArr[indexPath.row];
        cell.icon_image.image = [UIImage imageNamed:getBankLogo(diction[@"bankAcronym"])];
        cell.yinhang_lab.text = [NSString stringWithFormat:@"%@",diction[@"bankName"]];
        cell.weihao_lab.text = [NSString stringWithFormat:@"尾号：%@",getAfterFour([diction[@"cardNo"] stringValue])];
        
        cell.left_lab.text = [NSString stringWithFormat:@"账单日期：%@日",diction[@"billDay"]];
        cell.center_lab.text = [NSString stringWithFormat:@"还款日期：%@日",diction[@"repaymentDay"]];
        cell.right_lab.text = [NSString stringWithFormat:@"距离还款日：%@天",diction[@"howRepayment"]];
        
        cell.name_lab.text = [diction[@"fullname"] stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
        
        cell.moren_lab.text = [diction[@"def"] intValue] == 0 ? @"设置默认卡" : @"默认卡";
//        @weakify(self);
        
        [cell.xiugai_btn bk_whenTapped:^{
            [self ModifyTheCreditCard:indexPath.row];
        }];
        
        [cell.moren_lab bk_whenTapped:^{
            [self addAlert:indexPath.row type:@"设置默认卡"];
        }];
        [cell.delete_btn bk_whenTapped:^{
            self.detele_view = cell.contentView;
            [self addAlert:indexPath.row type:@"删除"];
        }];
        return cell;
    }
    else{
        static NSString *Identifier = @"HCCashCardCell";
        HCCashCardCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(!cell){
            cell=[[[NSBundle mainBundle] loadNibNamed:@"HCCashCardCell" owner:nil options:nil] lastObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSDictionary * diction = self.CashCardArr[indexPath.row];
        
        cell.icon_image.image = [UIImage imageNamed:getBankLogo(diction[@"bankAcronym"])];
        cell.yinhang_lab.text = [NSString stringWithFormat:@"%@",diction[@"bankName"]];
        cell.weihao_lab.text = [NSString stringWithFormat:@"尾号：%@",getAfterFour([diction[@"cardNo"] stringValue])];
        
        
        cell.name_lab.text = [diction[@"fullname"] stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
        
        
        cell.right_lab.text = [diction[@"def"] intValue] == 0 ? @"设置默认卡" : @"默认卡";
        @weakify(self);
        [cell.xiugai_btn bk_whenTapped:^{
            [weak_self ModifyTheCashCard:indexPath.row];
        }];
        [cell.right_lab bk_whenTapped:^{
            [weak_self addAlert:indexPath.row type:@"设置默认卡"];
        }];
        [cell.delete_btn bk_whenTapped:^{
            self.detele_view = cell.contentView;
            [weak_self addAlert:indexPath.row type:@"删除"];
        }];
        return cell;
    }
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"tableView_Placeholder"];
}
#pragma 无数据点击刷新
-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self TableViewRefresh];
}

- (void)addAlert:(NSInteger)index type:(NSString *)typeStr{
    @weakify(self);
    UIAlertController *alterCon = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"是否%@？",typeStr]
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OFF = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *ON = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([typeStr isEqualToString:@"删除"]) {
            if (!weak_self.isCardPack) {
                [weak_self deleteCreditCard:index];
            }else{
                [weak_self deleteCashCard:index];
            }
        }else{
            if (!weak_self.isCardPack) {
                [weak_self SetUpTheCreditCard:index];
            }else{
                [weak_self SetUpTheCashCard:index];
            }
        }
    }];
    [alterCon addAction:OFF];
    [alterCon addAction:ON];
    [[UIViewController currentViewController] presentViewController:alterCon animated:YES completion:nil];
}

- (void)loadUI{
    
    [self.view addSubview:self.top_image];
    [self.top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kTopHeight + 65);
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
   
    [self.view addSubview:self.nav_title];
    [self.nav_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navigation_View);
    }];
    
    
    _segment = [[UISegmentedControl alloc]initWithItems:@[@"信用卡",@"储蓄卡"]];
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    _segment.tintColor = [UIColor colorWithHexString:@"#F4CA99"];
    [_segment ensureiOS12Style];
    
    [self.view addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 40));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.navigation_View.mas_bottom).offset(20);
    }];
    
    [self.view addSubview:self.bottom_image];
    [self.bottom_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 46));
        make.left.offset(0);
        make.bottom.offset(-kTabBarHeight);
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
        make.left.equalTo(self.bottom_left_img.mas_right).offset(10);
        make.top.bottom.offset(0);
        make.right.offset(-10);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.left.offset(0);
        make.top.equalTo(self.top_image.mas_bottom).offset(10);
        make.bottom.equalTo(self.bottom_image.mas_top).offset(0);
    }];
    
}
-(void)segmentSelected:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    
    self.isCardPack = control.selectedSegmentIndex;
    self.isIndicator = NO;
    if (!self.isCardPack) {
        [self getTheCreditCardData];
        self.bottom_right_lab.text = @"添加信用卡";
    }else{
        [self getACashCardData];
        self.bottom_right_lab.text = @"添加储蓄卡";
    }
    [self.tableView reloadData];
}


- (void)AddCardPackAgeAction{
    
    if (!self.isCardPack) {
        
        [self.xp_rootNavigationController pushViewController:[HCAddCreditCardController new] animated:YES];
    }else{
        
        [self.xp_rootNavigationController pushViewController:[MCAccreditation4ViewController new] animated:YES];
    }
    
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
            [weak_self TableViewRefresh];
            [weak_self.tableView.mj_header endRefreshing];
        }];
        //上拉加载更多
        _tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weak_self TableViewRefresh];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
    }
    return _tableView;
}
- (void)TableViewRefresh{
    if (!self.isCardPack) {
        [self getTheCreditCardData];
    }else{
        [self getACashCardData];
    }
}
- (UIImageView *)top_image{
    if (!_top_image) {
        _top_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_topBGTwo"]];
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

- (UILabel *)nav_title{
    if (!_nav_title) {
        _nav_title = [UILabel new];
        _nav_title.text = @"我的卡包";
        _nav_title.textColor = FontThemeColor;
        _nav_title.font = [UIFont boldSystemFontOfSize:18];
    }
    return _nav_title;
}

- (UIImageView *)bottom_image{
    if (!_bottom_image) {
        _bottom_image = [UIImageView getUIImageView:@"icon_jbbg"];
        _bottom_image.userInteractionEnabled = YES;
        [_bottom_image bk_whenTapped:^{
            [self AddCardPackAgeAction];
        }];
    }
    return _bottom_image;
}
- (UIView *)bottom_view{
    if (!_bottom_view) {
        _bottom_view = [UIView new];
        _bottom_view.userInteractionEnabled = NO;
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //禁止单个界面侧滑返回
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

@end
