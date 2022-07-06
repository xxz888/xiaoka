//
//  HCTheEmptyCardController.m
//  HC
//
//  Created by tuibao on 2022/1/12.
//

#import "HCTheEmptyCardController.h"
#import "HCEmptyCardPrepaidController.h"
#import "HCEmptyCardCreditLinesView.h"
#import "HCTheEmptyCardMakeController.h"
#import "HCTheEmptyDetailController.h"
@interface HCTheEmptyCardController ()

@property (weak, nonatomic) IBOutlet UIView *navigation_View;
@property (weak, nonatomic) IBOutlet UIButton *nav_back;
@property (weak, nonatomic) IBOutlet UILabel *nav_title;
@property (weak, nonatomic) IBOutlet UIButton *nav_rightBtn;

@property (weak, nonatomic) IBOutlet UIImageView *top_bgView;

@property (weak, nonatomic) IBOutlet UIView *cententView1;
@property (weak, nonatomic) IBOutlet UIView *cententView2;
@property (weak, nonatomic) IBOutlet UIView *cententView3;
@property (weak, nonatomic) IBOutlet UILabel *cententView3_title;
@property (weak, nonatomic) IBOutlet UILabel *cententView3_number;

@property (weak, nonatomic) IBOutlet UILabel *left_title;
@property (weak, nonatomic) IBOutlet UILabel *left_number;

@property (weak, nonatomic) IBOutlet UILabel *right_title;
@property (weak, nonatomic) IBOutlet UILabel *right_number;

@property (weak, nonatomic) IBOutlet UIButton *centent_left_btn;
@property (weak, nonatomic) IBOutlet UIButton *centent_center_btn;
@property (weak, nonatomic) IBOutlet UIButton *centent_right_btn;

@property (weak, nonatomic) IBOutlet UIImageView *topleft_image;
@property (weak, nonatomic) IBOutlet UIButton *topleft_btn;

@property (weak, nonatomic) IBOutlet UIImageView *topright_image;
@property (weak, nonatomic) IBOutlet UIButton *topright_btn;


@property (weak, nonatomic) IBOutlet UIImageView *bottomleft_image;
@property (weak, nonatomic) IBOutlet UIButton *bottomleft_btn;

@property (weak, nonatomic) IBOutlet UIImageView *bottomright_image;
@property (weak, nonatomic) IBOutlet UIButton *bottomright_btn;

@end

@implementation HCTheEmptyCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadUI];
    [self ViewAction];
}
#pragma 点击事件
- (void)ViewAction{
    @weakify(self);
    
    [self.nav_rightBtn bk_whenTapped:^{
        HCTheEmptyDetailController *VC = [HCTheEmptyDetailController new];
        
        [self.xp_rootNavigationController pushViewController:VC animated:YES];
    }];
    
    
    [self.centent_center_btn bk_whenTapped:^{
        HCReflectController *VC = [HCReflectController new];
        VC.Reflect_type = @"空卡";
        
        VC.CanCarry_amount = @"0.00";
        [weak_self.xp_rootNavigationController pushViewController:VC animated:YES];
    }];
    [self.centent_right_btn bk_whenTapped:^{
        HCEmptyCardPrepaidController *VC = [HCEmptyCardPrepaidController new];
        
        [self.xp_rootNavigationController pushViewController:VC animated:YES];
    }];
    
    [self.centent_left_btn bk_whenTapped:^{
        @weakify(self);
        HCEmptyCardCreditLinesView *trading = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HCEmptyCardCreditLinesView class]) owner:nil options:nil] lastObject];
        trading.frame = CGRectMake(0, 0, 284, 175);
        
        trading.layer.cornerRadius = 8;
        //弹窗实例创建
        LSTPopView *popView = [LSTPopView initWithCustomView:trading
                                                      popStyle:LSTPopStyleSpringFromTop
                                                  dismissStyle:LSTDismissStyleSmoothToTop];
        LSTPopViewWK(popView)
        [trading.clean_btn bk_whenTapped:^{
            [wk_popView dismiss];
        }];
        [trading.determine bk_whenTapped:^{
            [wk_popView dismiss];
        }];
        [popView pop];
    }];
    
    
    [self.topleft_btn bk_whenTapped:^{
        HCTheEmptyCardMakeController *VC = [HCTheEmptyCardMakeController new];
        [self.xp_rootNavigationController pushViewController:VC animated:YES];
        
    }];
    
    
}




- (void)LoadUI{
    
    [self.top_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 230 + kTopHeight));
        make.top.left.offset(0);
    }];
    
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
    
    [self.nav_rightBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self.nav_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.centerY.equalTo(self.navigation_View);
    }];

    
    self.cententView1.ylCornerRadius = 62;
    [self.cententView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(124, 124));
        make.center.equalTo(self.top_bgView);
    }];
    
    self.cententView2.ylCornerRadius = 57;
    [self.cententView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(114, 114));
        make.center.equalTo(self.cententView1);
    }];
    self.cententView3.ylCornerRadius = 55;
    [self.cententView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 110));
        make.center.equalTo(self.cententView2);
    }];
    
    [self.cententView3_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.offset(31);
        make.height.offset(21);
    }];
    
    [self.cententView3_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(3);
        make.right.offset(-3);
        make.top.equalTo(self.cententView3_title.mas_bottom).offset(4);
        make.height.offset(21);
    }];
    
    
    [self.left_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cententView3_title);
        make.left.offset(10);
        make.right.equalTo(self.cententView3.mas_left).offset(-30);
    }];
    [self.left_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cententView3_number);
        make.left.offset(10);
        make.right.equalTo(self.cententView3.mas_left).offset(-30);
    }];
    
    
    [self.right_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cententView3_title);
        make.right.offset(-10);
        make.left.equalTo(self.cententView3.mas_right).offset(30);
    }];
    [self.right_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cententView3_number);
        make.right.offset(-10);
        make.left.equalTo(self.cententView3.mas_right).offset(30);
    }];
    
    self.centent_center_btn.ylCornerRadius = 5;
    [self.centent_center_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(78, 28));
        make.centerX.equalTo(self.cententView3);
        make.bottom.equalTo(self.top_bgView.mas_bottom).offset(-20);
    }];
    self.centent_left_btn.ylCornerRadius = 5;
    [self.centent_left_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(78, 28));
        make.centerX.equalTo(self.left_title);
        make.bottom.equalTo(self.top_bgView.mas_bottom).offset(-20);
    }];
    self.centent_right_btn.ylCornerRadius = 5;
    [self.centent_right_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(78, 28));
        make.centerX.equalTo(self.right_title);
        make.bottom.equalTo(self.top_bgView.mas_bottom).offset(-20);
    }];
    
    double J = (DEVICE_WIDTH - 320) / 3;
    
    self.topleft_image.ylCornerRadius = 5;
    [self.topleft_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 50));
        make.top.equalTo(self.top_bgView.mas_bottom).offset(J+20);
        make.left.offset(J);
    }];
    [self.topleft_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:15];
    [self.topleft_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 50));
        make.center.equalTo(self.topleft_image);
    }];
    
    self.topright_image.ylCornerRadius = 5;
    [self.topright_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 50));
        make.top.equalTo(self.top_bgView.mas_bottom).offset(J+20);
        make.right.offset(-J);
    }];
    [self.topright_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:15];
    [self.topright_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(145, 50));
        make.centerY.equalTo(self.topright_image);
        make.left.equalTo(self.topright_image.mas_left);
    }];
    
    self.bottomleft_image.ylCornerRadius = 5;
    [self.bottomleft_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 50));
        make.top.equalTo(self.topright_image.mas_bottom).offset(J);
        make.left.offset(J);
    }];
    [self.bottomleft_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:15];
    [self.bottomleft_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 50));
        make.center.equalTo(self.bottomleft_image);
    }];
    
    self.bottomright_image.ylCornerRadius = 5;
    [self.bottomright_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 50));
        make.top.equalTo(self.topright_image.mas_bottom).offset(J);
        make.right.offset(-J);
    }];
    [self.bottomright_btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    [self.bottomright_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 50));
        make.center.equalTo(self.bottomright_image);
    }];
    
    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
@end
