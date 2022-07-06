//
//  HCAddModificationController.m
//  HC
//
//  Created by tuibao on 2021/11/25.
//

#import "HCAddModificationController.h"
#import "HCAddModificationCell.h"
@interface HCAddModificationController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UIButton *finishBtn;

@property (nonatomic , strong) UITextField *name_textfield;
@property (nonatomic , strong) UITextField *textfield;

@end

@implementation HCAddModificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.typeStr isEqualToString:@"添加"]) {
        self.navigationItem.title = @"添加支付宝";
    }else{
        self.navigationItem.title = @"修改支付宝信息";
    }
    self.view.backgroundColor = [UIColor whiteColor];

    [self LoadUI];
}


#pragma 添加支付宝
- (void)getDeterMineAction{

    if (self.textfield.text.length == 0) {
        [XHToast showBottomWithText:@"请输入支付宝账号" duration:2.0];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.name_textfield.text forKey:@"fullname"];
    [params setValue:self.textfield.text forKey:@"payId"];
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/alipay/add" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            if (self.block) {
                self.block();
            }
            [XHToast showBottomWithText:responseObject[@"message"]];
            [self.xp_rootNavigationController popViewControllerAnimated:YES];
            
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}
#pragma 修改支付宝
- (void)getModifyTheAction{

    if (self.textfield.text.length == 0) {
        [XHToast showBottomWithText:@"请输入修改的支付宝账号" duration:2.0];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.textfield.text forKey:@"newAccount"];
    [params setValue:self.zhanghao forKey:@"oldAccount"];
    
    [self NetWorkingPostWithAddressURL:self hiddenHUD:NO url:@"/api/user/alipay/change" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            if (self.block) {
                self.block();
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
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    static NSString *Identifier = @"HCAddModificationCell";
    HCAddModificationCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCAddModificationCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    if (indexPath.row == 0) {
        cell.content_textfield.userInteractionEnabled = NO;
        // 得到个人信息，
        NSDictionary *UserData = [self loadUserData];
        cell.name_lab.text = @"姓名";
        cell.content_textfield.text = [NSString stringWithFormat:@"%@",UserData[@"fullname"]];
        self.name_textfield = cell.content_textfield;
    }else{
        cell.name_lab.text = @"支付宝账号";
        cell.content_textfield.placeholder = @"请输入支付宝账号";
        self.textfield = cell.content_textfield;

    }
    
    return cell;
}



- (void)LoadUI{
    
 
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(100);
        make.left.top.right.offset(0);
    }];
    

    [self.view addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 46));
        make.left.offset(15);
        make.top.equalTo(self.tableView.mas_bottom).offset(44);
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

- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton new];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"KD_BindCardBtn"] forState:UIControlStateNormal];
        [_finishBtn setTitle:[NSString stringWithFormat:@"确定%@",self.typeStr] forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont getUIFontSize:18 IsBold:YES];
        [_finishBtn bk_whenTapped:^{
            if ([self.typeStr isEqualToString:@"添加"]) {
                [self getDeterMineAction];
            }else{
                [self getModifyTheAction];
            }
            
        }];
    }
    return _finishBtn;
}


@end
