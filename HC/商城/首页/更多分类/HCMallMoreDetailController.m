//
//  HCMallMoreDetailController.m
//  HC
//
//  Created by tuibao on 2021/12/17.
//

#import "HCMallMoreDetailController.h"

@interface HCMallMoreDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) UICollectionView *collectionview;

@property (nonatomic , strong) NSMutableArray *dataHotArr;
///页码
@property (nonatomic , assign) int page;

@end

@implementation HCMallMoreDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    [self LoadUI];
    [self loadData];
}

#pragma 搜索
- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.page) forKey:@"page"];
    [params setObject:@"14" forKey:@"page_size"];
    [params setObject:self.navigationItem.title forKey:@"q"];
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
- (void)LoadUI{
    [self.view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.top.offset(0);
        make.left.offset(0);
        make.bottom.offset(-KBottomHeight);
    }];
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
