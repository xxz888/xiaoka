//
//  UIColor+Hex.h
//  jifenzhi
//
//  Created by 郭龙波 on 16/3/9.
//  Copyright © 2016年 郭龙波. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

#define KHexColor(string) [UIColor colorWithHexString:string]

@interface UIColor (Hex)
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
/// 创建颜色对
/// @param lightColor iOS13以下的系统显示的颜色或未开启深色模式下显示的颜色
/// @param darkColor 深色模式下显示的颜色
+ (UIColor *) colorPairsWithLightColor:(UIColor *) lightColor darkColor:(UIColor *) darkColor;
@end
