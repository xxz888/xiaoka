//
//  MCAccreditation1ViewController.m
//  AFNetworking
//
//  Created by apple on 2020/10/30.
//

#import "MCAccreditation1ViewController.h"
#import "MCProtocolViewController.h"

@interface MCAccreditation1ViewController ()

@property(strong , nonatomic) UIView *navigation_View;
@property(strong , nonatomic) UIButton *nav_back;

@end

@implementation MCAccreditation1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    
    
    [self.selectBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];

    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.userXieYiLbl.text];
    NSRange range1 = [[str string] rangeOfString:@"《用户信息授权协议》"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:range1];
    self.userXieYiLbl.attributedText = str;
    
    //创建手势 使用initWithTarget:action:的方法创建
    self.userXieYiLbl.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickUserXieYiLbl:)];
    //别忘了添加到testView上
    [self.userXieYiLbl addGestureRecognizer:tap];
    
    self.agreeBtn.selected = NO;
    
    [self AddViewType:self.center_view];
    
    if (kStatusBarHeight != 20) {
        self.top_view_hight.constant = Ratio(200);
    }
    
    self.navigation_View = [[UIView alloc] init];
    [self.view addSubview:self.navigation_View];
    
    [self.navigation_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44));
        make.top.equalTo(self.view.mas_top).offset(kStatusBarHeight);
        make.left.equalTo(self.view);
    }];
    self.nav_back = [[UIButton alloc]init];
    [self.nav_back setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self.nav_back addTarget:self action:@selector(backfanhuiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigation_View addSubview:self.nav_back];
    [self.nav_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.centerY.equalTo(self.navigation_View);
    }];
    
}
- (void)backfanhuiAction{
    [self.xp_rootNavigationController popViewControllerAnimated:YES];
}
-(void)clickUserXieYiLbl:(id)sender{
    MCProtocolViewController * vc = [MCProtocolViewController new];
    vc.whereCome = @"2";
    [self.xp_rootNavigationController pushViewController:vc animated:YES];
}

#pragma mark ---------选择勾选的按钮---------
- (IBAction)selectAction:(id)sender {
    [self.selectBtn setSelected:!self.selectBtn.selected];
    [self.agreeBtn setBackgroundImage:self.selectBtn.selected ?
    [UIImage imageNamed:@"KD_BindCardBtn"] : [UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [self.agreeBtn setBackgroundColor:self.selectBtn.selected ?
    [UIColor whiteColor] : [UIColor colorWithHexString:@"CDCDCD"]];
    
    
//    CDCDCD
    self.agreeBtn.userInteractionEnabled = self.selectBtn.selected;
}
#pragma mark ---------同意到下一步的按钮---------
- (IBAction)agreeAction:(id)sender {
    
    [self.xp_rootNavigationController pushViewController:[MCAccreditation2ViewController new] animated:YES];
    
}
#pragma 给view添加同意样式
- (void)AddViewType:(UIView *)views{
    views.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    views.layer.shadowColor = [UIColor colorWithRed:61/255.0 green:46/255.0 blue:35/255.0 alpha:0.05].CGColor;
    views.layer.shadowOffset = CGSizeMake(0,4);
    views.layer.shadowOpacity = 1;
    views.layer.shadowRadius = 6;
    views.layer.cornerRadius = 23;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

@end
