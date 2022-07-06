//
//  BaseViewController.m
//  XQDQ
//
//  Created by lh on 2021/9/16.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CLLocationManager.h>
@interface BaseViewController ()<AMapLocationManagerDelegate>

@property (nonatomic , assign) BOOL isAlert;

@property (nonatomic, strong) AMapLocationManager *LocationManager;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTranslucent:false];
    self.isAlert = NO;
}

///得到个人信息
- (NSDictionary *)loadUserData{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserData = [standardDefaults objectForKey:@"UserData"];
    return UserData;
}
///更新个人信息
- (void)updateUserData:(NSDictionary *)data{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *UserData = [NSMutableDictionary dictionaryWithDictionary:[standardDefaults objectForKey:@"UserData"]];

    [UserData addEntriesFromDictionary:data];
    [standardDefaults setObject:UserData forKey:@"UserData"];
    [standardDefaults synchronize];//写完别忘了同步
}
///得到超级会员信息
- (NSDictionary *)loadSuperMembersData{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserData = [standardDefaults objectForKey:@"SuperMembers"];
    return UserData;
}
///更新超级会员信息
- (void)updateSuperMembersData:(NSDictionary *)data{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *UserData = [NSMutableDictionary dictionaryWithDictionary:[standardDefaults objectForKey:@"SuperMembers"]];

    [UserData addEntriesFromDictionary:data];
    [standardDefaults setObject:UserData forKey:@"SuperMembers"];
    [standardDefaults synchronize];//写完别忘了同步
}


///获取指定 key 的缓存数据
- (NSDictionary *)getToObtainTheSpecified:(NSString *)key{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserData = [standardDefaults objectForKey:key];
    return UserData;
}
///更新指定 key 的缓存数据
- (void)updateToObtainTheSpecified:(NSString *)key Data:(NSDictionary *)data{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *UserData = [NSMutableDictionary dictionaryWithDictionary:[standardDefaults objectForKey:key]];

    [UserData addEntriesFromDictionary:data];
    [standardDefaults setObject:UserData forKey:key];
    [standardDefaults synchronize];//写完别忘了同步
}


//实名认证判断
- (BOOL)RealNameAuthentication{
    // 得到个人信息，判断token
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserData = [standardDefaults objectForKey:@"UserData"];
    if (UserData != nil && [UserData[@"selfLevel"] intValue] == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的帐号还未实名，是否立即去实名？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"暂不实名" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"去实名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            MCAccreditation1ViewController *vc = [MCAccreditation1ViewController new];
            [self.xp_rootNavigationController pushViewController:vc animated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }else{
        return YES;
    }
}

//调用开启相机权限
- (BOOL)CameraPermissions{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusNotDetermined || authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        
        // 授权受阻
        UIAlertController *alterCon = [UIAlertController alertControllerWithTitle:@"是否开启相机访问权限？"
                                                                          message:nil
                                                                   preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OFF = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *ON = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) { // 设置权限
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    // do something
                }];
            }
        }];
        [alterCon addAction:OFF];
        [alterCon addAction:ON];
        [[UIViewController currentViewController] presentViewController:alterCon animated:YES completion:nil];
        return NO;
    } else { // 已开启
        // do something
        return YES;
    }
}


- (void)登陆过期{
    
    if (!self.isAlert) {
        self.isAlert = YES;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"登陆过期,请重新登录" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.isAlert = NO;
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.isAlert = NO;
            //退出到登录页
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            HCLoginViewController *loginView = [[HCLoginViewController alloc]init];
            XPRootNavigationController *navi = [[XPRootNavigationController alloc]initWithRootViewController:loginView];
            delegate.window.rootViewController = navi;
        }]];
        [[UIViewController currentViewController] presentViewController:alert animated:YES completion:^{}];
    }
    
}
- (BOOL)去登录{
    
    // 得到个人信息，判断token
    NSDictionary *UserData = [self loadUserData];
    if ([UserData allKeys].count == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请登录" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"去登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            HCLoginViewController *VC = [HCLoginViewController new];
            
            [self.xp_rootNavigationController pushViewController:VC animated:YES];
            
        }]];
        [[UIViewController currentViewController] presentViewController:alert animated:YES completion:^{}];
        return NO;
    }
    return YES;
}
#pragma 冒泡排序 大的在前
- (void)setBubbleSortArray:(NSMutableArray *)dataArr FieldString:(NSString *)fieldStr{
    for (int i = 0; i < [dataArr count] ; i++) {
        for (int j = 0; j < [dataArr count] - i - 1; j++) {
            if ([dataArr[j][fieldStr] doubleValue] < [dataArr[j+1][fieldStr] doubleValue]) {
                NSDictionary *temp = dataArr[j];
                dataArr[j] = dataArr[j+1];
                dataArr[j+1] = temp;
            }
        }
    }
}

- (BOOL)isEmpty:(id)object{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        return [object isEqualToString:@""];
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [object isEqualToNumber:@(0)];
    }
    return NO;
}

#pragma mark - 获取单次定位地址 返回
- (void)addLocationManager:(void(^)(NSString *province,NSString *city))backname{
    
    // ios14 需要用户同意隐私政策
    [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        //定位功能可用
    }
    else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请打开APP定位权限" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
        }];
        //修改按钮字体颜色
        [sureAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [AMapServices sharedServices].apiKey = AMaPAppKey;
    self.LocationManager = [[AMapLocationManager alloc] init];
    self.LocationManager.delegate = self;
    if (@available(iOS 14.0, *)) {
        self.LocationManager.locationAccuracyMode = AMapLocationFullAndReduceAccuracy;
    } else {
        // Fallback on earlier versions
    }
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.LocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低5s，此处设置为5s
    self.LocationManager.locationTimeout =5;
    //   逆地理请求超时时间，最低5s，此处设置为5s
    self.LocationManager.reGeocodeTimeout = 5;
    
    [self.LocationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error){
            if (error.code == AMapLocationErrorLocateFailed){
                [XHToast showBottomWithText:@"定位失败，请手动选择"];
                return;
            }
        }
        if (regeocode){
            //处理直辖市
            NSString *province = regeocode.province;
            if([province containsString:@"市"]){
                province = [province stringByReplacingOccurrencesOfString:@"市" withString:@""];
            }
            backname(province,regeocode.city);
        }
    }];
    
}
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager{
    [locationManager requestAlwaysAuthorization];
}




/*
 * 获取省份
 * provinceCode:省/直辖市编码
 * cityCode:市编码
 * isThan:是否匹配成功 yes为成功 no为失败
 */
- (void)getAddressThan:(NSString *)province City:(NSString *)city isThan:(void(^)(NSString *provinceCode,NSString *cityCode,BOOL isThan))backname{
    [self NetWorkingPostWithAddressURL:[UIViewController currentViewController] hiddenHUD:YES url:@"/api/payment/province/list" Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            
            NSArray *array = [NSArray arrayWithArray:responseObject[@"data"]];
            for(int i = 0 ; i < array.count ; i++){
                
                NSDictionary *provinceDic = array[i];
                if ([provinceDic[@"name"] containsString:[province substringToIndex:2]]) {
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setValue:provinceDic[@"id"] forKey:@"parent"];
                    
                    [self NetWorkingPostWithAddressURL:self hiddenHUD:YES url:@"/api/payment/city/list" Params:params success:^(id  _Nonnull responseObject) {
                        if ([responseObject[@"code"] intValue] == 0) {
                            NSArray *array = [NSArray arrayWithArray:responseObject[@"data"]];
                            BOOL isThan = NO;
                            NSDictionary *cityDic = [NSDictionary dictionary];
                            for(NSDictionary *dic in array){
                                if ([dic[@"name"] containsString:city]) {
                                    cityDic = dic;
                                    isThan = YES;
                                }
                            }
                            backname(provinceDic[@"id"],cityDic[@"id"],isThan);
                        }else{
                            backname(@"",@"",NO);
                            [XHToast showCenterWithText:responseObject[@"message"]];
                        }
                    } failure:^(NSString * _Nonnull error) {
                        backname(@"",@"",NO);
                    }];
                }
            }
        }else{
            [XHToast showCenterWithText:responseObject[@"message"]];
            backname(@"",@"",NO);
        }
    } failure:^(NSString * _Nonnull error) {
        backname(@"",@"",NO);
    }];
    
}


/**
 *   samllNum:  两数中的最小值
 *   bigNum: 两数中的最大值
 *   precision: 精度值，如：精确1位小数，precision参数值为10； 两位小数precision参数值为100；
 */
- (float)randomBetween:(float)smallNum AndBigNum:(float)bigNum AndPrecision:(NSInteger)precision{
    //求两数之间的差值
    float subtraction = bigNum - smallNum;
    //取绝对值
    subtraction = ABS(subtraction);
    //乘以精度的位数
    subtraction *= precision;
    //在差值间随机
    float randomNumber = arc4random() % ((int) subtraction + 1);
    //随机的结果除以精度的位数
    randomNumber /= precision;
    //将随机的值加到较小的值上
    float result = MIN(smallNum, bigNum) + randomNumber;
    //返回结果
    return result;
}
@end
