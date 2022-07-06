//
//  HCModifyTheInformationController.m
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import "HCModifyTheInformationController.h"
#import "HCModifyTheInformationCell.h"
#import "HCConfirmPayModel.h"
@interface HCModifyTheInformationController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) UIImageView *top_imageView;
@property (nonatomic , strong) UILabel *top_lab;
@property (nonatomic , strong) UIView *content_view;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UILabel *tishi_lab;
@property (strong, nonatomic)  UIButton *finishBtn;

@property (nonatomic , strong) NSMutableArray *dataArr;

@end

@implementation HCModifyTheInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"修改信用卡";
    self.dataArr = [NSMutableArray array];
    
    [self LoadUI];
    [self getCardData];
}

#pragma 获取卡片基本信息
- (void)getCardData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(self.empowerToken.length > 0){
        [params setValue:self.empowerToken forKey:@"empowerToken"];
    }
    
    
    [self NetWorkingPostWithAddressURL:self hiddenHUD:NO url:[NSString stringWithFormat:@"/api/user/credit/card/get/%@",self.CardID] Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            NSDictionary *data = responseObject[@"data"];
            HCConfirmPayModel *model0 = self.dataArr[0];
            HCConfirmPayModel *model1 = self.dataArr[1];
            HCConfirmPayModel *model2 = self.dataArr[2];
            HCConfirmPayModel *model3 = self.dataArr[3];
            HCConfirmPayModel *model4 = self.dataArr[4];
            HCConfirmPayModel *model5 = self.dataArr[5];
            
            model0.content = data[@"cardNo"];
            model1.content = data[@"phone"];
            model2.content = data[@"expiredTime"];
            model3.content = data[@"securityCode"];
            model4.content = [NSString stringWithFormat:@"%@",data[@"billDay"]];
            model5.content = [NSString stringWithFormat:@"%@",data[@"repaymentDay"]];
            
            [self.tableView reloadData];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
    
}

#pragma 更改卡片基本信息
- (void)getPayAction{
    
    HCConfirmPayModel *model0 = self.dataArr[0];
    HCConfirmPayModel *model1 = self.dataArr[1];
    HCConfirmPayModel *model2 = self.dataArr[2];
    HCConfirmPayModel *model3 = self.dataArr[3];
    HCConfirmPayModel *model4 = self.dataArr[4];
    HCConfirmPayModel *model5 = self.dataArr[5];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.CardID forKey:@"id"];//银行卡id
    [params setValue:model0.content forKey:@"cardNo"];//银行卡号
    [params setValue:model1.content forKey:@"phone"];//预留手机号
    [params setValue:model2.content forKey:@"expiredTime"];//有效期
    [params setValue:model3.content forKey:@"securityCode"];//安全码
    [params setValue:model4.content forKey:@"billDay"];//账单日
    [params setValue:model5.content forKey:@"repaymentDay"];//还款日
    
    if(self.empowerToken.length > 0){
        [params setValue:self.empowerToken forKey:@"empowerToken"];
    }
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/credit/card/update" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            if (self.block) {
                self.block(model4.content, model5.content);
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
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Identifier = @"HCModifyTheInformationCell";
    HCModifyTheInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCModifyTheInformationCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.index = indexPath;
    cell.model = self.dataArr[indexPath.row];
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.content_textfield.textColor = [UIColor colorWithHexString:@"#999999"];
        cell.content_textfield.userInteractionEnabled = NO;
    }else{
        cell.content_textfield.textColor = [UIColor blackColor];
        cell.content_textfield.userInteractionEnabled = YES;
    }
    if ([cell.title_lab.text isEqualToString:@"账单日"] || [cell.title_lab.text isEqualToString:@"还款日"]) {
        
        [cell.content_textfield bk_whenTapped:^{
            //下次跟进时间
            WSDatePickerView *dateView = [[WSDatePickerView alloc]initWithDateStyle:DateStyleShowOtherString CompleteBlock:^(NSDate *Data, NSString *Str, id OtherString) {
                cell.content_textfield.text = Str;
                cell.model.content = Str;//保存
            }];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < 31; i++) {
                [arr addObject:[NSString stringWithFormat:@"%i",i+1]];
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy"];
            NSString *strDate = [dateFormatter stringFromDate:[NSDate new]];
            
            dateView.showYearViewMax = strDate;
            dateView.MyearArray = arr;
            [dateView show];
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)LoadUI{
    
    NSArray *data = [NSMutableArray arrayWithObjects:@"银行卡号",@"预留号码 ",@"有效期",@"安全码",@"账单日",@"还款日", nil];
    for (int i = 0; i < data.count; i++) {
        HCConfirmPayModel *model = [HCConfirmPayModel new];
        model.name = data[i];
        
        model.placeholder = [NSString stringWithFormat:@"请选择%@",data[i]];
        
        if ([data[i] isEqualToString:@"验证码"]) {
            model.content = @"获取验证码";
        }
        
        
        [self.dataArr addObject:model];
    }
    
    
    
    
    [self.view addSubview:self.top_imageView];
    [self.top_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 46));
        make.top.left.offset(0);
    }];
    [self.view addSubview:self.top_lab];
    [self.top_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-40, 20));
        make.center.equalTo(self.top_imageView);
    }];
    
    
    [self.view addSubview:self.content_view];
    [self.content_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.top_imageView.mas_bottom).offset(15);
        make.height.offset(data.count * 50);
    }];
    
    self.content_view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.content_view.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
    self.content_view.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
    self.content_view.layer.shadowRadius = 3;// 阴影半径，默认3
    self.content_view.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    self.content_view.layer.cornerRadius = 10;
    
    self.tableView.layer.cornerRadius = 10;
    [self.content_view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
    
    
    [self.view addSubview:self.tishi_lab];
    [self.tishi_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-40, 46));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.content_view.mas_bottom).offset(8);
    }];
    
    [self.view addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 46));
        make.left.offset(15);
        make.top.equalTo(self.tishi_lab.mas_bottom).offset(44);
    }];
    
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

- (UIImageView *)top_imageView{
    if (!_top_imageView) {
        _top_imageView = [UIImageView getUIImageView:@"icon_jbbg"];
    }
    return _top_imageView;
}

-(UILabel *)top_lab{
    if(!_top_lab){
        _top_lab = [UILabel new];
        _top_lab.text = @"修改信用卡基本信息";
        _top_lab.textAlignment = NSTextAlignmentLeft;
        [UILabel getToChangeTheLabel:_top_lab TextColor:[UIColor blackColor] TextFont:[UIFont getUIFontSize:12 IsBold:NO]];
    }
    return _top_lab;
}

- (UIView *)content_view{
    if (!_content_view) {
        _content_view = [UIView new];
    }
    return _content_view;
}
- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton new];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"KD_BindCardBtn"] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"确定修改" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_finishBtn bk_whenTapped:^{
            [self getPayAction];
        }];
    }
    return _finishBtn;
}

-(UILabel *)tishi_lab{
    if(!_tishi_lab){
        _tishi_lab = [UILabel new];
        _tishi_lab.text = @"注:请确保您的账单日和还款日设置正确,否则设置还款计划时将会出现没有日期选择的情况 ";
        _tishi_lab.numberOfLines = 2;
        [UILabel getToChangeTheLabel:_tishi_lab TextColor:[UIColor colorWithHexString:@"#999999"] TextFont:[UIFont getUIFontSize:12 IsBold:NO]];

        _tishi_lab.attributedText = [UILabel setupAttributeString:_tishi_lab.text rangeText:@"注:" textColor:[UIColor colorWithHexString:@"#FF9426"] textFont:[UIFont getUIFontSize:15 IsBold:YES]];
        
        
    }
    return _tishi_lab;
}

@end
