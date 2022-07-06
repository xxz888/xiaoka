//
//  UIFont+Category.h
//  XQDQ
//
//  Created by lh on 2021/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Category)
//加粗
+ (instancetype)getUIFontSize:(CGFloat)size IsBold:(BOOL)isBold;
//字体样式自定义
+ (instancetype)getUIFontSize:(CGFloat)size FontType:(NSString *)typeStr;

@end

NS_ASSUME_NONNULL_END
