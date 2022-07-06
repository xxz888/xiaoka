//
//  HCInvestmentIncomeController.m
//  HC
//
//  Created by tuibao on 2021/11/19.
//

#import "HCInvestmentIncomeController.h"
#import "HCInvestmentDetailController.h"
@interface HCInvestmentIncomeController ()

@end

@implementation HCInvestmentIncomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadUI];
    [self LoadData];
    [self getData];
}

- (void)getData{
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/get/attract/profit/list" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
           
            NSDictionary *dic = responseObject[@"data"];
            
            self.TotalRevenue_number_lab.text = [NSString stringWithFormat:@"%.2f",[dic[@"totalBalance"] doubleValue]];//招商总收益
            self.DayRevenue_number_lab.text = [NSString stringWithFormat:@"%.2f",[dic[@"todayTotal"] doubleValue]];//今日收益
            self.MonthRevenue_number_lab.text = [NSString stringWithFormat:@"%.2f",[dic[@"curMonthTotal"] doubleValue]];//当月收益
            
            self.min_bg_lab1.text = [NSString stringWithFormat:@"当日注册(人)：%@",dic[@"todayRegisterCount"]];
            self.min_bg_lab2.text = [NSString stringWithFormat:@"当月注册(人)：%@",dic[@"curMonthRegisterCount"]];
            self.min_bg_lab3.text = [NSString stringWithFormat:@"当日激活(人)：%@",dic[@"todayActivationCount"]];
            self.min_bg_lab4.text = [NSString stringWithFormat:@"当月激活(人)：%@",dic[@"curMonthActivationCount"]];
            
            //已注册人数 = 直推 + 间推
            NSInteger lab1_number = [dic[@"firstCount"] intValue] +  [dic[@"secondCount"] intValue];
            self.center_view_lab1.text = [NSString stringWithFormat:@"已注册%li人",lab1_number];
            
            //已激活 = 直推激活 + 间推激活
            NSInteger lab2_number = [dic[@"firstActivationCount"] intValue] +  [dic[@"secondActivationCount"] intValue];
            self.center_view_lab2.text = [NSString stringWithFormat:@"已激活%li人",lab2_number];
            
            //直推激活
            self.center_view_lab3.text = [NSString stringWithFormat:@"直推激活%@人",dic[@"firstActivationCount"]];
            
            //已实名 = 直推实名 + 间推实名
            NSInteger lab4_number = [dic[@"firstRealnameCount"] intValue] +  [dic[@"secondRealnameCount"] intValue];
            self.center_view_lab4.text = [NSString stringWithFormat:@"已实名%li人",lab4_number];
            
            //未激活 = 已注册 - 已激活
            NSInteger lab5_number = lab1_number -  lab2_number;
            self.center_view_lab5.text = [NSString stringWithFormat:@"未激活%li人",lab5_number];
            
            //间推激活
            self.center_view_lab6.text = [NSString stringWithFormat:@"间推激活%@人",dic[@"secondActivationCount"]];
          
            [self LoadData];
        }else{
            
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}




- (void)LoadData{
    self.center_view_lab1.attributedText = [UILabel setupAttributeString:self.center_view_lab1.text rangeText:@"已注册" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
    self.center_view_lab2.attributedText = [UILabel setupAttributeString:self.center_view_lab2.text rangeText:@"已激活" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
    self.center_view_lab3.attributedText = [UILabel setupAttributeString:self.center_view_lab3.text rangeText:@"直推激活" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
    self.center_view_lab4.attributedText = [UILabel setupAttributeString:self.center_view_lab4.text rangeText:@"已实名" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
    self.center_view_lab5.attributedText = [UILabel setupAttributeString:self.center_view_lab5.text rangeText:@"未激活" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
    self.center_view_lab6.attributedText = [UILabel setupAttributeString:self.center_view_lab6.text rangeText:@"间推激活" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont getUIFontSize:12 IsBold:NO]];
}


- (void)loadUI{

    
    [self.top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(130 + kTopHeight);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    [self.navigation_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44));
        make.top.equalTo(self.top_image.mas_top).offset(kStatusBarHeight);
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
    [self.nav_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navigation_View);
    }];
    
    [self.TotalRevenue_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(200);
        make.top.equalTo(self.navigation_View.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [self.TotalRevenue_number_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(200);
        make.top.equalTo(self.TotalRevenue_title_lab.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
    }];
    
    double Revenue_W = DEVICE_WIDTH / 2;
    
    [self.DayRevenue_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(Revenue_W);
        make.top.equalTo(self.TotalRevenue_number_lab.mas_bottom).offset(25);
        make.left.offset(0);
    }];
    [self.DayRevenue_number_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(Revenue_W);
        make.top.equalTo(self.DayRevenue_title_lab.mas_bottom).offset(5);
        make.left.offset(0);
    }];
    
    [self.MonthRevenue_title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(Revenue_W);
        make.top.equalTo(self.TotalRevenue_number_lab.mas_bottom).offset(25);
        make.right.offset(0);
    }];
    [self.MonthRevenue_number_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(Revenue_W);
        make.top.equalTo(self.MonthRevenue_title_lab.mas_bottom).offset(5);
        make.right.offset(0);
    }];
    
    double min_W = (DEVICE_WIDTH - 20 - 27 - 20) / 2;
    [self.min_bg_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH - 20);
        make.top.equalTo(self.top_image.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    self.min_bg_image.userInteractionEnabled = YES;
    [self.min_bg_image bk_whenTapped:^{
        [self.xp_rootNavigationController pushViewController:[HCInvestmentDetailController new] animated:YES];
    }];
    [self.min_bg_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.min_bg_image);
        make.right.equalTo(self.min_bg_image.mas_right).offset(-20);
    }];
    
    [self.min_bg_lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(min_W);
        make.top.equalTo(self.min_bg_image.mas_top).offset(12);
        make.left.equalTo(self.min_bg_image.mas_left).offset(10);
    }];
    [self.min_bg_lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(min_W);
        make.centerY.equalTo(self.min_bg_lab1);
        make.left.equalTo(self.min_bg_lab1.mas_right).offset(10);
    }];
    
    [self.min_bg_lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(min_W);
        make.top.equalTo(self.min_bg_lab1.mas_bottom).offset(10);
        make.left.equalTo(self.min_bg_image.mas_left).offset(10);
        make.bottom.equalTo(self.min_bg_image.mas_bottom).offset(-12);
    }];
    [self.min_bg_lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(min_W);
        make.centerY.equalTo(self.min_bg_lab3);
        make.left.equalTo(self.min_bg_lab3.mas_right).offset(10);
    }];
    
    
    self.center_view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.center_view.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
    self.center_view.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
    self.center_view.layer.shadowRadius = 3;// 阴影半径，默认3
    self.center_view.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    self.center_view.layer.cornerRadius = 10;
    
    
    double center_W = (DEVICE_WIDTH - 60) / 3;
    
    [self.center_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH - 20);
        make.top.equalTo(self.min_bg_image.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [self.center_view_lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(center_W);
        make.centerX.equalTo(self.center_view);
        make.top.offset(12);
    }];
    [self.center_view_lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(center_W);
        make.centerX.equalTo(self.center_view);
        make.top.equalTo(self.center_view_lab2.mas_bottom).offset(10);
        make.bottom.offset(-12);
    }];
    
    
    [self.center_view_lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(center_W);
        make.centerY.equalTo(self.center_view_lab2);
        make.right.equalTo(self.center_view_lab2.mas_left).offset(-10);
    }];
    
    [self.center_view_lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(center_W);
        make.centerY.equalTo(self.center_view_lab5);
        make.right.equalTo(self.center_view_lab5.mas_left).offset(-10);
    }];
    
    
    [self.center_view_lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(center_W);
        make.centerY.equalTo(self.center_view_lab2);
        make.left.equalTo(self.center_view_lab2.mas_right).offset(10);
    }];
    
    [self.center_view_lab6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(center_W);
        make.centerY.equalTo(self.center_view_lab5);
        make.left.equalTo(self.center_view_lab5.mas_right).offset(10);
    }];
    
    
    double max_W = (DEVICE_WIDTH - 20) / 2;
    
    [self.max_bg_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH - 20);
        make.height.offset(160);
        make.top.equalTo(self.center_view.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [self.max_bg_lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(max_W, 40));
        make.top.equalTo(self.max_bg_image.mas_top);
        make.left.equalTo(self.max_bg_image.mas_left);
    }];
    
    [self.max_bg_lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(max_W, 40));
        make.centerY.equalTo(self.max_bg_lab1);
        make.left.equalTo(self.max_bg_lab1.mas_right);
    }];
    
    [self.max_bg_lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(max_W, 40));
        make.top.equalTo(self.max_bg_lab1.mas_bottom);
        make.left.equalTo(self.max_bg_image.mas_left);
    }];
    
    [self.max_bg_lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(max_W, 40));
        make.centerY.equalTo(self.max_bg_lab3);
        make.left.equalTo(self.max_bg_lab3.mas_right);
    }];
    
    [self.max_bg_lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(max_W, 40));
        make.top.equalTo(self.max_bg_lab3.mas_bottom);
        make.left.equalTo(self.max_bg_image.mas_left);
    }];
    
    [self.max_bg_lab6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(max_W, 40));
        make.centerY.equalTo(self.max_bg_lab5);
        make.left.equalTo(self.max_bg_lab5.mas_right);
    }];
    
    [self.max_bg_lab7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(max_W, 40));
        make.top.equalTo(self.max_bg_lab5.mas_bottom);
        make.left.equalTo(self.max_bg_image.mas_left);
    }];
    
    [self.max_bg_lab8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(max_W, 40));
        make.centerY.equalTo(self.max_bg_lab7);
        make.left.equalTo(self.max_bg_lab7.mas_right);
    }];
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
@end
