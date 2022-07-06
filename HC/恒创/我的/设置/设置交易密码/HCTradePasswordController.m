//
//  HCTradePasswordController.m
//  HC
//
//  Created by tuibao on 2021/11/18.
//

#import "HCTradePasswordController.h"
#import "HCResetPasswordCell.h"
@interface HCTradePasswordController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) UIImageView *top_imageView;
@property (nonatomic , strong) UILabel *top_lab;
@property (nonatomic , strong) UIView *content_view;
@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UIButton *finishBtn;

@property (nonatomic , strong) NSMutableArray *dataArr;
@property (nonatomic , strong) NSDictionary *UserData;
@property (nonatomic , strong) UIButton *codeBtn;
@end

@implementation HCTradePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"设置交易密码"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = [NSMutableArray array];
    [self LoadUI];
}

#pragma 确认
- (void)getDeterMineAction{
    HCConfirmPayModel *model1 = self.dataArr[1];
    if (model1.content.length==0) {
        [XHToast showBottomWithText:@"请输入新密码"];
        return;
    }
    HCConfirmPayModel *model2 = self.dataArr[2];
    if (model2.content.length==0) {
        [XHToast showBottomWithText:@"请确认密码"];
        return;
    }
    NSLog(@"%@ == %@",model1.content,model2.content);
    if (![model2.content isEqualToString:model1.content]) {
        [XHToast showBottomWithText:@"两次密码输入不一致"];
        return;
    }
    HCConfirmPayModel *model3 = self.dataArr[3];
    if (model3.content.length==0) {
        [XHToast showBottomWithText:@"请输入验证码"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:brandId forKey:@"brandId"];//品牌id
    [dic setValue:self.UserData[@"username"] forKey:@"username"];//手机号
    [dic setValue:[NSString MD5ForUpper32Bate:model1.content] forKey:@"password"];//密码
    [dic setValue:model3.content forKey:@"smsCode"];//短信码
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/update/pwd" Params:dic success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [self.xp_rootNavigationController popViewControllerAnimated:YES];
            [XHToast showBottomWithText:@"密码修改成功"];
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
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"HCResetPasswordCell";
    HCResetPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCResetPasswordCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row == 0) {
        cell.content_textfield.userInteractionEnabled = NO;
    }else{
        cell.content_textfield.userInteractionEnabled = YES;
    }
    if(indexPath.row == 1 || indexPath.row == 2){
        cell.content_textfield.secureTextEntry = YES;
    }else{
        cell.content_textfield.secureTextEntry = NO;
    }
    if (indexPath.row == 3) {
        [cell.code_btn setHidden:NO];
        self.codeBtn = cell.code_btn;
        [self.codeBtn bk_whenTapped:^{
            [self smsCode];
        }];
    }else{
        [cell.code_btn setHidden:YES];
    }
    HCConfirmPayModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    cell.name_lab.text = model.name;
    cell.content_textfield.placeholder = model.placeholder;
    cell.content_textfield.text = model.content;
    
    return cell;
}

#pragma 获取验证码
- (void)smsCode{
    
    NSString *phone = self.UserData[@"username"];
    if (phone.length != 11) {
        [XHToast showBottomWithText:@"请输入正确的手机号"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phone forKey:@"phone"];
    [params setValue:@"0" forKey:@"type"];
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/notice/pass/sms/send" Params:params success:^(id  _Nonnull responseObject) {
        if([responseObject[@"code"] intValue] == 0){
            //已注册开始请求验证码
            [weakSelf changeSendBtnText];
            [XHToast showBottomWithText:responseObject[@"message"] duration:2.0];
        }else{
            [XHToast showBottomWithText:@"请求失败！"];
        }
        

    } failure:^(NSString * _Nonnull error) {}];
}
//------ 验证码发送按钮动态改变文字 ------//
- (void)changeSendBtnText {
    
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
                
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds", second] forState:UIControlStateNormal];
                [self.codeBtn setUserInteractionEnabled:NO];
                second--;
            }else {
                dispatch_source_cancel(timer);
                [self.codeBtn setTitle:@"重新发送" forState:(UIControlStateNormal)];
                [self.codeBtn setUserInteractionEnabled:YES];
            }
            
        });
    });
    // 启动源
    dispatch_resume(timer);
}

- (void)LoadUI{
    
    NSArray *data = [NSMutableArray arrayWithObjects:@"手机号",@"新密码",@"确认密码",@"验证码", nil];
    for (int i = 0; i < data.count; i++) {
        HCConfirmPayModel *model = [HCConfirmPayModel new];
        model.name = data[i];
        model.placeholder = [NSString stringWithFormat:@"请输入%@",data[i]];
        
        if([data[i] isEqualToString:@"确认密码"]){
            model.placeholder = @"请再次输入密码";
        }else if([data[i] isEqualToString:@"手机号"]){
            //得到个人信息，
            self.UserData = [NSDictionary dictionaryWithDictionary:[self loadUserData]];
            model.content = self.UserData[@"username"];
            
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
    
    

    [self.view addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 46));
        make.left.offset(15);
        make.top.equalTo(self.content_view.mas_bottom).offset(44);
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
        _top_lab.text = @"为确保您的资金安全，请验证身份设置交易密码";
        _top_lab.textAlignment = NSTextAlignmentLeft;
        [UILabel getToChangeTheLabel:_top_lab TextColor:[UIColor blackColor] TextFont:[UIFont getUIFontSize:12 IsBold:YES]];
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
        [_finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_finishBtn bk_whenTapped:^{
            [self getDeterMineAction];
        }];
    }
    return _finishBtn;
}

@end
