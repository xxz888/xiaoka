//
//  HCActivityCenterController.m
//  HC
//
//  Created by tuibao on 2021/11/19.
//

#import "HCActivityCenterController.h"

@interface HCActivityCenterController ()

@property(strong, nonatomic) UIImageView *top_imageView;
@property(strong, nonatomic) UILabel *tishi_lab;
@property(strong, nonatomic) UIImageView *zhitui_imageView;
@property(strong, nonatomic) UILabel *zhitui_lab;

@property(strong, nonatomic) UIImageView *bottom_imageView;
@property(strong, nonatomic) UILabel *bottom_title_lab;
@property(strong, nonatomic) UIView *bottom_line_left;
@property(strong, nonatomic) UIView *bottom_line_right;

@property(strong, nonatomic) UIView *center_view;

@property(strong, nonatomic) UILabel *center_left_lab1;
@property(strong, nonatomic) UILabel *center_center_lab1;
@property(strong, nonatomic) UILabel *center_right_lab1;
@property(strong, nonatomic) UIView *center_line1;

@property(strong, nonatomic) UILabel *center_left_lab2;
@property(strong, nonatomic) UILabel *center_center_lab2;
@property(strong, nonatomic) UILabel *center_right_lab2;
@property(strong, nonatomic) UIView *center_line2;

@property(strong, nonatomic) UILabel *center_left_lab3;
@property(strong, nonatomic) UILabel *center_center_lab3;
@property(strong, nonatomic) UILabel *center_right_lab3;
@property(strong, nonatomic) UIView *center_line3;

@property(strong, nonatomic) UILabel *center_tishi;

@end

@implementation HCActivityCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"活动中心";
    [self LoadUI];
    [self getActivityCenterData];
    
    
}
#pragma 获取活动信息
- (void)getActivityCenterData{
    @weakify(self);
    [self NetWorkingPostWithURL:self hiddenHUD:YES url:@"/api/user/get/centre" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            NSDictionary * data= responseObject[@"data"];
            
            weak_self.center_right_lab1.text = [NSString stringWithFormat:@"%@万",data[@"totalAmount"]];
            weak_self.center_right_lab2.text = [NSString stringWithFormat:@"%@",data[@"personCount"]];
            weak_self.center_right_lab3.text = [NSString stringWithFormat:@"差%@万",data[@"howUpdate"]];
            
            if([data[@"vipLevel"] intValue] != 3){
                weak_self.center_left_lab3.text = [NSString stringWithFormat:@"钻石V%i",[data[@"vipLevel"] intValue] + 1];
            }else{
                weak_self.center_left_lab3.text = @"您当前已是最高钻石VIP等级";
                [weak_self.center_center_lab3 setHidden:YES];
                [weak_self.center_right_lab3 setHidden:YES];
                [weak_self.center_left_lab3 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(200);
                }];
            }
        }
    } failure:^(NSString * _Nonnull error) {

    }];
}
- (void)LoadUI{
    
    [self.view addSubview:self.top_imageView];
    [self.top_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 123));
        make.left.offset(15);
        make.top.equalTo(self.view.mas_top).offset(15);
    }];
    
    [self.view addSubview:self.tishi_lab];
    [self.tishi_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top_imageView.mas_top).offset(8);
        make.right.equalTo(self.top_imageView.mas_right).offset(-25);
    }];
    
    [self.view addSubview:self.zhitui_imageView];
    [self.zhitui_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.top_imageView.mas_left).offset(16);
        make.top.equalTo(self.top_imageView.mas_top).offset(35);
    }];
    
    [self.view addSubview:self.zhitui_lab];
    [self.zhitui_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zhitui_imageView.mas_left).offset(2);
        make.top.equalTo(self.zhitui_imageView.mas_bottom).offset(8);
    }];
    
    [self.view addSubview:self.bottom_imageView];
    [self.bottom_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 364));
        make.top.equalTo(self.top_imageView.mas_bottom).offset(15);
        make.left.offset(15);
    }];
    [self.view addSubview:self.bottom_title_lab];
    [self.bottom_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottom_imageView.mas_top).offset(28);
        make.centerX.equalTo(self.bottom_imageView);
    }];
    
    [self.view addSubview:self.bottom_line_left];
    [self.bottom_line_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 0.5));
        make.right.equalTo(self.bottom_title_lab.mas_left).offset(-15);
        make.centerY.equalTo(self.bottom_title_lab);
    }];
    
    [self.view addSubview:self.bottom_line_right];
    [self.bottom_line_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 0.5));
        make.left.equalTo(self.bottom_title_lab.mas_right).offset(15);
        make.centerY.equalTo(self.bottom_title_lab);
    }];
    
    [self.view addSubview:self.center_view];
    [self.center_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30 - 30, 249));
        make.top.equalTo(self.bottom_title_lab.mas_bottom).offset(28);
        make.centerX.equalTo(self.bottom_imageView);
    }];
    
    double lab_W = 75;
    
    [self.center_view addSubview:self.center_left_lab1];
    [self.center_left_lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W);
        make.left.offset(20);
        make.top.equalTo(self.center_view.mas_top).offset(15);
    }];
    
    [self.center_view addSubview:self.center_right_lab1];
    [self.center_right_lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W);
        make.right.offset(-10);
        make.centerY.equalTo(self.center_left_lab1);
    }];
    
    [self.center_view addSubview:self.center_center_lab1];
    [self.center_center_lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(5);
        make.centerY.equalTo(self.center_left_lab1);
        make.left.equalTo(self.center_left_lab1.mas_right).offset(10);
        make.right.equalTo(self.center_right_lab1.mas_left).offset(-20);
    }];
    
    [self.center_view addSubview:self.center_line1];
    [self.center_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30 - 30 - 20, 1));
        make.centerX.equalTo(self.center_view);
        make.top.equalTo(self.center_left_lab1.mas_bottom).offset(15);
    }];
    
    [self.center_view addSubview:self.center_left_lab2];
    [self.center_left_lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W);
        make.left.offset(20);
        make.top.equalTo(self.center_line1.mas_bottom).offset(15);
    }];
    
    [self.center_view addSubview:self.center_right_lab2];
    [self.center_right_lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W);
        make.right.offset(-10);
        make.centerY.equalTo(self.center_left_lab2);
    }];
    
    [self.center_view addSubview:self.center_center_lab2];
    [self.center_center_lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(5);
        make.centerY.equalTo(self.center_left_lab2);
        make.left.equalTo(self.center_left_lab2.mas_right).offset(10);
        make.right.equalTo(self.center_right_lab2.mas_left).offset(-20);
    }];
    
    [self.center_view addSubview:self.center_line2];
    [self.center_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30 - 30 - 20, 1));
        make.centerX.equalTo(self.center_view);
        make.top.equalTo(self.center_left_lab2.mas_bottom).offset(15);
    }];
    
    
    [self.center_view addSubview:self.center_left_lab3];
    [self.center_left_lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W);
        make.left.offset(20);
        make.top.equalTo(self.center_line2.mas_bottom).offset(15);
    }];
    
    [self.center_view addSubview:self.center_right_lab3];
    [self.center_right_lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lab_W);
        make.right.offset(-10);
        make.centerY.equalTo(self.center_left_lab3);
    }];
    
    [self.center_view addSubview:self.center_center_lab3];
    [self.center_center_lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(5);
        make.centerY.equalTo(self.center_left_lab3);
        make.left.equalTo(self.center_left_lab3.mas_right).offset(10);
        make.right.equalTo(self.center_right_lab3.mas_left).offset(-20);
    }];
    
    [self.center_view addSubview:self.center_line3];
    [self.center_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30 - 30 - 20, 1));
        make.centerX.equalTo(self.center_view);
        make.top.equalTo(self.center_left_lab3.mas_bottom).offset(15);
    }];
    
    [self.center_view addSubview:self.center_tishi];
    [self.center_tishi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH-30 - 30 - 20);
        make.centerX.equalTo(self.center_view);
        make.top.equalTo(self.center_line3.mas_bottom).offset(15);
    }];
    
}


- (UIImageView *)top_imageView{
    if (!_top_imageView) {
        _top_imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_xyk_bg1"]];
    }
    return _top_imageView;
}

- (UILabel *)tishi_lab{
    if (!_tishi_lab) {
        _tishi_lab = [UILabel new];
        _tishi_lab.text = @"注：活动仅限V3以下参与";
        _tishi_lab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _tishi_lab.font = [UIFont getUIFontSize:10 IsBold:NO];
    }
    return _tishi_lab;
}
- (UIImageView *)zhitui_imageView{
    if (!_zhitui_imageView) {
        _zhitui_imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_Activity_dikou"]];
    }
    return _zhitui_imageView;
}
- (UILabel *)zhitui_lab{
    if (!_zhitui_lab) {
        _zhitui_lab = [UILabel new];
        _zhitui_lab.text = @"达标交易量，抵扣直推";
        _zhitui_lab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _zhitui_lab.font = [UIFont getUIFontSize:12 IsBold:NO];
    }
    return _zhitui_lab;
}
- (UIImageView *)bottom_imageView{
    if (!_bottom_imageView) {
        _bottom_imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_Activity_dibuBG"]];
    }
    return _bottom_imageView;
}

- (UIView *)bottom_line_left{
    if (!_bottom_line_left) {
        _bottom_line_left = [UIView new];
        _bottom_line_left.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.5];
    }
    return _bottom_line_left;
}
- (UIView *)bottom_line_right{
    if (!_bottom_line_right) {
        _bottom_line_right = [UIView new];
        _bottom_line_right.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.5];
    }
    return _bottom_line_right;
}
- (UILabel *)bottom_title_lab{
    if (!_bottom_title_lab) {
        _bottom_title_lab = [UILabel new];
        _bottom_title_lab.text = @"直推抵扣";
        _bottom_title_lab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _bottom_title_lab.font = [UIFont getUIFontSize:18 IsBold:NO];
    }
    return _bottom_title_lab;
}
- (UIView *)center_view{
    if (!_center_view) {
        _center_view = [UIView new];
        _center_view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _center_view.layer.cornerRadius = 10.0;
    }
    return _center_view;
}

- (UILabel *)center_left_lab1{
    if (!_center_left_lab1) {
        _center_left_lab1 = [UILabel new];
        _center_left_lab1.text = @"累计交易量";
        _center_left_lab1.textColor = [UIColor colorWithHexString:@"#FF8100"];
        _center_left_lab1.font = [UIFont getUIFontSize:14 IsBold:YES];
    }
    return _center_left_lab1;
}
- (UILabel *)center_center_lab1{
    if (!_center_center_lab1) {
        _center_center_lab1 = [UILabel new];
        _center_center_lab1.text = @"------------------------------------------------------------";
        _center_center_lab1.textColor = [UIColor colorWithHexString:@"#FF8100"];
        _center_center_lab1.lineBreakMode = NSLineBreakByClipping;
        _center_center_lab1.font = [UIFont getUIFontSize:9 IsBold:NO];
    }
    return _center_center_lab1;
}
- (UILabel *)center_right_lab1{
    if (!_center_right_lab1) {
        _center_right_lab1 = [UILabel new];
        _center_right_lab1.text = @"0.00万";
        _center_right_lab1.textColor = [UIColor colorWithHexString:@"#FF8100"];
        _center_right_lab1.font = [UIFont getUIFontSize:14 IsBold:YES];
    }
    return _center_right_lab1;
}
- (UIView *)center_line1{
    if (!_center_line1) {
        _center_line1 = [UIView new];
        _center_line1.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    }
    return _center_line1;
}
- (UILabel *)center_left_lab2{
    if (!_center_left_lab2) {
        _center_left_lab2 = [UILabel new];
        _center_left_lab2.text = @"转化人数";
        _center_left_lab2.textColor = [UIColor colorWithHexString:@"#FF8100"];
        _center_left_lab2.font = [UIFont getUIFontSize:14 IsBold:YES];
    }
    return _center_left_lab2;
}
- (UILabel *)center_center_lab2{
    if (!_center_center_lab2) {
        _center_center_lab2 = [UILabel new];
        _center_center_lab2.text = @"------------------------------------------------------------";
        _center_center_lab2.textColor = [UIColor colorWithHexString:@"#FF8100"];
        _center_center_lab2.lineBreakMode = NSLineBreakByClipping;
        _center_center_lab2.font = [UIFont getUIFontSize:9 IsBold:NO];
    }
    return _center_center_lab2;
}
- (UILabel *)center_right_lab2{
    if (!_center_right_lab2) {
        _center_right_lab2 = [UILabel new];
        _center_right_lab2.text = @"0";
        _center_right_lab2.textColor = [UIColor colorWithHexString:@"#FF8100"];
        _center_right_lab2.font = [UIFont getUIFontSize:14 IsBold:YES];
    }
    return _center_right_lab2;
}
- (UIView *)center_line2{
    if (!_center_line2) {
        _center_line2 = [UIView new];
        _center_line2.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    }
    return _center_line2;
}


- (UILabel *)center_left_lab3{
    if (!_center_left_lab3) {
        _center_left_lab3 = [UILabel new];
        _center_left_lab3.text = @"钻石";
        _center_left_lab3.textColor = [UIColor colorWithHexString:@"#FF8100"];
        _center_left_lab3.font = [UIFont getUIFontSize:14 IsBold:YES];
    }
    return _center_left_lab3;
}
- (UILabel *)center_center_lab3{
    if (!_center_center_lab3) {
        _center_center_lab3 = [UILabel new];
        _center_center_lab3.text = @"------------------------------------------------------------";
        _center_center_lab3.textColor = [UIColor colorWithHexString:@"#FF8100"];
        _center_center_lab3.lineBreakMode = NSLineBreakByClipping;
        _center_center_lab3.font = [UIFont getUIFontSize:9 IsBold:NO];
    }
    return _center_center_lab3;
}
- (UILabel *)center_right_lab3{
    if (!_center_right_lab3) {
        _center_right_lab3 = [UILabel new];
        _center_right_lab3.text = @"差0.00万";
        _center_right_lab3.textColor = [UIColor colorWithHexString:@"#FF8100"];
        _center_right_lab3.font = [UIFont getUIFontSize:14 IsBold:YES];
    }
    return _center_right_lab3;
}
- (UIView *)center_line3{
    if (!_center_line3) {
        _center_line3 = [UIView new];
        _center_line3.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    }
    return _center_line3;
}

- (UILabel *)center_tishi{
    if (!_center_tishi) {
        _center_tishi = [UILabel new];
        _center_tishi.text = @"注：普通用户还款30万自动晋升LV1，\nLV1升级LV2，本账号下每产生20万交易量等同于直推钻石用户一名，\nLV2升级LV3，本账号下每产生20万交易量等同于直推钻石用户一名。";
        _center_tishi.textColor = [UIColor colorWithHexString:@"#FF0000"];
        _center_tishi.font = [UIFont getUIFontSize:12 IsBold:YES];
        _center_tishi.numberOfLines = 10;
    }
    return _center_tishi;
}


@end
