//
//  TabBarController.m
//  HC
//
//  Created by tuibao on 2021/11/8.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    }
    
    self.viewControllers = viewControllers;
    
    
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];

    if (@available(iOS 13.0, *)) {
            self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorWithHexString:@"#666666"];//未选中时文字颜色
            self.tabBarController.tabBar.tintColor = [UIColor blackColor];//选中时文字颜色
    } else {
            [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
            [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#666666"]} forState:UIControlStateNormal];
    }
    
}



@end
