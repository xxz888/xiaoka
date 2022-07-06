//
//  UIDevice+YL.m
//  Photo
//
//  Created by yuanlue123 on 2021/8/16.
//

#import "UIDevice+YL.h"

#import <sys/utsname.h>

#import "AppDelegate.h"


@implementation UIDevice (YL)

+ (UIWindow *)currentWindow {
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate.window;
}

+ (CGFloat)statusBarHeight {
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
        if ([self isIphone12Mini]) {
            statusBarHeight = 50;
        }else {
            if ([UIApplication sharedApplication].statusBarHidden) {
                statusBarHeight = HX_IS_IPhoneX_All ? 44: 20;
            }
        }
    }
    else {
        if ([UIApplication sharedApplication].statusBarHidden) {
            statusBarHeight = HX_IS_IPhoneX_All ? 44: 20;
        }else {
            statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    }
    return statusBarHeight;
}

+ (BOOL)isIphone12Mini {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if([platform isEqualToString:@"iPhone13,1"]) {
        return YES;
    }else if ([platform isEqualToString:@"x86_64"] || [platform isEqualToString:@"i386"]) {
        if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !HX_UI_IS_IPAD : NO)) {
            return YES;
        }
    }
    return NO;
}

+ (CGFloat)bottomSafeHeight {
    
    if ([self isPhoneX]) {
        return 36;
    }
    return 0;
}

+ (BOOL)isPhoneX {
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return NO;
    }
    
    if (@available(iOS 11.0, *)) {
        if ([self currentWindow].safeAreaInsets.bottom > 0) {
            return YES;
        }
    } else {
        
        if (![[UIApplication sharedApplication] isStatusBarHidden] && UIApplication.sharedApplication.statusBarFrame.size.height> 20) {
            return YES;
        }
    }
    
    return NO;
}


/// 获取App现有版本号
+ (NSString *)getAppVersionCode {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}


///  获取App展示版本号
+ (NSString *)getAppVersionName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getAppName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}


@end
