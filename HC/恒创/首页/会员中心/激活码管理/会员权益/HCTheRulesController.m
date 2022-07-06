//
//  HCTheRulesController.m
//  HC
//
//  Created by tuibao on 2021/11/25.
//

#import "HCTheRulesController.h"

@interface HCTheRulesController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *bg_image;

@property (strong, nonatomic) UIView *navigation_View;
@property (strong, nonatomic) UIButton *nav_back;

@property (strong, nonatomic) UIButton *download_back;

@end

@implementation HCTheRulesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
}
- (void)loadUI{
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT-KBottomHeight));
        make.left.top.offset(0);
    }];
    
    
    [self.scrollView addSubview:self.bg_image];
    [self.bg_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.left.top.offset(0);
        make.height.offset([self imgContentHeight]);
    }];
    
    [self.view addSubview:self.navigation_View];
    [self.view addSubview:self.nav_back];
    

    [self.navigation_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44));
        make.top.equalTo(self.view.mas_top).offset(kStatusBarHeight);
        make.left.equalTo(self.view);
    }];
    
    [self.nav_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.centerY.equalTo(self.navigation_View);
    }];
    
    [self.view addSubview:self.download_back];
    [self.download_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 80));
        make.left.offset(0);
        make.top.equalTo(self.bg_image.mas_bottom).offset(-1);
    }];
    
    
    _scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, [self imgContentHeight]+80);
}
#pragma mark - 内容的高度
-(CGFloat)imgContentHeight{
    //获取图片高度
    UIImage *img = [UIImage imageNamed:@"icon_TheRules"];
    CGFloat imgHeight = img.size.height;
    CGFloat imgWidth = img.size.width;
    CGFloat imgH = imgHeight * (DEVICE_WIDTH / imgWidth);
    return imgH;
}
#pragma 懒加载
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
- (UIImageView *)bg_image{
    if (!_bg_image) {
        _bg_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_TheRules"]];
        _bg_image.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bg_image;
}
- (UIView *)navigation_View{
    if (!_navigation_View) {
        _navigation_View = [UIView new];
    }
    return _navigation_View;
}
- (UIButton *)nav_back{
    if (!_nav_back) {
        _nav_back = [UIButton new];
        [_nav_back setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_nav_back bk_whenTapped:^{
            [self.xp_rootNavigationController popViewControllerAnimated:YES];
        }];
        [_nav_back setEnlargeEdgeWithTop:10 right:20 bottom:10 left:10];
    }
    return _nav_back;
}
- (UIButton *)download_back{
    if (!_download_back) {
        _download_back = [UIButton new];
        _download_back.backgroundColor = [UIColor colorWithHexString:@"#282526"];
        [_download_back setTitleColor:[UIColor colorWithHexString:@"#FFEDDA"] forState:UIControlStateNormal];
        [_download_back setTitle:@"下载图片" forState:UIControlStateNormal];
        _download_back.layer.masksToBounds = YES;
        _download_back.layer.borderColor = [UIColor colorWithHexString:@"#FFEDDA"].CGColor;
        _download_back.layer.borderWidth = 1.0f;
        _download_back.titleLabel.font = [UIFont getUIFontSize:20 IsBold:YES];
        [_download_back bk_whenTapped:^{
            UIImage *image = [self.view captureImageFromView:self.bg_image];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
        }];
    }
    return _download_back;
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [XHToast showBottomWithText:@"保存成功"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
@end
