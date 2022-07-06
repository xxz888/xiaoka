//
//  HCBetweenStraightController.m
//  HC
//
//  Created by tuibao on 2021/11/19.
//

#import "HCBetweenStraightController.h"
#import "HCBetweenStraightCell.h"
#import "YCMenuView.h"
@interface HCBetweenStraightController ()<UITableViewDelegate, UITableViewDataSource , DZNEmptyDataSetSource, DZNEmptyDataSetDelegate , UITextFieldDelegate>{
    NSInteger ThisPage;
}
@property (nonatomic , strong) UIView *search_view;
@property (nonatomic , strong) UIImageView *search_image;
@property (nonatomic , strong) UITextField *search_textField;
@property (nonatomic , strong) UIButton *search_btn;

@property (nonatomic , strong) UIView *screening_view;
@property (nonatomic , strong) UIButton *screening_btn;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *dataArray;
//请求参数
@property (nonatomic , strong) NSMutableDictionary *params;

@end

@implementation HCBetweenStraightController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@用户",self.type]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.params = [NSMutableDictionary dictionary];
    ThisPage = 1;
    [self.params setObject:@"20" forKey:@"pageSize"];
    
    [self loadUI];
    
    [self TableViewRefresh];
    
}

- (void)TableViewRefresh{
    if([self.type isEqualToString:@"直推"] || [self.type isEqualToString:@"团队"]){
        [self TableViewRefreshData:@"/api/user/get/direct/list"];
    }else if([self.type isEqualToString:@"间推"]){
        [self TableViewRefreshData:@"/api/user/get/indirect/list"];
    }
}

- (void)screeningAddName:(NSString *)name{
    [self.screening_btn setTitle:name forState:UIControlStateNormal];
    [self.screening_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    
    if ([name isEqualToString:@"全部"]) {
        [self.params setObject:@"" forKey:@"selfLevel"];
        [self.params setObject:@"" forKey:@"vipLevel"];
    }
    else if ([name isEqualToString:@"未实名"]){
        [self.params setObject:@"0" forKey:@"selfLevel"];
    }
    else if ([name isEqualToString:@"已实名"]){
        [self.params setObject:@"2" forKey:@"selfLevel"];
    }
    else if ([name isEqualToString:@"普通"]){
        [self.params setObject:@"0" forKey:@"vipLevel"];
    }
    else if ([name isEqualToString:@"V1"]){
        [self.params setObject:@"1" forKey:@"vipLevel"];
    }
    else if ([name isEqualToString:@"V2"]){
        [self.params setObject:@"2" forKey:@"vipLevel"];
    }
    else if ([name isEqualToString:@"V3"]){
        [self.params setObject:@"3" forKey:@"vipLevel"];
    }
    
    [self TableViewRefresh];
}
#pragma 请求直推间推列表数据 直推 = 团队
- (void)TableViewRefreshData:(NSString *)url{
    
    
    [self.params setValue:[NSString stringWithFormat:@"%li",ThisPage] forKey:@"currentPage"];
    
    if(self.search_textField.text.length > 0){
        if ([self isNum:self.search_textField.text]) {
            [self.params removeObjectForKey:@"fullname"];
            [self.params setValue:self.search_textField.text forKey:@"phone"];
        }else{
            [self.params removeObjectForKey:@"phone"];
            [self.params setValue:self.search_textField.text forKey:@"fullname"];
        }
    }
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:url Params:self.params success:^(id  _Nonnull responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            
            NSArray * array = responseObject[@"data"];
            if (self->ThisPage == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:array];
                [self.tableView.mj_footer endRefreshing];
            }
            else {
                //没有更多数据
                if (![responseObject[@"data"] count]) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.dataArray addObjectsFromArray:array];
            }
            [self.tableView reloadData];

        }else{
            [XHToast showBottomWithText:responseObject[@"message"] duration:2];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}
#pragma 判断输入的字符串是否全为数字
- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

#pragma UITextFieldDelegate
//4. 完成编辑时的代理方法
-(void)textFieldDidEndEditing:(UITextField *)textField{

    if(textField.text.length > 0){
        self->ThisPage = 1 ;
        [self TableViewRefresh];
    }else if (textField.text.length == 0){
        
        self->ThisPage = 1;
        [self.params removeObjectForKey:@"fullname"];
        [self.params removeObjectForKey:@"phone"];
        [self TableViewRefresh];
        
    }
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      
    static NSString *Identifier = @"HCBetweenStraightCell";
    HCBetweenStraightCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCBetweenStraightCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    NSDictionary * data = self.dataArray[indexPath.row];
    
    //用户姓名
    cell.name_lab.text = [[data allKeys] containsObject:@"fullname"] ? data[@"fullname"] : @"未实名";
    
    
    //用户姓名
    if ([data[@"vipLevel"] intValue] == 0) {
        cell.dengji_lab.text = @"普通";
    }else{
        cell.dengji_lab.text = [NSString stringWithFormat:@"V%@",data[@"vipLevel"]];
    }
    //登录名称 == 手机号码
    [cell.phone_btn setTitle:[NSString getSecrectStringWithPhoneNumber:data[@"username"]]  forState:UIControlStateNormal];
    //注册时间
    cell.time_lab.text = [NSString stringWithFormat:@"注册时间：%@",data[@"createTime"]];
    
    NSString *typeStr = @"";
    if ([self.type isEqualToString:@"间推"]) {
        typeStr = @"间推";
    }else{
        typeStr = @"直推";
    }
    
    //直推人数 间推人数
    NSString *Str1 = [NSString stringWithFormat:@"%@",data[@"firstCount"]] ;
    
    
    //团队人数
    NSString *Str2 = data[@"teamCount"];
    
    
    
    //直推激活 间推激活
    NSString *Str3 = [NSString stringWithFormat:@"%@",data[@"firstActivationCount"]];
    

    cell.lab1.attributedText = [UILabel setupAttributeString:[NSString stringWithFormat:@"%@人数：%@",typeStr,Str1] rangeText:[NSString stringWithFormat:@"%@人数：",typeStr] textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
    cell.lab2.attributedText = [UILabel setupAttributeString:[NSString stringWithFormat:@"团队人数：%@",Str2] rangeText:@"团队人数：" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
    
    
    
    cell.lab3.attributedText = [UILabel setupAttributeString:[NSString stringWithFormat:@"%@激活：%@",typeStr,Str3] rangeText:[NSString stringWithFormat:@"%@激活：",typeStr] textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
    cell.lab4.attributedText = [UILabel setupAttributeString:[NSString stringWithFormat:@"本月交易量(元)：%@",[NSString stringChineseFormat:[data[@"curMonthAllAmount"] doubleValue]]] rangeText:@"本月交易量(元)：" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
    
    [cell.phone_btn bk_whenTapped:^{
        if(![self.type isEqualToString:@"间推"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",data[@"username"]]] options:@{} completionHandler:nil];
        }
    }];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"tableView_Placeholder"];
}
#pragma 无数据点击刷新
-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self TableViewRefresh];
}

- (void)loadUI{
    
    
    [self.view addSubview:self.search_view];
    [self.search_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-110, 35));
        make.top.offset(15);
        make.left.offset(10);
    }];
    [self.search_view addSubview:self.search_image];
    [self.search_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.search_view);
        make.left.offset(10);
    }];
    self.search_textField.delegate = self;
    [self.search_btn bk_whenTapped:^{
        if(self.search_textField.text.length == 0){
            return;
        }
            
        [self TableViewRefresh];
    }];
    [self.search_view addSubview:self.search_btn];
    [self.search_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(35);
        make.centerY.equalTo(self.search_view);
        make.right.offset(-10);
    }];
    [self.search_view addSubview:self.search_textField];
    [self.search_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.centerY.equalTo(self.search_view);
        make.left.equalTo(self.search_image.mas_right).offset(10);
        make.right.equalTo(self.search_btn.mas_left).offset(-10);
    }];
    
    
    [self.view addSubview:self.screening_view];
    [self.screening_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.search_view);
        make.width.offset(80);
        make.height.offset(35);
        make.right.offset(-10);
    }];
    [self.screening_view addSubview:self.screening_btn];
    [self.screening_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.screening_view);
    }];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.left.offset(0);
        make.top.equalTo(self.search_view.mas_bottom).offset(10);
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
            self->ThisPage = 1;
            [weak_self TableViewRefresh];
            [weak_self.tableView.mj_header endRefreshing];
        }];
        //上拉加载更多
        _tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self->ThisPage ++;
            [weak_self TableViewRefresh];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
    }
    return _tableView;
}
- (UIView *)search_view{
    if (!_search_view) {
        _search_view = [UIView new];
        self.search_view.backgroundColor = [UIColor whiteColor];
        self.search_view.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
        self.search_view.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
        self.search_view.layer.shadowRadius = 3;// 阴影半径，默认3
        self.search_view.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
        self.search_view.layer.cornerRadius = 5;
        
    }
    return _search_view;
    
}
- (UIImageView *)search_image{
    if (!_search_image) {
        _search_image = [UIImageView getUIImageView:@"icon_Between_search"];
    }
    return _search_image;
}

- (UITextField *)search_textField{
    if (!_search_textField) {
        _search_textField = [UITextField new];
        _search_textField.placeholder = @"请输入手机号或者姓名";
        _search_textField.font = [UIFont getUIFontSize:13 IsBold:NO];
        _search_textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _search_textField;
}

- (UIButton *)search_btn{
    if (!_search_btn) {
        _search_btn = [UIButton new];
        [_search_btn setTitle:@"搜索" forState:UIControlStateNormal];
        [_search_btn setTitleColor:[UIColor colorWithHexString:@"#FF9426"] forState:UIControlStateNormal];
        _search_btn.titleLabel.font = [UIFont getUIFontSize:13 IsBold:YES];
        [_search_btn setEnlargeEdgeWithTop:10 right:15 bottom:10 left:15];
    }
    return _search_btn;
}


- (UIView *)screening_view{
    if (!_screening_view) {
        _screening_view = [UIView new];
        self.screening_view.backgroundColor = [UIColor whiteColor];
        self.screening_view.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
        self.screening_view.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
        self.screening_view.layer.shadowRadius = 3;// 阴影半径，默认3
        self.screening_view.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
        self.screening_view.layer.cornerRadius = 5;
        [self.screening_view bk_whenTapped:^{
            [self screeningAction];
        }];
    }
    return _screening_view;
    
}


- (UIButton *)screening_btn{
    if (!_screening_btn) {
        _screening_btn = [UIButton new];
        [_screening_btn setTitle:@"全部" forState:UIControlStateNormal];
        [_screening_btn setImage:[UIImage imageNamed:@"icon_Between_sanjiao"] forState:UIControlStateNormal];
        [_screening_btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _screening_btn.titleLabel.font = [UIFont getUIFontSize:13 IsBold:YES];
        [_screening_btn setEnlargeEdgeWithTop:10 right:15 bottom:10 left:15];
        [_screening_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
        [self.screening_btn bk_whenTapped:^{
            [self screeningAction];
        }];
    }
    return _screening_btn;
}


#pragma 右侧筛选
- (void)screeningAction{
    YCMenuAction *action0 = [YCMenuAction actionWithTitle:@"全部" image:nil handler:^(YCMenuAction *action) {
        [self screeningAddName:@"全部"];
    }];
    YCMenuAction *action = [YCMenuAction actionWithTitle:@"未实名" image:nil handler:^(YCMenuAction *action) {
        [self screeningAddName:@"未实名"];
    }];
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"已实名" image:nil handler:^(YCMenuAction *action) {
        [self screeningAddName:@"已实名"];
    }];
    YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"普通" image:nil handler:^(YCMenuAction *action) {
        [self screeningAddName:@"普通"];
    }];
    YCMenuAction *action3 = [YCMenuAction actionWithTitle:@"V1" image:nil handler:^(YCMenuAction *action) {
        [self screeningAddName:@"V1"];
    }];
    YCMenuAction *action4 = [YCMenuAction actionWithTitle:@"V2" image:nil handler:^(YCMenuAction *action) {
        [self screeningAddName:@"V2"];
    }];
    YCMenuAction *action5 = [YCMenuAction actionWithTitle:@"V3" image:nil handler:^(YCMenuAction *action) {
        [self screeningAddName:@"V3"];
    }];
    NSArray *arr = @[action0,action,action1,action2,action3,action4,action5];
    
    // 创建
    YCMenuView *view = [YCMenuView menuWithActions:arr width:140 relyonView:self.screening_view];
    view.maxDisplayCount = 6;
    
    view.menuSelectCell = self.screening_btn.titleLabel.text;
    
    // 显示
    [view show];
    
}

@end
