//
//  HCMallNineController.m
//  HC
//
//  Created by tuibao on 2021/12/13.
//

#import "HCMallNineController.h"
#import "HCMallNineCell.h"
@interface HCMallNineController ()<RPTaggedNavViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) RPTaggedNavView * taggedNavView;//分段选择

@property (nonatomic , strong) UICollectionView *collectionview;

@property (nonatomic , strong) NSMutableArray *dataArr;
///页码
@property (nonatomic , assign) int page;
///类目ID
@property (nonatomic , assign) int cid;

@property (nonatomic , assign) int tagged;

@end

@implementation HCMallNineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F0F2F5"];
    self.navigationItem.title = @"9.9包邮";
    self.page = 1;
    self.cid = arc4random() % 14 + 1;
    self.tagged = 0;
    [self LoadUI];
    [self loadData];
}

#pragma 实时人气榜
- (void)loadData{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.page) forKey:@"page"];
    [params setObject:@"14" forKey:@"page_size"];
    [params setObject:@(self.cid) forKey:@"cid"];
    @weakify(self);
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/shop/api/getGood/99" Params:params success:^(id  _Nonnull responseObject) {
        
        if ([responseObject[@"status"] intValue] == 200) {
            NSArray *array = responseObject[@"content"];
            if (weak_self.page == 1) {
                weak_self.dataArr = [NSMutableArray arrayWithArray:array];
                [self.collectionview.mj_footer endRefreshing];
            }else {
                //没有更多数据
                if (![array count]) {
                    [self.collectionview.mj_footer endRefreshingWithNoMoreData];
                }
                [weak_self.dataArr addObjectsFromArray:array];
            }
            if (self.tagged > 0) {
                [self haveSelectedIndex:self.tagged];
            }else{
                [self.collectionview reloadData];
            }
        }
    } failure:^(NSString * _Nonnull error) {

    }];
    
}


- (void)LoadUI{

    //添加分段选择
    self.taggedNavView = [[RPTaggedNavView alloc]initWithFrame:CGRectMake(0, 1, DEVICE_WIDTH, 44)];
    self.taggedNavView.delegate = self;
    self.taggedNavView.dataArr = [NSArray arrayWithObjects:@"综合",@"销量",@"优惠",@"价格", nil];
    self.taggedNavView.tagTextColor_normal = [UIColor colorWithHexString:@"999999"];
    self.taggedNavView.tagTextColor_selected = [UIColor colorWithHexString:@"#000000"];
    self.taggedNavView.tagTextFont_normal = 14;
    self.taggedNavView.tagTextFont_selected = 16;
    self.taggedNavView.sliderColor = [UIColor colorWithHexString:@"#000000"];
    self.taggedNavView.sliderW = 30;
    self.taggedNavView.sliderH = 2;
    [self.view addSubview:self.taggedNavView];
    
    [self.view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.top.equalTo(self.taggedNavView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.bottom.offset(-KBottomHeight);
    }];
   
}
#pragma mark -- taggedNavViewDelegate
- (void)haveSelectedIndex:(NSInteger)index{
    if (index == 0) {
        self.dataArr = [NSMutableArray arrayWithArray:[NSArray getRandomArrFrome:self.dataArr]];
    }
    else if (index == 1){
        [self setBubbleSortArray:self.dataArr FieldString:@"volume"];
    }
    else if (index == 2){
        [self setBubbleSortArray:self.dataArr FieldString:@"coupon_info_money"];
    }
    else if (index == 3){
        [self setBubbleSortArray:self.dataArr FieldString:@"size"];
    }

    self.tagged = (int)index;
    [self.collectionview reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
//设置方块的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cell";
    HCMallNineCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    NSDictionary *data = self.dataArr[indexPath.row];
    
    [cell.top_image sd_setImageWithURL:data[@"pict_url"] placeholderImage:[UIImage imageNamed:@"mall_Placeholder_image"]];
    
    cell.title_lab.text = data[@"title"];
    
    cell.baoyou_lab.text = [NSString stringWithFormat:@"销量:%@+",data[@"volume"]];
    
    cell.xiaoliang_lab.text = [NSString stringWithFormat:@"%@",data[@"shop_dsr"]];
    
    cell.yuanjia_lab.text = [NSString stringWithFormat:@"￥%@",data[@"size"]];
    
    cell.vip_right_lab.text = [NSString stringWithFormat:@"￥%@",data[@"quanhou_jiage"]];
   
    return cell;
}


#pragma mark - UICollectionViewDelegate
//cell被选中会调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *data = self.dataArr[indexPath.row];
    
    HCGoodsDetailController *VC = [HCGoodsDetailController new];
    
    VC.tao_id = data[@"tao_id"];
    
    [self.xp_rootNavigationController pushViewController:VC animated:YES];
}


#pragma 懒加载
- (UICollectionView *)collectionview{
    if (!_collectionview) {
        
        CGFloat W = (DEVICE_WIDTH - 30) / 2;
        
        // 1.创建流水布局
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.itemSize = CGSizeMake(W,270);
        
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionview.backgroundColor = [UIColor whiteColor];
        _collectionview.showsVerticalScrollIndicator = NO;
        //注册Cell
        [self.collectionview registerNib:[UINib nibWithNibName:@"HCMallNineCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
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


@end
