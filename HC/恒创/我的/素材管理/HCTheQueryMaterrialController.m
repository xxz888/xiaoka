//
//  HCTheQueryMaterrialController.m
//  HC
//
//  Created by tuibao on 2022/1/7.
//

#import "HCTheQueryMaterrialController.h"
#import "HCTheQueryMaterrialCell.h"
@interface HCTheQueryMaterrialController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

//提示lab
@property (nonatomic , strong) UILabel *prompt_lab;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , assign) NSInteger page;

@property (nonatomic , strong) NSMutableArray *dataArray;

@end

@implementation HCTheQueryMaterrialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"素材管理";
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    [self LoadUI];
    [self TableViewRefresh];
    
    
}
- (void)TableViewRefresh{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"5" forKey:@"pageSize"];
    [dic setValue:[NSString stringWithFormat:@"%li",(long)self.page] forKey:@"currentPage"];
    [dic setValue:brandId forKey:@"brandId"];
    
    
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/material/get/list" Params:dic success:^(id  _Nonnull responseObject) {
       
        if ([responseObject[@"code"] integerValue] == 0) {
            NSArray * array = responseObject[@"data"];
            if (self.page == 1) {
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
- (void)LoadUI{
    [self.view addSubview:self.prompt_lab];
    [self.prompt_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH-20);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.left.offset(10);
    }];
    
    [self.view addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-20, 0.5));
        make.left.offset(10);
        make.top.equalTo(self.prompt_lab.mas_bottom).offset(20);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.left.offset(0);
        make.top.equalTo(self.line.mas_bottom).offset(10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-KBottomHeight);
    }];
    
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"HCTheQueryMaterrialCell";
    HCTheQueryMaterrialCell *cell = [[HCTheQueryMaterrialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.data = self.dataArray[indexPath.row];
    cell.tableView = self.tableView;
    cell.viewController_cell = self;
    return cell;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"tableView_Placeholder"];
}
#pragma 无数据点击刷新
-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self TableViewRefresh];
}
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
            self.page = 1;
            [weak_self TableViewRefresh];
            [weak_self.tableView.mj_header endRefreshing];
        }];
        //上拉加载更多
        _tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.page ++;
            [weak_self TableViewRefresh];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
        
    }
    return _tableView;
}
- (UILabel *)prompt_lab{
    if (!_prompt_lab) {
        _prompt_lab = [UILabel getUILabelText:@"图片中的二维码都是您本人的专属二维码，保存图片，复制文字即可分享至朋友圈，坚持每天分享朋友圈素材，才有利于快速吸引潜在用户。" TextColor:[UIColor colorWithHexString:@"#999999"] TextFont:[UIFont getUIFontSize:12 IsBold:YES] TextNumberOfLines:5];
        
        [UILabel changeSpaceForLabel:_prompt_lab withLineSpace:3 WordSpace:1];
        
    }
    return _prompt_lab;
}

- (UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    }
    return _line;
}


@end
