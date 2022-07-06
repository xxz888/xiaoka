//
//  HCConfirmPayController.m
//  HC
//
//  Created by tuibao on 2021/11/9.
//

#import "HCConfirmPayController.h"
#import "HCConfirmPayCell.h"

#import "HCConfirmPayModel.h"

@interface HCConfirmPayController ()<UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate>

@property (nonatomic , strong) UIImageView *top_imageView;
@property (nonatomic , strong) UILabel *top_lab;
@property (nonatomic , strong) UIView *content_view;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIButton *finishBtn;


@property (nonatomic , strong) NSMutableArray *dataArr;

@property (nonatomic , strong) UITextField *yzm_lab;

//订单号
@property (nonatomic , strong) NSString *orderCode;


//省/直辖市
@property (nonatomic , strong) NSString *provinceAddress;
//市
@property (nonatomic , strong) NSString *cityAddress;

@end

@implementation HCConfirmPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"支付确认";
    self.dataArr = [NSMutableArray array];
    self.orderCode = @"";
    self.provinceAddress = @"";
    self.cityAddress = @"";
    [self LoadUI];
    [self GetTheAddress];
}
#pragma 获取定位地址并进行比对
- (void)GetTheAddress{
    @weakify(self);
    [self addLocationManager:^(NSString * _Nonnull province, NSString * _Nonnull city) {
        weak_self.provinceAddress = province;
        weak_self.cityAddress = city;
        [weak_self getAddressThan:province City:city isThan:^(NSString * _Nonnull provinceCode, NSString * _Nonnull cityCode, BOOL isThan) {
            if (isThan) {
                if ([[NSArray arrayWithObjects:@"重庆",@"北京",@"天津",@"上海", nil] containsObject:province]) {
                    [weak_self.params setValue:provinceCode forKey:@"cityCode"];
                }else{
                    [weak_self.params setValue:cityCode forKey:@"cityCode"];
                }
                HCConfirmPayModel *model4 = weak_self.dataArr[4];
                model4.content = province;
                HCConfirmPayModel *model5 = weak_self.dataArr[5];
                model5.content = city;
                [weak_self.tableView reloadData];
            }
        }];
    }];
}
#pragma 调用刷卡接口 界面逻辑为 获取验证码
- (void)GetACreditCard{
    @weakify(self);
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/payment/fast/apply" Params:self.params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            weak_self.orderCode = responseObject[@"data"];
            
            [XHToast showBottomWithText:@"短信发送成功"];
            [self changeSendBtnText];
            if (![self.needCode isEqualToString:@"1"]) {
                [self TheOrderStatus];
            }
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
#pragma 确认刷卡接口
- (void)GetConfirmTheCharge{
    
    if ([self.needCity isEqualToString:@"1"]) {
        HCConfirmPayModel *model = [self GetToFindThe:@"市"];
        if (model.content.length == 0) {
            [XHToast showBottomWithText:@"省市不能为空！"];
            return;
        }
    }
    HCConfirmPayModel *models = [self GetToFindThe:@"验证码"];
    if (models.placeholder.length == 0) {
        [XHToast showBottomWithText:@"验证码不能为空！"];
        return;
    }
    
    NSMutableDictionary *paramsData = [NSMutableDictionary dictionary];
    [paramsData setValue:self.orderCode forKey:@"orderCode"];//订单号
    [paramsData setValue:self.params[@"channelId"] forKey:@"channelId"];//通道id
    [paramsData setValue:self.params[@"idCard"] forKey:@"idCard"];//身份证号
    [paramsData setValue:models.placeholder forKey:@"smsCode"];//短信验证码
    [paramsData setValue:self.params[@"bankCard"] forKey:@"bankCard"];//信用卡卡号
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/payment/fast/confirm" Params:paramsData success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 3) {
            [self TheOrderStatus];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
#pragma 查看订单状态
- (void)TheOrderStatus{
    @weakify(self);
    NSMutableDictionary *paramsData = [NSMutableDictionary dictionary];
    [paramsData setValue:self.params[@"channelId"] forKey:@"channelId"];//通道id
    [paramsData setValue:self.orderCode forKey:@"orderCode"];//订单号
    
    [paramsData setValue:self.params[@"idCard"] forKey:@"idCard"];//身份证号
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/payment/fast/query" Params:paramsData success:^(id  _Nonnull responseObject) {
        
        HCTradingTypeView *trading = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HCTradingTypeView class]) owner:nil options:nil] lastObject];
        trading.backgroundColor = [UIColor clearColor];
        if ([responseObject[@"code"] intValue] == 0) {
            trading.title_lab.text = @"交易成功";
        }else if ([responseObject[@"code"] intValue] == 1){
            trading.title_lab.text = @"交易失败";
        }else if ([responseObject[@"code"] intValue] == 3){
            trading.title_lab.text = @"处理中";
        }
        trading.number_lab.text = weak_self.params[@"amount"];

        //弹窗实例创建
        LSTPopView *popView = [LSTPopView initWithCustomView:trading
                                                      popStyle:LSTPopStyleSpringFromTop
                                                  dismissStyle:LSTDismissStyleSmoothToTop];
        LSTPopViewWK(popView)
        [trading.determine_btn bk_whenTapped:^{
            [wk_popView dismiss];
            [weak_self backToAppointedController:[HCOnlinePaymentViewController new]];
        }];
        [popView pop];
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}

#pragma 确认支付
- (void)getPayAction{
    
    //判断是否需要验证码
    if ([self.needCode isEqualToString:@"1"]) {
        [self GetConfirmTheCharge];
    }
    else{
        [self GetACreditCard];
    }
    
}
#pragma 查找数据
- (HCConfirmPayModel *)GetToFindThe:(NSString *)title{
    HCConfirmPayModel *model;
    for (int i = 0 ; i < self.dataArr.count; i++) {
        HCConfirmPayModel *models = self.dataArr[i];
        if ([models.name isEqualToString:title]) {
            model = models;
            break;
        }
    }
    return model;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"HCConfirmPayCell";
    HCConfirmPayCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCConfirmPayCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.model = self.dataArr[indexPath.row];

    [cell.content_textfield bk_whenTapped:^{
        
        if ([cell.title_lab.text isEqualToString:@"省份"]||[cell.title_lab.text isEqualToString:@"市"]) {
            ///自定义
            KisZDYPickerView *PickerView = [[KisZDYPickerView alloc]init];
            PickerView.provinceAddress = self.provinceAddress;
            PickerView.cityAddress = self.cityAddress;
            PickerView.channelId = [self.params[@"channelId"] stringValue];
            PickerView.Block = ^(NSDictionary *startDic, NSDictionary *endDic) {
                
                if ([startDic allKeys].count > 0) {
                    if ([[NSArray arrayWithObjects:@"重庆",@"北京",@"天津",@"上海", nil] containsObject:startDic[@"name"]]) {
                        [self.params setValue:startDic[@"id"] forKey:@"cityCode"];
                    }else{
                        [self.params setValue:endDic[@"id"] forKey:@"cityCode"];
                    }
                    HCConfirmPayModel *model4 = self.dataArr[4];
                    model4.content = startDic[@"name"];
                    HCConfirmPayModel *model5 = self.dataArr[5];
                    model5.content = endDic[@"name"];
                    [self.tableView reloadData];
                }
                
            };
            [PickerView show];
        }
        
        else if([cell.title_lab.text isEqualToString:@"验证码"]){
            self.yzm_lab = cell.content_textfield;
            if ([self.needCity isEqualToString:@"1"]) {
                if (![[self.params allKeys] containsObject:@"cityCode"]) {
                    [XHToast showBottomWithText:@"请选择城市"];
                    return;
                }
            }
            //调用验证码接口
            [self GetACreditCard];
        }
        
        
    }];
    
    return cell;
}
//------ 验证码发送按钮动态改变文字 ------//
- (void)changeSendBtnText{

    __block NSInteger second = 60;
    // 全局队列 默认优先级
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 定时器模式 事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // NSEC_PER_SEC是秒 *1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (second >= 0) {
                
                self.yzm_lab.text = [NSString stringWithFormat:@"%lds", second];
                
                second--;
                
                
            }else {
                
                dispatch_source_cancel(timer);
                self.yzm_lab.text = @"重新发送";
                
            }
            
        });
    });
    // 启动源
    dispatch_resume(timer);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}


- (void)LoadUI{
    
    NSMutableArray *data = [NSMutableArray arrayWithObjects:@"持卡人",@"卡号",@"有效期",@"安全码",@"省份",@"市",@"验证码", nil];
    
    if (![self.needCity isEqualToString:@"1"]) {
        data = [NSMutableArray arrayWithObjects:@"持卡人",@"卡号",@"有效期",@"安全码",@"验证码", nil];
    }
    if (![self.needCode isEqualToString:@"1"]) {
        data = [NSMutableArray arrayWithObjects:@"持卡人",@"卡号",@"有效期",@"安全码",@"省份",@"市", nil];
    }
    if (![self.needCode isEqualToString:@"1"] && ![self.needCity isEqualToString:@"1"]) {
        data = [NSMutableArray arrayWithObjects:@"持卡人",@"卡号",@"有效期",@"安全码", nil];
    }
    
    for (int i = 0; i < data.count; i++) {
        HCConfirmPayModel *model = [HCConfirmPayModel new];
        model.name = data[i];
        
        if ([data[i] isEqualToString:@"验证码"]) {
            model.content = @"获取验证码";
            model.placeholder = @"";
        }
        else if ([data[i] isEqualToString:@"持卡人"]){
            model.content = self.params[@"userName"];
        }
        else if ([data[i] isEqualToString:@"卡号"]){
            model.content = self.params[@"bankCard"];
        }
        else if ([data[i] isEqualToString:@"有效期"]){
            model.content = self.params[@"expiredTime"];
        }
        else if ([data[i] isEqualToString:@"安全码"]){
            model.content = self.params[@"securityCode"];
        }else if([data[i] isEqualToString:@"省份"] || [data[i] isEqualToString:@"市"]){
            model.placeholder = [NSString stringWithFormat:@"请选择%@",data[i]];
            
            
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
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 20));
        make.center.equalTo(self.top_imageView);
    }];
    
    
    [self.view addSubview:self.content_view];
    [self.content_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.top_imageView.mas_bottom).offset(15);
        make.height.offset(self.dataArr.count*50);
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
    
    [self.view addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 46));
        make.left.offset(15);
        make.top.equalTo(self.content_view.mas_bottom).offset(50);
    }];
    
}



- (NSMutableDictionary *)params{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
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
        _top_lab.text = @"信息加密处理，仅用于银行卡验证，请验证您本人的银行卡";
        _top_lab.textAlignment = NSTextAlignmentCenter;
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
        [_finishBtn setTitle:@"确定支付" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_finishBtn bk_whenTapped:^{
            [self getPayAction];
        }];
    }
    return _finishBtn;
}

@end
