//
//  HCGroundPointsController.m
//  HC
//
//  Created by tuibao on 2021/11/8.
//

#import "HCGroundPointsController.h"
#import "HCGroundPointsCell.h"
@interface HCGroundPointsController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *channelArr;

@end

@implementation HCGroundPointsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"银联通道-落地积分J";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.offset(-KBottomHeight);
    }];
    [self GetChannelData];
    
}
#pragma 获取通道银行限额
- (void)GetChannelData{
    
    @weakify(self);
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:[NSString stringWithFormat:@"/api/payment/quick/channel/bank/list/%@",self.channelID] Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        
        if ([responseObject[@"code"] intValue] == 0) {
            weak_self.channelArr = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            [weak_self.tableView reloadData];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.channelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"HCGroundPointsCell";
    HCGroundPointsCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCGroundPointsCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    NSDictionary *dic = self.channelArr[indexPath.row];
    
    cell.left_lab.text = [NSString stringWithFormat:@"%@",dic[@"bankName"]];
    cell.center_lab.text = [NSString stringWithFormat:@"%@-%@",dic[@"limitMin"],dic[@"limitMax"]];
    cell.right_lab.text = [NSString stringWithFormat:@"%@",dic[@"dayMax"]];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *views = [UIView new];
    UIImageView *image = [UIImageView getUIImageView:@"icon_jbbg"];
    [views addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
    UILabel *center_lab = [UILabel new];
    center_lab.text = @"单卡单笔";
    center_lab.textAlignment = NSTextAlignmentCenter;
    center_lab.textColor = [UIColor colorWithHexString:@"#333333"];
    center_lab.font = [UIFont getUIFontSize:15 IsBold:YES];
    [views addSubview:center_lab];
    [center_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(views);
    }];
    
    UILabel *left_lab = [UILabel new];
    left_lab.text = @"银行名称";
    left_lab.textAlignment = NSTextAlignmentLeft;
    left_lab.textColor = [UIColor colorWithHexString:@"#333333"];
    left_lab.font = [UIFont getUIFontSize:15 IsBold:YES];
    [views addSubview:left_lab];
    [left_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(views);
        make.left.offset(15);
    }];
    
    UILabel *right_lab = [UILabel new];
    right_lab.text = @"单卡当日";
    right_lab.textAlignment = NSTextAlignmentRight;
    right_lab.textColor = [UIColor colorWithHexString:@"#333333"];
    right_lab.font = [UIFont getUIFontSize:15 IsBold:YES];
    [views addSubview:right_lab];
    [right_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(views);
        make.right.offset(-15);
    }];
    
    return views;
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
        
    }
    return _tableView;
}
@end
