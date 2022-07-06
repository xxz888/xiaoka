//
//  HCInvestmentDetailController.m
//  HC
//
//  Created by tuibao on 2021/11/19.
//

#import "HCInvestmentDetailController.h"
#import "HCInvestmentDetailCell.h"
#import "HCBetweenStraightController.h"
@interface HCInvestmentDetailController ()<UITableViewDelegate, UITableViewDataSource , DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic , strong)  UIImageView *top_image;
@property (nonatomic , strong)  UIView *navigation_View;
@property (nonatomic , strong)  UIButton *nav_back;
@property (nonatomic , strong)  UILabel *nav_title;

@property (nonatomic , strong)  UIButton *year_btn;
@property (nonatomic , strong)  UIButton *month_btn;

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableDictionary *params;

@property (nonatomic , strong) NSDictionary *dataDic;

@end

@implementation HCInvestmentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.params = [NSMutableDictionary dictionary];
    [self loadUI];
}

- (void)TableViewRefresh{

    [self NetWorkingPostWithAddressURL:self hiddenHUD:NO url:@"/api/user/get/attract/profit/time/list" Params:self.params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            self.dataDic = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
            [self.tableView reloadData];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    static NSString *Identifier = @"HCInvestmentDetailCell";
    HCInvestmentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCInvestmentDetailCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    if (indexPath.row == 2) {
        cell.title_lab.text = @"总计";
        [cell.right_btn setHidden:YES];
    }else{
        if (indexPath.row == 0) {
            cell.title_lab.text = @"直推";
        }else{
            cell.title_lab.text = @"间推";
        }
        [cell.right_btn setHidden:NO];
    }
    
    if (self.dataDic.count > 0) {
        
        if (indexPath.row == 0) {
            cell.number_lab1.text = [NSString stringWithFormat:@"%@人已注册",self.dataDic[@"firstCount"]];
            cell.number_lab2.text = [NSString stringWithFormat:@"%@人已实名",self.dataDic[@"firstRealnameCount"]];
            cell.number_lab3.text = [NSString stringWithFormat:@"%@人已激活",self.dataDic[@"firstActivationCount"]];
            cell.number_lab4.text = [NSString stringWithFormat:@"%.2f元招商收益",[self.dataDic[@"curMonthFirstAmount"] doubleValue]];
        }
        else if(indexPath.row == 1){
            cell.number_lab1.text = [NSString stringWithFormat:@"%@人已注册",self.dataDic[@"secondCount"]];
            cell.number_lab2.text = [NSString stringWithFormat:@"%@人已实名",self.dataDic[@"secondRealnameCount"]];
            cell.number_lab3.text = [NSString stringWithFormat:@"%@人已激活",self.dataDic[@"secondActivationCount"]];
            cell.number_lab4.text = [NSString stringWithFormat:@"%.2f元招商收益",[self.dataDic[@"curMonthSecondAmount"] doubleValue]];
        }
        else if (indexPath.row == 2){
            
            cell.number_lab1.text = [NSString stringWithFormat:@"%i人已注册",[self.dataDic[@"firstCount"] intValue] + [self.dataDic[@"secondCount"] intValue]];
            cell.number_lab2.text = [NSString stringWithFormat:@"%i人已实名",[self.dataDic[@"firstRealnameCount"] intValue] + [self.dataDic[@"secondRealnameCount"] intValue]];
            cell.number_lab3.text = [NSString stringWithFormat:@"%i人已激活",[self.dataDic[@"firstActivationCount"] intValue] + [self.dataDic[@"secondActivationCount"] intValue]];
            cell.number_lab4.text = [NSString stringWithFormat:@"%.2f元招商收益",[self.dataDic[@"curMonthFirstAmount"] doubleValue] + [self.dataDic[@"curMonthSecondAmount"] doubleValue]];
        }
    }
    
    cell.number_lab1.attributedText = [UILabel setupAttributeString:cell.number_lab1.text rangeText:@"已注册" textColor:[UIColor colorWithHexString:@"#FF9426"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
    cell.number_lab2.attributedText = [UILabel setupAttributeString:cell.number_lab2.text rangeText:@"已实名" textColor:[UIColor colorWithHexString:@"#FF9426"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
    cell.number_lab3.attributedText = [UILabel setupAttributeString:cell.number_lab3.text rangeText:@"已激活" textColor:[UIColor colorWithHexString:@"#FF9426"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
    cell.number_lab4.attributedText = [UILabel setupAttributeString:cell.number_lab4.text rangeText:@"招商收益" textColor:[UIColor colorWithHexString:@"#FF9426"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.row == 2) return;
    
    HCBetweenStraightController *VC = [HCBetweenStraightController new];
    if(indexPath.row == 0){
        VC.type = @"直推";
    }else if(indexPath.row == 1){
        VC.type = @"间推";
    }
    [self.xp_rootNavigationController pushViewController:VC animated:YES];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"tableView_Placeholder"];
}
#pragma 无数据点击刷新
-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self TableViewRefresh];
}
- (void)loadUI{
    
    [self.view addSubview:self.top_image];
    [self.top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50 + kTopHeight);
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
    [self.nav_back bk_whenTapped:^{
        [self.xp_rootNavigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:self.nav_back];
    [self.nav_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.centerY.equalTo(self.navigation_View);
    }];
    [self.view addSubview:self.nav_title];
    [self.nav_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navigation_View);
    }];
    
    [self.view addSubview:self.year_btn];
    [self.year_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH/2);
        make.bottom.equalTo(self.top_image.mas_bottom).offset(-10);
        make.left.offset(0);
    }];
    [self.view addSubview:self.month_btn];
    [self.month_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH/2);
        make.bottom.equalTo(self.top_image.mas_bottom).offset(-10);
        make.right.offset(0);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.left.offset(0);
        make.top.equalTo(self.top_image.mas_bottom).offset(0);
        make.bottom.offset(-KBottomHeight);
    }];
    
    NSString *time = [NSDate GetCurrentDateType:DateTypeYMD];
    [self AddTime:time];
    
    [self.year_btn bk_whenTapped:^{
        [self selectYearMonth];
    }];
    [self.month_btn bk_whenTapped:^{
        [self selectYearMonth];
    }];
    
}
#pragma 筛选时间赋值
- (void)AddTime:(NSString *)time{
    NSArray *array = [time componentsSeparatedByString:@"-"];
    [self.year_btn setTitle:[NSString stringWithFormat:@"%@年",array[0]] forState:UIControlStateNormal];
    [self.month_btn setTitle:[NSString stringWithFormat:@"%@月",array[1]] forState:UIControlStateNormal];
    [self.year_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    [self.month_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    
    [self.params setObject:array[0] forKey:@"year"];
    [self.params setObject:array[1] forKey:@"month"];
    
    [self TableViewRefresh];
}


- (void)selectYearMonth{
    //截止时间
    WSDatePickerView *dateView = [[WSDatePickerView alloc]initWithDateStyle:DateStyleShowMonth CompleteBlock:^(NSDate *Data, NSString *Str, id OtherString) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        NSString *strDate = [dateFormatter stringFromDate:Data];
        [self AddTime:strDate];
    }];
    [dateView show];
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
        
    }
    return _tableView;
}


- (UIImageView *)top_image{
    if (!_top_image) {
        _top_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_topBGTwo"]];
    }
    return _top_image;
}
- (UIView *)navigation_View{
    if (!_navigation_View) {
        _navigation_View = [UIView new];
    }
    return _navigation_View;
}
- (UIButton *)nav_back{
    if (!_nav_back) {
        _nav_back = [UIButton new];
        [_nav_back setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_nav_back setEnlargeEdgeWithTop:10 right:20 bottom:10 left:10];
    }
    return _nav_back;
}
- (UILabel *)nav_title{
    if (!_nav_title) {
        _nav_title = [UILabel new];
        _nav_title.text = @"招商收益";
        _nav_title.textColor = FontThemeColor;
        _nav_title.font = [UIFont boldSystemFontOfSize:18];
    }
    return _nav_title;
}
- (UIButton *)year_btn{
    if (!_year_btn) {
        _year_btn = [[UIButton alloc]init];
        [_year_btn setTitle:@"年" forState:UIControlStateNormal];
        [_year_btn setTitleColor:FontThemeColor forState:UIControlStateNormal];
        _year_btn.titleLabel.font = [UIFont getUIFontSize:18 IsBold:YES];
        [_year_btn setImage:[UIImage imageNamed:@"icon_Investment_sanjiao"] forState:UIControlStateNormal];
        [_year_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];

    }
    return _year_btn;
}

- (UIButton *)month_btn{
    if (!_month_btn) {
        _month_btn = [[UIButton alloc]init];
        [_month_btn setTitle:@"月" forState:UIControlStateNormal];
        [_month_btn setTitleColor:FontThemeColor forState:UIControlStateNormal];
        _month_btn.titleLabel.font = [UIFont getUIFontSize:18 IsBold:YES];
        [_month_btn setImage:[UIImage imageNamed:@"icon_Investment_sanjiao"] forState:UIControlStateNormal];
        [_month_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];

    }
    return _month_btn;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
@end
