//
//  HCTabberController.m
//  HC
//
//  Created by tuibao on 2021/12/29.
//

#import "HCTabberController.h"

@interface HCTabberController ()<UITabBarControllerDelegate>

@end

@implementation HCTabberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self rootViewController];
    
}
#pragma --------- tabber 切换拦截 及 实名认证跳转 ------------
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0){
    
    XPRootNavigationController *navCtrl = (XPRootNavigationController *)viewController;
    UIViewController *rootCtrl = navCtrl.viewControllers.firstObject;
    
    if ([rootCtrl isKindOfClass:[HCCardPackageController class]]) {
        // 得到个人信息，判断token
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *UserData = [standardDefaults objectForKey:@"UserData"];
        if (UserData != nil && [UserData[@"selfLevel"] intValue] == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您没有实名认证" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"暂不实名" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去实名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UINavigationController *nav = tabBarController.viewControllers[tabBarController.selectedIndex];
                MCAccreditation1ViewController *vc = [MCAccreditation1ViewController new];
                [nav pushViewController:vc animated:YES];
                
            }]];
            [rootCtrl presentViewController:alert animated:YES completion:nil];
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
    
}
- (void)rootViewController{
    
    
 
    NSArray *tabClassArray = @[@"HCHomeViewController",
                               @"HCCardPackageController",
                               @"HCEarningsController",
                               @"HCMyViewController"];
    //icon
    NSArray *tabItemUnSeletedImageArray = @[@"tabbar_home_unselect",@"tabbar_cardpackage_unselect",@"tabbar_earnings_unselect",@"tabbar_my_unselect"];
    
    NSArray *tabItemSeletedImageArray = @[@"tabbar_home_select",@"tabbar_cardpackage_select",@"tabbar_earnings_select",@"tabbar_my_select"];
    //名字
    /*
     此处集中设置了controller的title
     请勿在相应的Controller中再次设置 self.title
     */
    NSArray *tabItemNamesArray = @[@"首页", @"卡包", @"收益", @"我的"];
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int index = 0; index < tabClassArray.count; index++) {
        UIViewController *contentController = [[NSClassFromString(tabClassArray[index]) alloc] initWithNibName:nil bundle:nil];
        UITabBarItem *tabbaritem = [[UITabBarItem alloc] init];
        tabbaritem.title = tabItemNamesArray[index];
        tabbaritem.image = [[UIImage imageNamed:tabItemUnSeletedImageArray[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabbaritem.selectedImage = [[UIImage imageNamed:tabItemSeletedImageArray[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //未选中字体颜色
         [tabbaritem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]} forState:UIControlStateNormal];
        //选中字体颜色
        [tabbaritem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
        
        //以下两行代码是调整image和label的位置
        tabbaritem.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
        
        [tabbaritem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
        
        //创建navigationController
        XPRootNavigationController *navigationController = [[XPRootNavigationController alloc] initWithRootViewController:contentController];
        
        navigationController.navigationController.navigationBar.translucent = YES;
        navigationController.tabBarItem = tabbaritem;
        [viewControllers addObject:navigationController];
        [self addChildViewController:navigationController];
    }
    
    
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];

    if (@available(iOS 13.0, *)) {
        self.tabBar.unselectedItemTintColor = [UIColor colorWithHexString:@"#666666"];//未选中时文字颜色
        self.tabBar.tintColor = [UIColor blackColor];//选中时文字颜色
    } else {
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#666666"]} forState:UIControlStateNormal];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //禁止单个界面侧滑返回
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
