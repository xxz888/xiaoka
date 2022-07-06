//
//  UIViewController+BackButtonHandler.h
//
//  Created by Sergey Nikitenko on 10/1/13.
//  Copyright 2013 Sergey Nikitenko. All rights reserved.
//
/**
 用法:导入头文件+调用 -(BOOL)navigationShouldPopOnBackButton;
 */

#import <UIKit/UIKit.h>
#import <objc/runtime.h>


@protocol BackButtonHandlerProtocol <NSObject>

@optional

//返回yes跳转 No不跳转
-(BOOL)navigationShouldPopOnBackButton;

@end

@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>

@end
