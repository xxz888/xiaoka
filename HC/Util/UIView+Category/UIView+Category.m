//
//  UIView+Category.m
//  XQDQ
//
//  Created by lh on 2021/9/18.
//

#import "UIView+Category.h"

@implementation UIView (Category)


- (void)setYlCornerRadius:(CGFloat)ylCornerRadius{
    
    self.layer.cornerRadius = ylCornerRadius;
    self.clipsToBounds = YES;
}
-(CGFloat)ylCornerRadius{
    return self.layer.cornerRadius;
}
- (void)setViewTypeshadow{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
    self.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
    self.layer.shadowRadius = 3;// 阴影半径，默认3
    self.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    self.layer.cornerRadius = 10;
}
///部分圆角
- (void)getPartOfTheCornerRadius:(CGRect)frame CornerRadius:(CGFloat)radius UIRectCorner:(UIRectCorner)corner{
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

#pragma 给view添加同意样式
- (void)AddViewTypeRadius:(NSInteger)Radius{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:61/255.0 green:46/255.0 blue:35/255.0 alpha:0.05].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,4);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 6;
    self.layer.cornerRadius = Radius;
}


//截图功能
-(UIImage *)captureImageFromView:(UIView *)view{
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size,NO, 0);
    [[UIColor clearColor] setFill];
    [[UIBezierPath bezierPathWithRect:view.bounds] fill];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


