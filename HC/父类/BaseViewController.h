//
//  BaseViewController.h
//  XQDQ
//
//  Created by lh on 2021/9/16.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : ViewController



///得到个人信息
- (NSDictionary *)loadUserData;
///更新个人信息
- (void)updateUserData:(NSDictionary *)data;
///得到超级会员信息
- (NSDictionary *)loadSuperMembersData;
///更新超级会员信息
- (void)updateSuperMembersData:(NSDictionary *)data;

///获取指定 key 的缓存数据
- (NSDictionary *)getToObtainTheSpecified:(NSString *)key;
///更新指定 key 的缓存数据
- (void)updateToObtainTheSpecified:(NSString *)key Data:(NSDictionary *)data;


//实名认证判断
- (BOOL)RealNameAuthentication;
//调用开启相机权限
- (BOOL)CameraPermissions;

- (void)登陆过期;

- (BOOL)去登录;

#pragma 冒泡排序 大的在前
- (void)setBubbleSortArray:(NSMutableArray *)dataArr FieldString:(NSString *)fieldStr;

/**
 *  判断对象是否为空
 *  常见的：nil、NSNil、@""、@(0) 以上4种返回YES
 *  如果需要判断字典与数组，可以自行添加
 *  @return YES 为空  NO 为实例对象
 */
- (BOOL)isEmpty:(id)object;


#pragma mark - 获取单次定位地址
- (void)addLocationManager:(void(^)(NSString *province,NSString *city))backname;

/*
 * 获取省份
 * provinceCode:省/直辖市编码
 * cityCode:市编码
 * isThan:是否匹配成功 yes为成功 no为失败
 */
- (void)getAddressThan:(NSString *)province City:(NSString *)city isThan:(void(^)(NSString *provinceCode,NSString *cityCode,BOOL isThan))backname;



/**
 *   samllNum:  两数中的最小值
 *   bigNum: 两数中的最大值
 *   precision: 精度值，如：精确1位小数，precision参数值为10； 两位小数precision参数值为100；
 */
- (float)randomBetween:(float)smallNum AndBigNum:(float)bigNum AndPrecision:(NSInteger)precision;

@end

NS_ASSUME_NONNULL_END
