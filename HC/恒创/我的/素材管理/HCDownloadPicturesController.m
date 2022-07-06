//
//  HCDownloadPicturesController.m
//  HC
//
//  Created by tuibao on 2022/1/8.
//

#import "HCDownloadPicturesController.h"

@interface HCDownloadPicturesController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *navigation_View;
@property (weak, nonatomic) IBOutlet UIButton *nav_back;
@property (weak, nonatomic) IBOutlet UILabel *nav_title;
@property (weak, nonatomic) IBOutlet UIButton *nav_Download;

@property (weak, nonatomic) IBOutlet UIView *bottom_view;
@property (weak, nonatomic) IBOutlet UIView *bottom_left_view;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_left_icon;
@property (weak, nonatomic) IBOutlet UILabel *bottom_left_lab;

@property (weak, nonatomic) IBOutlet UILabel *bottom_center_lab;
@property (weak, nonatomic) IBOutlet UILabel *bottom_right_lab;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_right_image;

@property (weak, nonatomic) IBOutlet UIView *scrollView_view;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation HCDownloadPicturesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self LoadUI];
    [self getVersionData];
    
}

- (IBAction)图片下载:(id)sender {
    [self.navigation_View setHidden:YES];
    UIImage *image = [self.view captureImageFromView:self.view];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [self.navigation_View setHidden:NO];
        [XHToast showBottomWithText:@"保存成功" duration:1.5];
    }
}

#pragma 获取版本信息
- (void)getVersionData{
    
    [self NetWorkingPostWithURL:self hiddenHUD:YES url:@"/api/user/app/config/get" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            NSDictionary * data= responseObject[@"data"];
            //得到用户数据
            NSDictionary *UserData = [self loadUserData];
            NSString *str = [NSString stringWithFormat:@"%@?brandId=%@&userId=%@",data[@"shareUrl"],brandId,UserData[@"id"]];
            
            self.bottom_right_image.image = [UIImage createQRCodeWithTargetString:str logoImage:nil];
        }
    } failure:^(NSString * _Nonnull error) {

    }];
}

- (void)LoadUI{
    
    
    
    [self.navigation_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44));
        make.top.equalTo(self.view.mas_top).offset(kStatusBarHeight);
        make.left.equalTo(self.view);
    }];
    [self.nav_back setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self.nav_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.centerY.equalTo(self.navigation_View);
    }];
    [self.nav_back bk_whenTapped:^{
        [self.xp_rootNavigationController popViewControllerAnimated:YES];
    }];
    
    [self.nav_Download setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self.nav_Download mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.centerY.equalTo(self.navigation_View);
    }];
    
    [self.nav_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navigation_View);
    }];
    
    
    [self.bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.offset(DEVICE_WIDTH);
        make.left.offset(0);
    }];
    
    [self.bottom_left_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.bottom.offset(-15);
    }];
    [self.bottom_left_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
    }];
    
    [self.bottom_left_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottom_left_icon.mas_bottom).offset(5);
        make.centerX.equalTo(self.bottom_left_icon);
        make.bottom.offset(0);
    }];
    
    [self.bottom_center_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(123);
        make.centerY.equalTo(self.bottom_view);
        make.left.equalTo(self.bottom_left_view.mas_right).offset(28);
    }];
    
    [self.bottom_right_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(62, 62));
        make.centerY.equalTo(self.bottom_view);
        make.right.offset(-25);
    }];
    
    [self.bottom_right_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(42);
        make.centerY.equalTo(self.bottom_view);
        make.right.equalTo(self.bottom_right_image.mas_left).offset(-25);
    }];
    [self.scrollView_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset(-KBottomHeight);
    }];
    [self.scrollView_view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
//    [self.bottom_view setHidden:YES];
    self.scrollView.contentSize = CGSizeMake(DEVICE_WIDTH * self.imageArr.count, DEVICE_HEIGHT);
    
    for (int i = 0; i < self.imageArr.count ; i++) {
        UIImageView *image = [[UIImageView alloc]init];
        image.backgroundColor = [UIColor orangeColor];
        [image sd_setImageWithURL:[NSURL URLWithString:self.imageArr[i][@"content"]] placeholderImage:[UIImage imageNamed:@"mall_Placeholder_image"]];
        image.contentMode = UIViewContentModeScaleToFill;
        image.frame = CGRectMake(i * DEVICE_WIDTH, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        [self.scrollView addSubview:image];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / DEVICE_WIDTH;  //计算这是第几页
    self.nav_title.text = [NSString stringWithFormat:@"%li/%li",index+1,self.imageArr.count];
}

#pragma 懒加载
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _scrollView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

@end
