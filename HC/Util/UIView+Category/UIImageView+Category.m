//
//  UIImageView+Category.m
//  XQDQ
//
//  Created by lh on 2021/9/18.
//

#import "UIImageView+Category.h"

@implementation UIImageView (Category)

+ (instancetype)getUIImageView:(NSString *)imageName{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    
    return imageView;
}

@end
