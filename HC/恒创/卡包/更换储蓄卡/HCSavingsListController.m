//
//  HCSavingsListController.m
//  HC
//
//  Created by tuibao on 2021/11/12.
//

#import "HCSavingsListController.h"
#import "HCCashCardCell.h"
@interface HCSavingsListController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic , strong) UIImageView *bottom_image;
@property (nonatomic , strong) UIView *bottom_view;
@property (nonatomic , strong) UIImageView *bottom_left_img;
@property (nonatomic , strong) UILabel *bottom_right_lab;

@property (nonatomic , strong) UITableView *tableView;
///储蓄卡数据
@property (nonatomic , strong) NSMutableArray *CashCardArr;
@end

@implementation HCSavingsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"储蓄卡";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getACashCardData) name:@"RefreshCardTable" object:nil];
    [self loadUI];
    [self getACashCardData];
}
#pragma 请求储蓄卡列表数据
- (void)getACashCardData{
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/debit/card/list" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            self.CashCardArr = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            [self.tableView reloadData];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}
#pragma 设置默认储蓄卡
- (void)SetUpTheCashCard:(NSString *)cardID{
    
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
- (void)deleteCashCard:(NSString *)cardID{
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:[NSString stringWithFormat:@"/api/user/debit/card/delete/%@",cardID] Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [XHToast showBottomWithText:responseObject[@"message"]];
            [self getACashCardData];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}




#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.CashCardArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    [cell.xiugai_btn bk_whenTapped:^{
        HCModifySavingsCardController *vc = [HCModifySavingsCardController new];
        vc.CardID = diction[@"id"];
        [self.xp_rootNavigationController pushViewController:vc animated:YES];
    }];
    [cell.right_lab bk_whenTapped:^{
        [self addAlert:diction[@"id"] type:@"设置默认卡"];
    }];
    [cell.delete_btn bk_whenTapped:^{
        [self addAlert:diction[@"id"] type:@"删除"];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //有设置block就返回值
    if (self.block) {
        [self.xp_rootNavigationController popViewControllerAnimated:YES];
        self.block(self.CashCardArr[indexPath.row]);
    }
    
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"tableView_Placeholder"];
}
#pragma 无数据点击刷新
-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self getACashCardData];
}
- (void)addAlert:(NSString *)cardID type:(NSString *)typeStr{
    
    UIAlertController *alterCon = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"是否%@？",typeStr]
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OFF = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *ON = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([typeStr isEqualToString:@"删除"]) {
            [self deleteCashCard:cardID];
        }else{
            [self SetUpTheCashCard:cardID];
        }
    }];
    [alterCon addAction:OFF];
    [alterCon addAction:ON];
    [[UIViewController currentViewController] presentViewController:alterCon animated:YES completion:nil];
}
- (void)loadUI{
    
    
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
        make.left.equalTo(self.bottom_left_img.mas_right).offset(10);
        make.top.bottom.offset(0);
        make.right.offset(-10);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.left.offset(0);
        make.top.offset(0);
        make.bottom.equalTo(self.bottom_image.mas_top).offset(0);
    }];
    
}

- (void)AddCardPackAgeAction{
    [self.xp_rootNavigationController pushViewController:[MCAccreditation4ViewController new] animated:YES];
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
            [self.CashCardArr removeAllObjects];
            [weak_self getACashCardData];
            [weak_self.tableView.mj_header endRefreshing];
        }];
        //上拉加载更多
        _tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self.CashCardArr removeAllObjects];
            [weak_self getACashCardData];
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
        _bottom_right_lab.text = @"添加储蓄卡";
        _bottom_right_lab.textColor = [UIColor colorWithHexString:@"#333333"];
        _bottom_right_lab.font = [UIFont getUIFontSize:18 IsBold:YES];
        _bottom_right_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _bottom_right_lab;
}

@end
