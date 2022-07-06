//
//  HCInviteFriendsController.m
//  HC
//
//  Created by tuibao on 2021/11/17.
//

#import "HCInviteFriendsController.h"

@interface HCInviteFriendsController ()

@end

@implementation HCInviteFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadUI];
    [self saveAction];
    [self getVersionData];
}


#pragma 获取版本信息
- (void)getVersionData{
    
    [self NetWorkingPostWithURL:self hiddenHUD:YES url:@"/api/user/app/config/get" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            NSDictionary * data= responseObject[@"data"];
            //清楚缓存数据
            NSDictionary *UserData = [self loadUserData];
            NSString *str = [NSString stringWithFormat:@"%@?brandId=%@&userId=%@",data[@"shareUrl"],brandId,UserData[@"id"]];
            
            self.QrCode_img.image = [UIImage createQRCodeWithTargetString:str logoImage:nil];
        }
    } failure:^(NSString * _Nonnull error) {

    }];
    
    
}


- (void)saveAction{
    [self.baocun_btn bk_whenTapped:^{
        [self.content_image setNeedsLayout];
        [self.content_image layoutIfNeeded];
        UIImage *image = [self.view captureImageFromView:self.content_view];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    }];
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [XHToast showBottomWithText:@"保存成功"];
    }
}


- (void)loadUI{

    
    [self.bg_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.offset(-KBottomHeight);
    }];
    [self.navigation_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44));
        make.top.equalTo(self.bg_image.mas_top).offset(kStatusBarHeight);
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
    
    [self.content_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset( (DEVICE_HEIGHT-450) / 2 - 20);
        make.centerX.equalTo(self.view);
    }];
    [self.content_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);

    }];

    
    [self.QrCode_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(130, 130));
        make.centerX.equalTo(self.content_image);
        make.top.equalTo(self.content_image.mas_top).offset(215);
    }];
    
    
    
    [self.baocun_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(260, 40));
        make.top.equalTo(self.content_image.mas_bottom).offset(RatioH(20));
        make.centerX.equalTo(self.content_image);
    }];
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

@end
