//
//  HCMallSearchController.m
//  HC
//
//  Created by tuibao on 2021/12/14.
//

#import "HCMallSearchController.h"
#import "SearchTipsTableViewCell.h"
#import "HCMallGoodsCell.h"
@interface HCMallSearchController ()<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UIImageView *top_imageView;
@property (strong, nonatomic) UIView *navigation_View;
///搜索框
@property (nonatomic , strong) UITextField *textField;

@property (nonatomic , strong) UITableView *tableView;
///搜索提示数据源
@property (nonatomic , strong) NSMutableArray *searchTipsArr;

@property (nonatomic , strong) UICollectionView *collectionview;

@property (nonatomic , strong) NSMutableArray *dataHotArr;
///页码
@property (nonatomic , assign) int page;
@end

@implementation HCMallSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchTipsArr = [NSMutableArray arrayWithObjects:@"圣诞节礼物",@"苹果",@"玩偶",@"礼物",@"年货",@"坚果",@"项链", nil];
    
    self.page = 1;
    [self LoadUI];
    
    [self.textField becomeFirstResponder];
    
}

#pragma 搜索
- (void)loadData{
    if (self.textField.text.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(self.page) forKey:@"page"];
        [params setObject:@"14" forKey:@"page_size"];
        [params setObject:self.textField.text forKey:@"q"];
        @weakify(self);
        [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/shop/api/getGood/search" Params:params success:^(id  _Nonnull responseObject) {
            if ([responseObject[@"status"] intValue] == 200) {
                NSArray *array = responseObject[@"content"];
                if (weak_self.page == 1) {
                    weak_self.dataHotArr = [NSMutableArray arrayWithArray:array];
                    [self.collectionview.mj_footer endRefreshing];
                }else {
                    //没有更多数据
                    if (![array count]) {
                        [self.collectionview.mj_footer endRefreshingWithNoMoreData];
                    }
                    [weak_self.dataHotArr addObjectsFromArray:array];
                }
                [self.collectionview reloadData];
            }
        } failure:^(NSString * _Nonnull error) {

        }];
    }
}

#pragma textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self loadData];
    [textField resignFirstResponder];
    return YES;
}
- (void)LoadUI{
    
    
    
    [self.view addSubview:self.top_imageView];
    [self.top_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, kTopHeight));
        make.top.right.left.offset(0);
    }];
    
    [self.view addSubview:self.navigation_View];
    [self.navigation_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44));
        make.top.equalTo(self.top_imageView.mas_top).offset(kStatusBarHeight);
        make.left.equalTo(self.view);
    }];
    CGFloat navHeight = 5;
    CGFloat leftViewHeight = 30;
    if(kStatusBarHeight > 20){
        navHeight = 0;
        leftViewHeight = 34;
    }
    UIView *leftView = [UIView new];
    leftView.ylCornerRadius = leftViewHeight / 2;
    leftView.backgroundColor = [UIColor whiteColor];
    [self.navigation_View addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 36 - 20 - 12, leftViewHeight));
        make.top.offset(navHeight);
        make.left.offset(12);
    }];
    
    UIImageView *leftImage = [UIImageView getUIImageView:@"mall_search"];
    [leftView addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView);
        make.left.offset(10);
    }];
    
    self.textField = [UITextField new];
    self.textField.font = [UIFont getUIFontSize:16 IsBold:NO];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"大家都在搜：鞋子" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:self.textField.font}];
    self.textField.attributedPlaceholder = attrString;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.delegate = self;
    [leftView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView);
        make.left.equalTo(leftImage.mas_right).offset(10);
        make.right.offset(-10);
    }];
    
    UILabel *cancel = [UILabel getUILabelText:@"取消" TextColor:[UIColor whiteColor] TextFont:[UIFont getUIFontSize:16 IsBold:YES] TextNumberOfLines:0];
    cancel.textAlignment = NSTextAlignmentCenter;
    cancel.userInteractionEnabled = YES;
    [cancel bk_whenTapped:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigation_View addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView);
        make.right.offset(-12);
    }];
    
    
    //添加列表
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigation_View.mas_bottom).offset(0);
        make.bottom.offset(-KBottomHeight);
        make.left.right.equalTo(self.view);
    }];
    
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *Identifier = @"SearchTipsTableViewCell";
        SearchTipsTableViewCell *cell = [[SearchTipsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setDataArr:self.searchTipsArr];
        
        cell.block = ^(NSString * _Nonnull strName) {
            [self.textField resignFirstResponder];
            ///赋值并调用搜索方法
            self.textField.text = strName;
            [self loadData];
        };
        return cell;
    }
    else{
       
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.contentView addSubview:self.collectionview];
        [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(DEVICE_WIDTH);
            make.height.offset(10 * 220 + 55);
            make.top.offset(0);
            make.left.offset(0);
            make.bottom.offset(0);
        }];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 36;
    }
    return 52;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [UIView new];
    UILabel *title = [UILabel getUILabelText:@"搜索推荐" TextColor:[UIColor blackColor] TextFont:[UIFont getUIFontSize:18 IsBold:YES] TextNumberOfLines:0];
    [headerView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.offset(12);
        if (section == 0) {
            make.bottom.offset(0);
        }else{
            make.centerY.equalTo(headerView);
        }
    }];
    if (section == 0) {
        title.text = @"热门搜索";
    }
    return headerView;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.tableView) {
    CGFloat sectionHeaderHeight = 52;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
     }
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataHotArr.count;
}
//设置方块的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cell";
    HCMallGoodsCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    
    NSDictionary *data = self.dataHotArr[indexPath.row];
    
    [cell.top_image sd_setImageWithURL:data[@"pict_url"] placeholderImage:[UIImage imageNamed:@"mall_Placeholder_image"]];
    
    cell.title_lab.text = data[@"title"];
    
    //金额
    NSString *priceStr = [NSString stringWithFormat:@"¥%@",data[@"size"]];
    //销量
    NSString *salesStr = [NSString stringWithFormat:@"%@",data[@"volume"]];
    
    cell.content_lab.attributedText =  [UILabel setupAttributeString:[NSString stringWithFormat:@"%@ %@人付款",priceStr,salesStr] rangeText:priceStr textColor:[UIColor colorWithHexString:@"#FF8100"] textFont:[UIFont getUIFontSize:18 IsBold:NO]];
    
   
    return cell;
}


#pragma mark - UICollectionViewDelegate
//cell被选中会调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = self.dataHotArr[indexPath.row];
    
    HCGoodsDetailController *VC = [HCGoodsDetailController new];
    
    VC.tao_id = data[@"tao_id"];
    
    [self.xp_rootNavigationController pushViewController:VC animated:YES];
}


#pragma 懒加载
- (UICollectionView *)collectionview{
    if (!_collectionview) {
        
        CGFloat W = (DEVICE_WIDTH - 15) / 2;
        
        // 1.创建流水布局
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.itemSize = CGSizeMake(W,220);
        
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionview.backgroundColor = [UIColor whiteColor];
        _collectionview.showsVerticalScrollIndicator = NO;
        //注册Cell
        [self.collectionview registerNib:[UINib nibWithNibName:@"HCMallGoodsCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        _collectionview.scrollEnabled = NO;
        
        @weakify(self);
        _collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            weak_self.page = 1;
            [weak_self loadData];
            [weak_self.collectionview.mj_header endRefreshing];
           }];
        _collectionview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weak_self.page ++;
            [weak_self loadData];
            [weak_self.collectionview.mj_footer endRefreshing];
        }];
    }
    return _collectionview;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
- (UIImageView *)top_imageView{
    if (!_top_imageView) {
        _top_imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HC_TOP_bg"]];
    }
    return _top_imageView;
}
- (UIView *)navigation_View{
    if (!_navigation_View) {
        _navigation_View = [UIView new];
    }
    return _navigation_View;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

@end
