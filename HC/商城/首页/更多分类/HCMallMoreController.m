//
//  HCMallMoreController.m
//  HC
//
//  Created by tuibao on 2021/12/13.
//

#import "HCMallMoreController.h"
#import "HCMallMoreCell.h"
#import "HCMallClassificationController.h"

#import "HCMallMoreDetailController.h"
@interface HCMallMoreController ()<UITableViewDelegate, UITableViewDataSource , UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UICollectionView *collectionview;
//分类数组
@property (nonatomic , strong) NSArray *TitleArr;

@property (nonatomic , strong) UILabel *more_lab;
///页码
@property (nonatomic , assign) int page;

@property (nonatomic , strong) NSArray *dataArr;
///类目ID
@property (nonatomic , assign) int cid;

@end

@implementation HCMallMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"更多分类";
    self.page = 1;
    self.cid = 1;
    [self LoadUI];
}

- (void)LoadUI{

    self.TitleArr = [NSArray arrayWithObjects:@"女装",@"母婴",@"美妆",@"居家日用",@"鞋品",@"美食",@"文娱车品",@"数码家电",@"男装",@"内衣",@"箱包",@"配饰",@"户外运动",@"家装家纺", nil];
    
    NSArray *arr1 = [NSArray arrayWithObjects:
                     @{@"name":@"包臀裙",@"image":@"包臀裙"},
                     @{@"name":@"保暖内衣",@"image":@"保暖内衣"},
                     @{@"name":@"衬衣",@"image":@"衬衣"},
                     @{@"name":@"短裙",@"image":@"短裙"},
                     @{@"name":@"短袖",@"image":@"短袖"},
                     @{@"name":@"风衣",@"image":@"风衣"},
                     @{@"name":@"可爱连衣裙",@"image":@"可爱连衣裙"},
                     @{@"name":@"礼服",@"image":@"礼服"},
                     @{@"name":@"连衣裙",@"image":@"连衣裙"},
                     @{@"name":@"上衣",@"image":@"上衣"},
                     @{@"name":@"睡衣",@"image":@"睡衣"},
                     @{@"name":@"外套",@"image":@"外套"},
                     @{@"name":@"泳衣",@"image":@"泳衣"},nil];
    NSArray *arr2 = [NSArray arrayWithObjects:
                     @{@"name":@"儿童饭盒",@"image":@"儿童饭盒"},
                     @{@"name":@"儿童玩具",@"image":@"儿童玩具"},
                     @{@"name":@"儿童鞋",@"image":@"儿童鞋"},
                     @{@"name":@"儿童衣服",@"image":@"儿童衣服"},
                     @{@"name":@"尿不湿",@"image":@"尿不湿"},nil];
    NSArray *arr3 = [NSArray arrayWithObjects:
                     @{@"name":@"防晒霜",@"image":@"防晒霜"},
                     @{@"name":@"粉底液",@"image":@"粉底液"},
                     @{@"name":@"睫毛膏",@"image":@"睫毛膏"},
                     @{@"name":@"口红",@"image":@"口红"},
                     @{@"name":@"面膜",@"image":@"面膜"},
                     @{@"name":@"爽肤水",@"image":@"爽肤水"},
                     @{@"name":@"香水",@"image":@"香水"},
                     @{@"name":@"修护霜",@"image":@"修护霜"},nil];
    NSArray *arr4 = [NSArray arrayWithObjects:
                     @{@"name":@"护发素",@"image":@"护发素"},
                     @{@"name":@"毛巾",@"image":@"毛巾"},
                     @{@"name":@"沐浴露",@"image":@"沐浴露"},
                     @{@"name":@"拖把",@"image":@"拖把"},
                     @{@"name":@"洗发水",@"image":@"洗发水"},
                     @{@"name":@"洗衣液",@"image":@"洗衣液"},
                     @{@"name":@"香皂",@"image":@"香皂"},
                     @{@"name":@"牙膏",@"image":@"牙膏"},
                     @{@"name":@"纸巾",@"image":@"纸巾"},nil];
    NSArray *arr5 = [NSArray arrayWithObjects:
                     @{@"name":@"高跟鞋",@"image":@"高跟鞋"},
                     @{@"name":@"女士皮鞋",@"image":@"女士皮鞋"},
                     @{@"name":@"皮鞋",@"image":@"皮鞋"},
                     @{@"name":@"运动鞋",@"image":@"运动鞋"},
                     @{@"name":@"马丁靴",@"image":@"马丁靴"},nil];
    NSArray *arr6 = [NSArray arrayWithObjects:
                     @{@"name":@"饼干",@"image":@"饼干"},
                     @{@"name":@"瓜子",@"image":@"瓜子"},
                     @{@"name":@"坚果",@"image":@"坚果"},
                     @{@"name":@"泡面",@"image":@"泡面"},
                     @{@"name":@"薯片",@"image":@"薯片"},
                     @{@"name":@"糖果",@"image":@"糖果"},
                     @{@"name":@"饮品",@"image":@"饮品"},nil];
    NSArray *arr7 = [NSArray arrayWithObjects:
                     @{@"name":@"靠枕",@"image":@"靠枕"},
                     @{@"name":@"摩托车",@"image":@"摩托车"},
                     @{@"name":@"汽车",@"image":@"汽车"},
                     @{@"name":@"头盔",@"image":@"头盔"},
                     @{@"name":@"香薰",@"image":@"香薰"},
                     @{@"name":@"应急装备",@"image":@"应急装备"},nil];
    NSArray *arr8 = [NSArray arrayWithObjects:
                     @{@"name":@"电饭煲",@"image":@"电饭煲"},
                     @{@"name":@"手机",@"image":@"手机"},
                     @{@"name":@"数码相机",@"image":@"数码相机"},
                     @{@"name":@"台灯",@"image":@"台灯"},
                     @{@"name":@"榨汁机",@"image":@"榨汁机"},nil];
    NSArray *arr9 = [NSArray arrayWithObjects:
                     @{@"name":@"衬衣",@"image":@"衬衣"},
                     @{@"name":@"短袖",@"image":@"短袖"},
                     @{@"name":@"毛衣",@"image":@"毛衣"},
                     @{@"name":@"棉服",@"image":@"棉服"},
                     @{@"name":@"牛仔裤",@"image":@"牛仔裤"},
                     @{@"name":@"卫衣",@"image":@"卫衣"},nil];
    NSArray *arr10 = [NSArray arrayWithObjects:
                     @{@"name":@"保暖内衣",@"image":@"保暖内衣"},
                     @{@"name":@"内裤",@"image":@"内裤"},
                     @{@"name":@"内衣套装",@"image":@"内衣套装"},
                     @{@"name":@"睡衣",@"image":@"睡衣"},
                     @{@"name":@"无痕内衣",@"image":@"无痕内衣"},
                     @{@"name":@"运动内衣",@"image":@"运动内衣"},nil];
    NSArray *arr11 = [NSArray arrayWithObjects:
                      @{@"name":@"复工行李箱",@"image":@"复工行李箱"},
                      @{@"name":@"女士手提包",@"image":@"女士手提包"},
                      @{@"name":@"行李箱",@"image":@"行李箱"},
                      @{@"name":@"真皮女包",@"image":@"真皮女包"},nil];
    NSArray *arr12 = [NSArray arrayWithObjects:
                      @{@"name":@"耳坠",@"image":@"耳坠"},
                      @{@"name":@"帽子",@"image":@"帽子"},
                      @{@"name":@"手表",@"image":@"手表"},
                      @{@"name":@"手链",@"image":@"手链"},
                      @{@"name":@"胸针",@"image":@"胸针"},
                      @{@"name":@"眼镜",@"image":@"眼镜"},nil];
    NSArray *arr13 = [NSArray arrayWithObjects:
                      @{@"name":@"冲锋衣",@"image":@"冲锋衣"},
                      @{@"name":@"滑雪用具",@"image":@"滑雪用具"},
                      @{@"name":@"棉服",@"image":@"棉服"},
                      @{@"name":@"跑步机",@"image":@"跑步机"},
                      @{@"name":@"哑铃",@"image":@"哑铃"},
                      @{@"name":@"运动手表",@"image":@"运动手表"},
                      @{@"name":@"运动鞋",@"image":@"运动鞋"},nil];
    NSArray *arr14 = [NSArray arrayWithObjects:
                      @{@"name":@"被套",@"image":@"被套"},
                      @{@"name":@"地毯",@"image":@"地毯"},
                      @{@"name":@"电热毯",@"image":@"电热毯"},
                      @{@"name":@"马桶",@"image":@"马桶"},
                      @{@"name":@"四件套",@"image":@"四件套"},
                      @{@"name":@"枕头",@"image":@"枕头"},nil];
    
    self.dataArr = [NSArray arrayWithObjects:arr1,arr2,arr3,arr4,arr5,arr6,arr7,arr8,arr9,arr10,arr11,arr12,arr13,arr14,nil];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.left.offset(0);
        make.top.equalTo(self.view.mas_top);
        make.bottom.offset(-KBottomHeight);
    }];
    [self.tableView reloadData];
    
    [self.view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.tableView.mas_right);
        make.right.offset(0);
        make.bottom.offset(-KBottomHeight);
    }];
    
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.TitleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel *name_lab = [UILabel getUILabelText:self.TitleArr[indexPath.row] TextColor:[UIColor blackColor] TextFont:[UIFont getUIFontSize:14 IsBold:NO] TextNumberOfLines:0];
    name_lab.tag = indexPath.row + 100;
    name_lab.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    name_lab.textAlignment = NSTextAlignmentCenter;
    name_lab.userInteractionEnabled = YES;
    [cell.contentView addSubview:name_lab];
    [name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    if (indexPath.row == 0) {
        name_lab.backgroundColor = [UIColor whiteColor];
        self.more_lab = name_lab;
    }
    [name_lab bk_whenTapped:^{
        if (self.more_lab.tag != name_lab.tag) {
            self.more_lab.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
            name_lab.backgroundColor = [UIColor whiteColor];
            self.more_lab = name_lab;
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat offsetY = [self.collectionview layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].frame.origin.y;
                    
                    CGFloat contentInsetY = self.collectionview.contentInset.top;
                    CGFloat sectionInsetY = ((UICollectionViewFlowLayout *)self.collectionview.collectionViewLayout).sectionInset.top;
                    
                    [self.collectionview setContentOffset:CGPointMake(self.collectionview.contentOffset.x, offsetY - contentInsetY - sectionInsetY) animated:NO];
                });
            self.cid = (int)indexPath.row + 1;
            [self.collectionview reloadData];
        }
    }];
    return cell;
}


#pragma mark - UICollectionViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArr[self.cid - 1] count];
}
//设置方块的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cell";
    HCMallMoreCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    
    NSDictionary *data = self.dataArr[self.cid-1][indexPath.row];
    
    cell.top_image.image = [UIImage imageNamed:data[@"image"]];
    
    cell.title_lab.text = data[@"name"];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
//cell被选中会调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *data = self.dataArr[self.cid-1][indexPath.row];
    
    HCMallMoreDetailController * VC = [HCMallMoreDetailController new];
    VC.title = data[@"name"];
    [self.xp_rootNavigationController pushViewController:VC animated:YES];
    
}

#pragma 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.showsVerticalScrollIndicator = NO;
        
    }
    return _tableView;
}


- (UICollectionView *)collectionview{
    if (!_collectionview) {
        
        CGFloat W = (DEVICE_WIDTH - 100 - 20) / 3;
        
        // 1.创建流水布局
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.itemSize = CGSizeMake(W,100);
        
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionview.backgroundColor = [UIColor whiteColor];
        _collectionview.showsVerticalScrollIndicator = NO;
        //注册Cell
        [self.collectionview registerNib:[UINib nibWithNibName:@"HCMallMoreCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
       
    }
    return _collectionview;
}


@end
