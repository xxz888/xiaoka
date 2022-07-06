//
//  AppDelegate.m
//  HC
//
//  Created by tuibao on 2021/12/9.
//

#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>
@interface AppDelegate ()<UITabBarControllerDelegate,JPUSHRegisterDelegate,AVSpeechSynthesizerDelegate>{
    AVSpeechSynthesizer *_avSpeaker;
}

@property (strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //启用IQKeyboardManager 默认为YES
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    //键盘弹出时，点击背景，键盘收回
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    
    //notice: 3.0.0 及以后版本注册
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    }
    else{
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //方式初始化.(注:apsForProduction：0默认值表示采用的是开发证书,1表示采用生产证书发布应用.)
    [JPUSHService setupWithOption:@{} appKey:@"2e802fca44f1ae53c7019d6e" channel:@"App Store" apsForProduction:YES];
    [JPUSHService setLogOFF];
    
    // 得到个人信息，判断token
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserData = [standardDefaults objectForKey:@"UserData"];
    if ([UserData allKeys].count > 0 && ![UserData[@"username"] isEqualToString:@"17365299215"] && ![[UserData[@"preUserId"] stringValue] isEqualToString:@"236323487"]) {
        HCTabberController *tabber = [HCTabberController new];
        self.window.rootViewController = tabber;
    }else{
        // 直接进入商城
        self.window.rootViewController = [self rootViewController];
    }
    
    //通知红点
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
    //初始化语音合成器
    _avSpeaker = [[AVSpeechSynthesizer alloc] init];
    _avSpeaker.delegate = self;
    
    return YES;
}



- (UIViewController *)rootViewController{
    
    
    NSArray *tabClassArray = @[@"HCMallHomeController",@"HCMallNineController",@"HCShoppingCartController",@"HCMallMyController"];
    //icon
    NSArray *tabItemUnSeletedImageArray = @[@"mall_unselect_home",@"mall_unselect_99",@"mall_ShoppingCart_unselect",@"mall_unselect_my"];
    
    NSArray *tabItemSeletedImageArray = @[@"mall_select_home",@"mall_select_99",@"mall_ShoppingCart_select",@"mall_select_my"];
    //名字
    /*
     此处集中设置了controller的title
     请勿在相应的Controller中再次设置 self.title
     */
    NSArray *tabItemNamesArray = @[@"首页",@"9.9包邮",@"购物车",@"我的"];
    
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
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = viewControllers;
    
    
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
    

    return self.tabBarController;
}
#pragma ---------  9.0以后使用新API接口  ------------
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([resultDic[@"resultStatus"] intValue] == 9000) {
                //发出通知(刷新会员中心会员等级)
                NSNotification *LoseResponse = [NSNotification notificationWithName:@"RefreshAlipay" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:LoseResponse];
                [XHToast showBottomWithText:@"付款成功"];
            }else{
                [XHToast showBottomWithText:resultDic[@"memo"]];
            }
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}





- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  /// Required - 注册 DeviceToken
  [JPUSHService registerDeviceToken:deviceToken];
}
//注册 APNs 失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"通知错误信息: %@", error);
}


- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

#pragma 前台收到远程通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //添加提示音
        [self playFenRun:userInfo];
    }
    //需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    //UNNotificationPresentationOptionBadge
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);

}


#pragma 点击通知都执行,不管前台后台还是杀死的状态
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive || [UIApplication sharedApplication].applicationState ==  UIApplicationStateActive) {
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data setObject:userInfo[@"msg"] forKey:@"msg"];
            [data setObject:userInfo[@"title"] forKey:@"title"];
            [data setObject:userInfo[@"userId"] forKey:@"userId"];
            [data setObject:userInfo[@"createTime"] forKey:@"createTime"];
            
            XPRootNavigationController *rootNavigationController = (XPRootNavigationController *)[UIViewController currentViewController].navigationController;
            UIViewController * Controller = [rootNavigationController.viewControllers lastObject];

            HCMessageDetialController *VC = [HCMessageDetialController new];
            VC.dataDic = data;
            [Controller.xp_rootNavigationController pushViewController:VC animated:YES];
        }
    }
    //系统要求执行这个方法
    completionHandler();
}

- (void)playFenRun:(NSDictionary *)userInfo{
    // 得到个人信息，判断msgSound
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserData = [standardDefaults objectForKey:@"UserData"];
    if (![userInfo[@"userId"] isEqualToString:@"0"] && [UserData[@"msgSound"] intValue] == 1) {
        //初始化要说出的内容
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:userInfo[@"sound"]];
        //设置语速,语速介于AVSpeechUtteranceMaximumSpeechRate和AVSpeechUtteranceMinimumSpeechRate之间
        utterance.rate = 0.5;
        //设置音高,[0.5 - 2] 默认 = 1
        utterance.pitchMultiplier = 1;
        //设置音量,[0-1] 默认 = 1
        utterance.volume = 1;
        //读一段前的停顿时间
        utterance.preUtteranceDelay = 0.1;
        //读完一段后的停顿时间
        utterance.postUtteranceDelay = 0.1;
        //通过特定的语言获得声音
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        //通过voicce标示获得声音
        utterance.voice = voice;
        //开始朗读
        [_avSpeaker speakUtterance:utterance];
    }
}

@end
