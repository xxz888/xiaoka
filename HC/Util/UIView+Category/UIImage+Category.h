//
//  PK-ios
//
//  Created by peikua on 15/9/15.
//  Copyright (c) 2015年 peikua. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Category)


/**
 *  生成二维码
 *  targetString   二维码URL
 *  logoImage     二维码logo
 */
+ (UIImage *)createQRCodeWithTargetString:(NSString *)targetString logoImage:(UIImage *)logoImage;

//保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image
                                       size:(CGSize)asize;


/**
 *  保持宽高比设置图片在多大区域显示
 */
+ (UIImage *)sourceImage:(UIImage *)sourceImage
              targetSize:(CGSize)targetSize;

/**
 *  指定宽度按比例缩放
 */
- (UIImage *)sourceImage:(UIImage *)sourceImage
             targetWidth:(CGFloat)targetWidth;

/**
 *  等比例缩放
 */
- (UIImage *)sourceImage:(UIImage *)sourceImage
                   scale:(CGFloat)scale;


+ (UIImage *)resizableImageWithImageName:(NSString *)imageName;





/** 压缩图片到指定的物理大小，单位M*/
- (NSData *)compressImageDataWithMaxLimit:(CGFloat)maxLimit;

- (UIImage *)compressImageWithMaxLimit:(CGFloat)maxLimit;


/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param name 图片名字
 */
+ (UIImage *)resizableImageONE:(NSString *)name;
/* 裁剪圆形图片 */
+ (UIImage *)clipImage:(UIImage *)image;

//由颜色生成图片
+ (UIImage *) imageWithColor:(UIColor*)color;

//将图片剪裁至目标尺寸
+ (UIImage *) imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;

//图片旋转角度
- (UIImage *) imageRotatedByDegrees:(CGFloat)degrees;

//拉伸图片UIEdgeInsets
- (UIImage *) resizableImageTWO:(UIEdgeInsets)insets;

//拉伸图片CGFloat
- (UIImage *) imageByResizeToScale:(CGFloat)scale;

///改变一张图片的大小
+ (UIImage *)changeImageSize:(UIImage *)icon AndSize:(CGSize)size;

//放大图片CGSize
- (UIImage *) imageByResizeWithMaxSize:(CGSize)size;

//小样图图片CGSize
- (UIImage *) imageWithThumbnailForSize:(CGSize)size;

//通过Rect剪裁图片
- (UIImage *) imageByCropToRect:(CGRect)rect;

//图片增加圆角
- (UIImage *) imageByRoundCornerRadius:(CGFloat)radius;

//图片增加圆角及边框
- (UIImage *) imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;

//图片向左90度
//- (UIImage *)imageByRotateLeft90;

//图片向右90度
//- (UIImage *)imageByRotateRight90;

//图片转180度
- (UIImage *)imageByRotate180;



@end


@interface UIImage (Blur)
//玻璃化效果，这里与系统的玻璃化枚举效果一样，但只是一张图
- (UIImage *)imageByBlurSoft;

- (UIImage *)imageByBlurLight;

- (UIImage *)imageByBlurExtraLight;

- (UIImage *)imageByBlurDark;

- (UIImage *)imageByBlurWithTint:(UIColor *)tintColor;

- (UIImage *)imageByBlurRadius:(CGFloat)blurRadius
                     tintColor:(UIColor *)tintColor
                      tintMode:(CGBlendMode)tintBlendMode
                    saturation:(CGFloat)saturation
                     maskImage:(UIImage *)maskImage;

- (UIImage *) boxblurImageWithBlur:(CGFloat)blur exclusionPath:(UIBezierPath *)exclusionPath;
@end





@interface UIImage (ImageEffects)

//图片效果

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyBlurEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;
@end
