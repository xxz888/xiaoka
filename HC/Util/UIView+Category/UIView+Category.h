//
//  UIView+Category.h
//  XQDQ
//
//  Created by lh on 2021/9/18.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface UIView (Category)<CAAnimationDelegate>

@property(nonatomic, assign) CGFloat ylCornerRadius;
#pragma 部分圆角
- (void)getPartOfTheCornerRadius:(CGRect)frame CornerRadius:(CGFloat)radius UIRectCorner:(UIRectCorner)corner;

#pragma 给view添加同意样式
- (void)AddViewTypeRadius:(NSInteger)Radius;

#pragma 截屏View
-(UIImage *)captureImageFromView:(UIView *)view;

#pragma 设置阴影
- (void)setViewTypeshadow;

@end

NS_ASSUME_NONNULL_END
