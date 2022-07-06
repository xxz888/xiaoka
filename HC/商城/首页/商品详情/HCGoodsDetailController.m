//
//  HCGoodsDetailController.m
//  HC
//
//  Created by tuibao on 2021/12/14.
//

#import "HCGoodsDetailController.h"
#import "HCMallBuyNowView.h"
#import "HCMallOrderConfirmationController.h"
@interface HCGoodsDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(strong, nonatomic) UIScrollView *scrollView;

///商品图片
@property (strong , nonatomic) UIImageView *goods_image;
///商品信息view
@property (strong , nonatomic) UIView *goods_view;
///商品名称
@property (strong , nonatomic) UILabel *goods_name;
///商品简介
@property (strong , nonatomic) UILabel *goods_Introduction;
///商品评分
@property (strong , nonatomic) UILabel *goods_score;
///商品月销量
@property (strong , nonatomic) UILabel *goods_InSales;
///商品价格
@property (strong , nonatomic) UILabel *goods_price;
///商品券后价
@property (strong , nonatomic) UILabel *goods_vouchersAfter_price;
@property (strong , nonatomic) UIView *goods_vouchersAfter_view;
@property (strong , nonatomic) UILabel *goods_vouchersAfter_vip;
///店铺活动
@property (strong , nonatomic) UILabel *goods_StoreActivity;
///领券
@property (strong , nonatomic) UILabel *goods_vouchers;
///收藏数量
@property (strong , nonatomic) UILabel *goods_collection;
///评价数量
@property (strong , nonatomic) UILabel *goods_evaluation;

///加入购物车
@property (strong , nonatomic) UIButton *leftBtn;
///立即购买
@property (strong , nonatomic) UIButton *finishBtn;

///分割线
@property (strong , nonatomic) UIView *goods_line;
@property (strong , nonatomic) UILabel *goods_line_title;

@property (strong , nonatomic) UICollectionView *collectionview;

@property (strong , nonatomic) NSArray *dataSimilarArr;

@property (strong , nonatomic) NSDictionary *goodsDic;

@end

@implementation HCGoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F0F2F5"];
    self.navigationItem.title = @"商品详情";
    [self LoadUI];
    [self loadData];
    [self loadGoodsData];
}
#pragma 商品详情
- (void)loadData{
    @weakify(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.tao_id forKey:@"tao_id"];

    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/shop/api/getGood/tid" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"status"] intValue] == 200) {
            
            self.goodsDic = [responseObject[@"content"] firstObject];
            
            [weak_self.goods_image sd_setImageWithURL:self.goodsDic[@"pict_url"] placeholderImage:[UIImage imageNamed:@"mall_Placeholder_image"]];
            weak_self.goods_name.text = self.goodsDic[@"title"];
            weak_self.goods_Introduction.text = self.goodsDic[@"jianjie"];
            weak_self.goods_score.text = [NSString stringWithFormat:@"评分:%@",self.goodsDic[@"shop_dsr"]];
            weak_self.goods_InSales.text = [NSString stringWithFormat:@"月销量:%@",self.goodsDic[@"volume"]];
            weak_self.goods_price.text = [NSString stringWithFormat:@"￥%@",self.goodsDic[@"size"]];
            weak_self.goods_vouchersAfter_price.text = [NSString stringWithFormat:@"￥%@",self.goodsDic[@"quanhou_jiage"]];
            weak_self.goods_StoreActivity.text = self.goodsDic[@"biaoqian"];
            weak_self.goods_collection.text = [NSString stringWithFormat:@"收藏:%@+",self.goodsDic[@"favcount"]];
            weak_self.goods_evaluation.text = [NSString stringWithFormat:@"宝贝评论:%@+",self.goodsDic[@"commentCount"]];
            [self reloadMesonry];
        }else if ([responseObject[@"status"] intValue] == 301){
            [XHToast showBottomWithText:responseObject[@"content"]];
            [self.xp_rootNavigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSString * _Nonnull error) {

    }];
    
}
#pragma 相识商品
- (void)loadGoodsData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    [params setObject:@"14" forKey:@"page_size"];
    [params setObject:self.tao_id forKey:@"item_id"];

    [self NetWorkingPostWithURL:self hiddenHUD:YES url:@"/api/shop/api/getGood/similarity" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"status"] intValue] == 200) {
            
            self.dataSimilarArr = [NSArray arrayWithArray:responseObject[@"content"]];
            [self.collectionview reloadData];
            [self reloadMesonry];
        }
    } failure:^(NSString * _Nonnull error) {

    }];
    
}
#pragma 立即购买
- (void)getBuyNowAction{
    
    HCMallBuyNowView *BuyNowView = [[HCMallBuyNowView alloc] init];
    BuyNowView.top_H = 280.0;
    
    [BuyNowView.goods_image sd_setImageWithURL:self.goodsDic[@"pict_url"] placeholderImage:[UIImage imageNamed:@"mall_Placeholder_image"]];
    BuyNowView.goods_name.text = self.goodsDic[@"title"];
    
    BuyNowView.goods_vouchersAfter_price.text = [NSString stringWithFormat:@"￥%@",self.goodsDic[@"quanhou_jiage"]];
    [BuyNowView.finishBtn bk_whenTapped:^{
        if (![self 去登录]) return;
        [BuyNowView disMissView];
        
        HCMallOrderConfirmationController *VC = [HCMallOrderConfirmationController new];
        VC.goodsDic = self.goodsDic;
        VC.number = [BuyNowView.BuyNow_number.text integerValue];
        [self.xp_rootNavigationController pushViewController:VC animated:YES];
    }];
    
    
    [BuyNowView ShowView];
}

#pragma 购物车
- (void)getShoppingCartAction{
    if (![self 去登录]) return;
    if ([self.leftBtn.titleLabel.text isEqualToString:@"已加入购物车"]){
        [XHToast showBottomWithText:@"商品已在购物车！"];
        return;
    }
    NSDictionary *UserDic = [self loadUserData];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:UserDic[@"username"] forKey:@"phone"];
    [params setObject:[NSDate GetCurrentDateType:DateTypeYMD] forKey:@"time"];
    [params setObject:self.tao_id forKey:@"tao_id"];
    @weakify(self);
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/shop/addShoppingCart" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            [weak_self.leftBtn setTitle:@"已加入购物车" forState:UIControlStateNormal];
            [XHToast showBottomWithText:@"加入购物车成功"];
        }
    } failure:^(NSString * _Nonnull error) {

    }];
}

#pragma 收藏
- (void)getGoodsVouchersAction{
    if (![self 去登录]) return;
    if ([self.goods_vouchers.text isEqualToString:@"已收藏"]){
        [XHToast showBottomWithText:@"您已收藏过此商品！"];
        return;
    }
    NSDictionary *UserDic = [self loadUserData];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:UserDic[@"username"] forKey:@"phone"];
    [params setObject:[NSDate GetCurrentDateType:DateTypeYMD] forKey:@"time"];
    [params setObject:self.tao_id forKey:@"tao_id"];

    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/shop/addCollect" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            self.goods_vouchers.text = @"已收藏";
            [XHToast showBottomWithText:@"收藏成功"];
        }
    } failure:^(NSString * _Nonnull error) {

    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSimilarArr.count;
}
//设置方块的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cell";
    HCMallGoodsCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    NSDictionary *data = self.dataSimilarArr[indexPath.row];
    
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
    
    NSDictionary *data = self.dataSimilarArr[indexPath.row];
    
    HCGoodsDetailController *VC = [HCGoodsDetailController new];
    
    VC.tao_id = data[@"tao_id"];
    
    [self.xp_rootNavigationController pushViewController:VC animated:YES];
}
- (void)LoadUI{
    
    
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.height.offset(DEVICE_HEIGHT);
        make.left.top.offset(0);
    }];
    
    [self.scrollView addSubview:self.goods_image];
    [self.goods_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 340));
        make.left.top.offset(0);
    }];
    
    [self.scrollView addSubview:self.goods_view];
    [self.goods_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH - 20);
        make.left.offset(10);
        make.top.equalTo(self.goods_image.mas_bottom).offset(15);
    }];
    
    double view_left_w = 15.0f;
    
    [self.goods_view addSubview:self.goods_name];
    [self.goods_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(view_left_w);
        make.right.offset(-15);
        make.top.offset(15);
    }];
    [self.goods_view addSubview:self.goods_Introduction];
    [self.goods_Introduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(view_left_w);
        make.right.offset(-15);
        make.top.equalTo(self.goods_name.mas_bottom).offset(10);
    }];
    [self.goods_view addSubview:self.goods_score];
    [self.goods_score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(view_left_w);
        make.top.equalTo(self.goods_Introduction.mas_bottom).offset(10);
    }];
    [self.goods_view addSubview:self.goods_InSales];
    [self.goods_InSales mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.goods_score);
    }];
    
    [self.goods_view addSubview:self.goods_price];
    [self.goods_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(view_left_w);
        make.top.equalTo(self.goods_score.mas_bottom).offset(10);
    }];
    
    
    [self.goods_view addSubview:self.goods_vouchersAfter_view];
    [self.goods_vouchersAfter_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(view_left_w);
        make.bottom.equalTo(self.goods_price.mas_bottom).offset(-5);
        make.left.equalTo(self.goods_price.mas_right).offset(10);
    }];
    
    [self.goods_vouchersAfter_view addSubview:self.goods_vouchersAfter_vip];
    [self.goods_vouchersAfter_vip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goods_vouchersAfter_view);
        make.left.offset(5);
    }];
    [self.goods_vouchersAfter_view addSubview:self.goods_vouchersAfter_price];
    [self.goods_vouchersAfter_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(13);
        make.centerY.equalTo(self.goods_vouchersAfter_view);
        make.left.equalTo(self.goods_vouchersAfter_vip.mas_right).offset(5);
        make.right.offset(-1);
    }];
    
    
//    [self.goods_view addSubview:self.goods_StoreActivity];
//    [self.goods_StoreActivity mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(18);
//        make.left.offset(view_left_w);
//        make.top.equalTo(self.goods_price.mas_bottom).offset(10);
//    }];
    
    [self.goods_view addSubview:self.goods_vouchers];
    [self.goods_vouchers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 24));
        make.right.offset(0);
        make.centerY.equalTo(self.goods_vouchersAfter_price);
    }];
    
    [self.goods_view addSubview:self.goods_collection];
    [self.goods_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(18);
        make.left.offset(view_left_w);
        make.top.equalTo(self.goods_price.mas_bottom).offset(10);
        make.bottom.offset(-15);
    }];
    
    [self.goods_view addSubview:self.goods_evaluation];
    [self.goods_evaluation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goods_collection.mas_right).offset(view_left_w);
        make.centerY.equalTo(self.goods_collection);
    }];
    
    
    [self.scrollView addSubview:self.goods_line];
    [self.goods_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 0.5));
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.goods_view.mas_bottom).offset(30);
    }];
    
    [self.scrollView addSubview:self.goods_line_title];
    [self.goods_line_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 18));
        make.center.equalTo(self.goods_line);
    }];
    
    
    [self.scrollView addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.top.equalTo(self.goods_line.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left);
        make.height.offset(7 * 220 + 55);
    }];
    
    
    
    
    
    [self.view addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 46));
        make.left.offset(15);
        make.bottom.offset(-15-KBottomHeight);
    }];
    
    [self.view addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-15-130, 46));
        make.left.offset(130);
        make.bottom.offset(-15-KBottomHeight);
    }];
    
    [self reloadMesonry];
    
}

- (void)reloadMesonry{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    _scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, CGRectGetMaxY(self.collectionview.frame) + KBottomHeight + 76 + 65);
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
        _collectionview.backgroundColor = [UIColor colorWithHexString:@"F0F2F5"];
        _collectionview.showsVerticalScrollIndicator = NO;
        //注册Cell
        [self.collectionview registerNib:[UINib nibWithNibName:@"HCMallGoodsCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        _collectionview.scrollEnabled = NO;
    }
    return _collectionview;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _scrollView;
}
- (UIImageView *)goods_image{
    if (!_goods_image) {
        _goods_image = [UIImageView getUIImageView:@"mall_Placeholder_image"];
        _goods_image.contentMode = UIViewContentModeScaleToFill;
    }
    return _goods_image;
}
- (UIView *)goods_view{
    if (!_goods_view) {
        _goods_view = [UIView new];
        _goods_view.backgroundColor = [UIColor whiteColor];
        _goods_view.ylCornerRadius = 10;
    }
    return _goods_view;
}
- (UILabel *)goods_name{
    if (!_goods_name) {
        _goods_name = [UILabel new];
        _goods_name.text = @"商品名称";
        _goods_name.font = [UIFont getUIFontSize:18 IsBold:YES];
        _goods_name.textColor = [UIColor colorWithHexString:@"#000000"];
        _goods_name.numberOfLines = 3;
    }
    return _goods_name;
}
- (UILabel *)goods_Introduction{
    if (!_goods_Introduction) {
        _goods_Introduction = [UILabel getUILabelText:@"商品简介" TextColor:[UIColor colorWithHexString:@"#999999"] TextFont:[UIFont getUIFontSize:12 IsBold:NO] TextNumberOfLines:5];
    }
    return _goods_Introduction;
}
- (UILabel *)goods_score{
    if (!_goods_score) {
        _goods_score = [UILabel getUILabelText:@"评分：" TextColor:[UIColor colorWithHexString:@"#999999"] TextFont:[UIFont getUIFontSize:12 IsBold:NO] TextNumberOfLines:0];
    }
    return _goods_score;
}
- (UILabel *)goods_InSales{
    if (!_goods_InSales) {
        _goods_InSales = [UILabel getUILabelText:@"月销量：" TextColor:[UIColor colorWithHexString:@"#999999"] TextFont:[UIFont getUIFontSize:12 IsBold:NO] TextNumberOfLines:0];
    }
    return _goods_InSales;
}
- (UILabel *)goods_price{
    if (!_goods_price) {
        _goods_price = [UILabel getUILabelText:@"￥0.00" TextColor:[UIColor colorWithHexString:@"#FF8100"] TextFont:[UIFont getUIFontSize:24 IsBold:NO] TextNumberOfLines:0];
    }
    return _goods_price;
}
- (UIView *)goods_vouchersAfter_view{
    if (!_goods_vouchersAfter_view) {
        _goods_vouchersAfter_view = [UIView new];
        _goods_vouchersAfter_view.backgroundColor = [UIColor colorWithHexString:@"#FDD8A9"];
    }
    return _goods_vouchersAfter_view;
}
- (UILabel *)goods_vouchersAfter_vip{
    if (!_goods_vouchersAfter_vip) {
        _goods_vouchersAfter_vip = [UILabel getUILabelText:@"券后" TextColor:[UIColor whiteColor] TextFont:[UIFont getUIFontSize:12 IsBold:NO] TextNumberOfLines:0];
    }
    return _goods_vouchersAfter_vip;
}
- (UILabel *)goods_vouchersAfter_price{
    if (!_goods_vouchersAfter_price) {
        _goods_vouchersAfter_price = [UILabel getUILabelText:@"￥0.00" TextColor:[UIColor colorWithHexString:@"#FF8100"] TextFont:[UIFont getUIFontSize:12 IsBold:NO] TextNumberOfLines:0];
        _goods_vouchersAfter_price.backgroundColor = [UIColor whiteColor];
    }
    return _goods_vouchersAfter_price;
}
- (UILabel *)goods_StoreActivity{
    if (!_goods_StoreActivity) {
        _goods_StoreActivity = [UILabel getUILabelText:@"  店铺活动  " TextColor:[UIColor colorWithHexString:@"#FF8100"] TextFont:[UIFont getUIFontSize:12 IsBold:NO] TextNumberOfLines:0];
        _goods_StoreActivity.layer.masksToBounds = YES;
        _goods_StoreActivity.layer.cornerRadius = 3;
        _goods_StoreActivity.layer.borderColor = [UIColor colorWithHexString:@"#FF8100"].CGColor;
        _goods_StoreActivity.layer.borderWidth = 0.5;
    }
    return _goods_StoreActivity;
}
- (UILabel *)goods_vouchers{
    if (!_goods_vouchers) {
        _goods_vouchers = [UILabel getUILabelText:@"+收藏" TextColor:[UIColor whiteColor] TextFont:[UIFont getUIFontSize:13 IsBold:NO] TextNumberOfLines:0];
        _goods_vouchers.backgroundColor = [UIColor colorWithHexString:@"#FF8100"];
        [ _goods_vouchers getPartOfTheCornerRadius:CGRectMake(0, 0, 50, 24) CornerRadius:12 UIRectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft];
        _goods_vouchers.userInteractionEnabled = YES;
        _goods_vouchers.textAlignment = NSTextAlignmentCenter;
        [_goods_vouchers bk_whenTapped:^{
            [self getGoodsVouchersAction];
        }];
        
    }
    return _goods_vouchers;
}
- (UILabel *)goods_collection{
    if (!_goods_collection) {
        _goods_collection = [UILabel getUILabelText:@"收藏：0+" TextColor:[UIColor colorWithHexString:@"#999999"] TextFont:[UIFont getUIFontSize:12 IsBold:NO] TextNumberOfLines:0];
    }
    return _goods_collection;
}
- (UILabel *)goods_evaluation{
    if (!_goods_evaluation) {
        _goods_evaluation = [UILabel getUILabelText:@"宝贝评论：0+" TextColor:[UIColor colorWithHexString:@"#999999"] TextFont:[UIFont getUIFontSize:12 IsBold:NO] TextNumberOfLines:0];
    }
    return _goods_evaluation;
}
- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
        [_leftBtn setBackgroundColor:[UIColor colorWithHexString:@"#B9B9B9"]];
        [_leftBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont getUIFontSize:13 IsBold:YES];
        _leftBtn.ylCornerRadius = 8;
        [_leftBtn bk_whenTapped:^{
            [self getShoppingCartAction];
        }];
    }
    return _leftBtn;
}
- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton new];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"KD_BindCardBtn"] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"马上抢" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont getUIFontSize:13 IsBold:YES];
        _finishBtn.ylCornerRadius = 8;
        [_finishBtn bk_whenTapped:^{
            [self getBuyNowAction];
        }];
    }
    return _finishBtn;
}
- (UIView *)goods_line{
    if (!_goods_line) {
        _goods_line = [UIView new];
        _goods_line.backgroundColor = [UIColor colorWithHexString:@"#FF8100"];
    }
    return _goods_line;
}
- (UILabel *)goods_line_title{
    if (!_goods_line_title) {
        _goods_line_title = [UILabel getUILabelText:@"瞧了又瞧" TextColor:[UIColor colorWithHexString:@"#FF8100"] TextFont:[UIFont getUIFontSize:15 IsBold:NO] TextNumberOfLines:0];
        _goods_line_title.backgroundColor = [UIColor colorWithHexString:@"F0F2F5"];
        _goods_line_title.textAlignment = NSTextAlignmentCenter;
    }
    return _goods_line_title;
}
@end
