//
//  HCReturnsDetailedController.m
//  HC
//
//  Created by tuibao on 2021/11/18.
//

#import "HCReturnsDetailedController.h"
#import "HCReturnsDetailedCell.h"
#import "HCInvestmentIncomeController.h"
#import "HCSwipeFenRunController.h"
#import "HCReimbursementFenRunController.h"
#import "HCManagementFenRunViewController.h"
#import "HCUsedCashbackController.h"
#import "HCOtherIncomeController.h"
@interface HCReturnsDetailedController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) UIButton *type_btn;

@property (nonatomic , strong) UICollectionView *collectionview;

@property (nonatomic , strong) NSArray *TitleArr;

@end

@implementation HCReturnsDetailedController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"收益明细"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self LoadUI];
}
#pragma mark - 创建UI
- (void)LoadUI{

    
    self.TitleArr = [NSArray arrayWithObjects:
                     @{@"name":@"招商收益",@"image":@"icon_ReturnsDetailed_zhaoshang"},
                     @{@"name":@"刷卡分润",@"image":@"icon_ReturnsDetailed_shuaka"},
                     @{@"name":@"还款分润",@"image":@"icon_ReturnsDetailed_huankuan"},
                     @{@"name":@"空卡分润",@"image":@"icon_ReturnsDetailed_kongka"},
                     @{@"name":@"中介分润",@"image":@"icon_ReturnsDetailed_zhongjie"},
                     @{@"name":@"管理分润",@"image":@"icon_ReturnsDetailed_guanli"},
                     @{@"name":@"自用返现",@"image":@"icon_ReturnsDetailed_ziyong"},
                     @{@"name":@"其他收入",@"image":@"icon_ReturnsDetailed_qita"},nil];
    
    [self.view addSubview:self.type_btn];
    [self.type_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(30);
        make.left.equalTo(self.view.mas_left).offset(30);
    }];
    
    [self.view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.top.equalTo(self.type_btn.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-KBottomHeight);
    }];

    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}
//设置方块的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"HCReturnsDetailed";
    HCReturnsDetailedCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    cell.name.text = self.TitleArr[indexPath.row][@"name"];
    cell.image.image = [UIImage imageNamed:self.TitleArr[indexPath.row][@"image"]];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
//cell被选中会调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
//        [XHToast showBottomWithText:@"暂未开放"];
        [self.xp_rootNavigationController pushViewController:[HCInvestmentIncomeController new] animated:YES];
    }
    else if (indexPath.row == 1){
        [self.xp_rootNavigationController pushViewController:[HCSwipeFenRunController new] animated:YES];
    }
    else if (indexPath.row == 2){
        [self.xp_rootNavigationController pushViewController:[HCReimbursementFenRunController new] animated:YES];
    }
    else if (indexPath.row == 3){
        [XHToast showBottomWithText:@"暂未开放"];
    }
    else if (indexPath.row == 4){
        [XHToast showBottomWithText:@"暂未开放"];
    }
    else if (indexPath.row == 5){
        [self.xp_rootNavigationController pushViewController:[HCManagementFenRunViewController new] animated:YES];
    }
    else if (indexPath.row == 6){
        [self.xp_rootNavigationController pushViewController:[HCUsedCashbackController new] animated:YES];
    }
    else if (indexPath.row == 7){
        [self.xp_rootNavigationController pushViewController:[HCOtherIncomeController new] animated:YES];
    }

}

#pragma mark - 懒加载
- (UICollectionView *)collectionview{
    if (!_collectionview) {
        
        CGFloat W = (DEVICE_WIDTH - 60) / 4;
        
        // 1.创建流水布局
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 12;
        layout.minimumLineSpacing = 12;
        layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
        layout.itemSize = CGSizeMake(W,80);
        
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionview.backgroundColor = [UIColor whiteColor];
        _collectionview.showsVerticalScrollIndicator = NO;
        //注册Cell
        [self.collectionview registerNib:[UINib nibWithNibName:@"HCReturnsDetailedCell" bundle:nil] forCellWithReuseIdentifier:@"HCReturnsDetailed"];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        
        
    }
    return _collectionview;
}
- (UIButton *)type_btn{
    if (!_type_btn) {
        _type_btn = [[UIButton alloc]init];
        [_type_btn setTitle:@"收益类型" forState:UIControlStateNormal];
        [_type_btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _type_btn.titleLabel.font = [UIFont getUIFontSize:18 IsBold:YES];
        [_type_btn setImage:[UIImage imageNamed:@"icon_ReturnsDetailed_type"] forState:UIControlStateNormal];
        [_type_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        
    }
    return _type_btn;
}


@end
