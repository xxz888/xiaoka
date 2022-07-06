//
//  NSString+Category.h
//  House
//
//  Created by apple on 2021/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Category)
/**
 /将秒转换为时间,含天数
 */
+ (NSString *)secondTransToDate:(NSInteger)totalSecond;

/**
 判断字符串为空
 */
+ (BOOL)isBlankString:(NSString *)aStr;
/**
 去掉空格
 */
- (NSString *)RemoveTheBlankSpace:(NSString *)spaceStr;

/**
 姓名的隐藏

 @param name 姓名
 @return N* N*N N**N  N***N
 */
- (NSString *)getNameEncryption:(NSString *)name;


/**
 姓名的长度

 @param name 姓名
 @return 超过4位后面显示*
 */
- (NSString *)getNamelength:(NSString *)name;

/**
 整10判断

 @param digital 数字字符串  判断整数字符串最后一位为0
 @return yes则为整10
 */
+ (BOOL)isTheWholeTen:(NSString *)digital;
/**
 电话号码中间4位*显示

 @param phoneNum 电话号码
 @return 135*****262
 */
+ (NSString*) getSecrectStringWithPhoneNumber:(NSString*)phoneNum;
/**
 身份证号隐藏

 @param startLocation 长度
 @param length 长度
 @return 500 *******1234
 */
- (NSString *)replaceStringWithAsterisk:(NSInteger)startLocation length:(NSInteger)length;
/**
 银行卡号中间8位*显示

 @param accountNo 银行卡号
 @return 银行卡号中间8位*显示
 */
+ (NSString*) getSecrectStringWithAccountNo:(NSString*)accountNo;


/**
 转为手机格式，默认为 -
 
 @param mobile 电话
 @return 转为手机格式，默认为-
 */
+ (NSString*) stringMobileFormat:(NSString*)mobile;

//数组中文格式（几万）可自行添加

/**
 金额数字添加单位（暂时写了万和亿，有更多的需求请参考写法来自行添加）
 
 @param value 金额
 @return 金额数字添加单位
 */
+ (NSString*) stringChineseFormat:(double)value;


/**
 添加数字的千位符

 @param num 数字
 @return 数字的千位符
 */
+ (NSString*) countNumAndChangeformat:(NSString *)num;

/**
 *  NSString转为NSNumber
 *
 *  @return NSNumber
 */
- (NSNumber*) toNumber;

/**
 计算文字高度
 
 @param fontSize 字体
 @param width 最大宽度
 @return 计算文字高度
 */
- (CGFloat)heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width;

/**
 计算文字宽度

 @param fontSize 字体
 @param maxHeight 最大高度
 @return 计算文字宽度
 */
- (CGFloat)widthWithFontSize:(CGFloat)fontSize height:(CGFloat)maxHeight;
/**
 抹除小数末尾的0

 @return 抹除小数末尾的0
 */
- (NSString*) removeUnwantedZero;

/**
 //去掉前后空格

 @return 去掉前后空格
 */
- (NSString*) trimmedString;

/// Base64加密
/// @param string 加密字符串
+ (NSString *)base64EncodeString:(NSString *)string;

/// Base64解密
/// @param string 解密字符串
+ (NSString *)base64DecodeString:(NSString *)string;

/// 计算文字高度
/// @param value 文字内容
/// @param fontSize 字体大小
/// @param width 宽度
+ (CGFloat) heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width;

/// 计算文字宽度
/// @param value 文字内容
/// @param fontSize 字体大小
/// @param hight 高度
+ (CGFloat) widthForString:(NSString *)value fontSize:(CGFloat)fontSize andHight:(CGFloat)hight;

/// 手机号
- (BOOL)SJZL_isPhone;


/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  添加行间距并返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 *  @param lineSpaceing 行间距
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize andlineSpacing:(CGFloat) lineSpaceing;

/**
 *  MD5加密 32位 大写
 *
 *  @param str    加密字符串
 */
+ (NSString *)MD5ForUpper32Bate:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
