//
//  HCModifySavingsCardController.m
//  HC
//
//  Created by tuibao on 2021/11/11.
//

#import "HCModifySavingsCardController.h"
#import "HCModifySavingsCardCell.h"
@interface HCModifySavingsCardController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIButton *finishBtn;

@property (nonatomic , strong) NSMutableArray *dataArr;



@property (nonatomic , strong) UIButton *rightbtn;

@end

@implementation HCModifySavingsCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"修改储蓄卡";
    self.dataArr = [NSMutableArray array];
    
    [self LoadUI];
    if (self.empowerToken.length > 0) {
        [self loadData];
    }else{
        [self getCardData];
    }
    
}
#pragma 获取卡片基本信息
- (void)getCardData{
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:[NSString stringWithFormat:@"/api/user/debit/card/get/%@",self.CardID] Params:[NSMutableDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            self.data = responseObject[@"data"];
            [self loadData];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
    
}

- (void)loadData{
    HCConfirmPayModel *model0 = self.dataArr[0];
    HCConfirmPayModel *model1 = self.dataArr[1];
    HCConfirmPayModel *model2 = self.dataArr[2];
    HCConfirmPayModel *model3 = self.dataArr[3];
    
    model0.content = self.data[@"fullname"];
    model1.content = [self.data[@"idCard"] length] == 0 ? self.customer_idCard : self.data[@"idCard"];
    model2.content = self.data[@"cardNo"];
    model3.content = self.data[@"phone"];
    
    [self.tableView reloadData];
}

#pragma 更改卡片基本信息
- (void)getPayAction{
    
    HCConfirmPayModel *model2 = self.dataArr[2];
    HCConfirmPayModel *model3 = self.dataArr[3];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.data[@"id"] forKey:@"id"];//储蓄卡id
    [params setValue:model2.content forKey:@"cardNo"];//卡号
    [params setValue:model3.content forKey:@"phone"];//手机号
    
    if (self.empowerToken.length > 0) {
        [params setObject:self.empowerToken forKey:@"empowerToken"];
    }
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/debit/card/update" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            if(self.block){
                self.block(model2.content, model3.content);
            }
            [XHToast showBottomWithText:responseObject[@"message"]];
            [self.xp_rootNavigationController popViewControllerAnimated:YES];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"HCModifySavingsCardCell";
    HCModifySavingsCardCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCModifySavingsCardCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = self.dataArr[indexPath.row];
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.content_textfield.textColor = [UIColor colorWithHexString:@"#999999"];
    }else{
        if (!self.rightbtn.selected) {
            cell.content_textfield.textColor = [UIColor colorWithHexString:@"#999999"];
        }else{
            cell.content_textfield.textColor = [UIColor blackColor];
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)LoadUI{
    
    NSArray *data = [NSMutableArray arrayWithObjects:@"姓名",@"身份证",@"储蓄卡号",@"储蓄卡预留电话", nil];
    for (int i = 0; i < data.count; i++) {
        HCConfirmPayModel *model = [HCConfirmPayModel new];
        model.name = data[i];
        
        model.placeholder = [NSString stringWithFormat:@"请输入%@",data[i]];
        
        
        [self.dataArr addObject:model];
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(200);
        make.left.top.right.offset(0);
    }];
    
    [self.view addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 46));
        make.left.offset(15);
        make.top.equalTo(self.tableView.mas_bottom).offset(50);
    }];
    self.rightbtn = [UIButton new];
    
    if (self.empowerToken.length > 0) {
        
        [self.finishBtn setHidden:YES];
        self.tableView.userInteractionEnabled = NO;
        
        UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //修改按钮向右偏移10 point
        [settingButton setFrame:CGRectMake(10.0, 0.0, 44.0, 44.0)];
        [settingButton addTarget:self action:@selector(settingButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [settingButton setTitle:@"编辑" forState:UIControlStateNormal];
        [settingButton setTitle:@"取消" forState:UIControlStateSelected];
        [settingButton setTitleColor:FontThemeColor forState:UIControlStateNormal];
        settingButton.titleLabel.font = [UIFont getUIFontSize:15 IsBold:NO];
        [settingButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        //修改方法
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
        [view addSubview:settingButton];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }else{
        self.rightbtn.selected = YES;
    }
    
}

- (void)settingButtonOnClicked:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    self.rightbtn.selected = sender.selected;
    if (sender.selected) {
        [self.finishBtn setHidden:NO];
        self.tableView.userInteractionEnabled = YES;
        [self loadData];
    }else{
        [self.finishBtn setHidden:YES];
        self.tableView.userInteractionEnabled = NO;
        [self loadData];
    }
    
}

#pragma 懒加载
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
- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton new];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"KD_BindCardBtn"] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"确定修改" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont getUIFontSize:18 IsBold:YES];
        [_finishBtn bk_whenTapped:^{
            [self getPayAction];
        }];
    }
    return _finishBtn;
}

@end
