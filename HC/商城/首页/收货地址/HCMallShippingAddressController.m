//
//  HCMallShippingAddressController.m
//  HC
//
//  Created by tuibao on 2021/12/23.
//

#import "HCMallShippingAddressController.h"
#import "HCMallShippingAddressCell.h"
#import "HCMallAddAdressController.h"
@interface HCMallShippingAddressController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIButton *finishBtn;
@property (nonatomic , strong) NSMutableArray *dataArr;

@end

@implementation HCMallShippingAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收货地址";
    self.view.backgroundColor = [UIColor whiteColor];
    [self LoadUI];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self LoadData];
}




- (void)LoadData{
    
    NSDictionary *UserDic = [self loadUserData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:UserDic[@"username"] forKey:@"phone"];
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/shop/getMyAddress" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            self.dataArr = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            [self.tableView reloadData];
            
            
            if(self.dataArr.count == 0){
                NSNotification *LoseResponse = [NSNotification notificationWithName:@"addressType" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:LoseResponse];
            }
        }
    } failure:^(NSString * _Nonnull error) {

    }];
    
}

- (void)AddAdressAction{
    HCMallAddAdressController *VC = [HCMallAddAdressController new];
    
    [self.xp_rootNavigationController pushViewController:VC animated:YES];
}
- (void)LoadUI{
    [self.view addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 46));
        make.left.offset(15);
        make.bottom.offset(-15-KBottomHeight);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.left.right.offset(0);
        make.top.offset(0);
        make.bottom.equalTo(self.finishBtn.mas_top).offset(-15);
    }];
    [self.tableView reloadData];
    
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Identifier = @"HCMallShippingAddressCell";
    HCMallShippingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCMallShippingAddressCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    
    cell.name.text = dic[@"name"];
    
    cell.phone.text = dic[@"userCall"];
    
    cell.content.text = dic[@"myAddress"];
    
    [cell.clean_but bk_whenTapped:^{
        [self cleanAddress:indexPath.row];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.block) {
        self.block(self.dataArr[indexPath.row]);
        [self.xp_rootNavigationController popViewControllerAnimated:YES];
    }
    
}

- (void)cleanAddress:(NSInteger)index{
    
    NSDictionary *dic = self.dataArr[index];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:dic[@"id"] forKey:@"id"];
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/shop/dAddress" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            [XHToast showBottomWithText:@"删除成功"];
            [self LoadData];
        }
    } failure:^(NSString * _Nonnull error) {

    }];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"tableView_Placeholder"];
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
        
    }
    return _tableView;
}

- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton new];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"KD_BindCardBtn"] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"添加地址" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont getUIFontSize:18 IsBold:YES];
        [_finishBtn bk_whenTapped:^{
            [self AddAdressAction];
        }];
    }
    return _finishBtn;
}

@end
