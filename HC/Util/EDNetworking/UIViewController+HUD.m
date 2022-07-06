//
//  UIViewController+HUD.m
//  恒创
//
//  Created by /*\ on 2020/4/14.
//  Copyright © 2020 /*\. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "EDNetworking.h"
#import "MBProgressHUD.h"
#import "BaseViewController.h"


@implementation UIViewController (HUD)

- (void)Show{
    [MBProgressHUD showHUDAddedTo:[UIDevice currentWindow] animated:YES];
}

- (void)dismiss{
    [MBProgressHUD hideHUDForView:[UIDevice currentWindow] animated:YES];
}


///POST网络请求【返回解析数据】
- (void)NetWorkingPostWithURL:(UIViewController *)Controller hiddenHUD:(BOOL)hidden url:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    if (!hidden) {
        [self Show];
    }
    [EDNetworking PostWithURL:url Params:params success:^(id  _Nonnull responseObject) {
        [self dismiss];
        if([responseObject[@"code"] intValue] == 5){
            [[BaseViewController new] 登陆过期];
        }else{
            success(responseObject);
        }
        
    } failure:^(NSString * _Nonnull error) {
        [self dismiss];
        [XHToast showBottomWithText:error duration:2];
        failure(error);
    }];
}

///POST网络请求 非json【返回解析数据】
- (void)NetWorkingPostWithAddressURL:(UIViewController *)Controller hiddenHUD:(BOOL)hidden url:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    if (!hidden) {
        [self Show];
    }
    [EDNetworking PostWithAddressURL:url Params:params success:^(id  _Nonnull responseObject) {
        
        [self dismiss];
        
        if([responseObject[@"code"] intValue] == 5){
            [[BaseViewController new] 登陆过期];
        }else{
            success(responseObject);
        }
    } failure:^(NSString * _Nonnull error) {
        [self dismiss];
        [XHToast showBottomWithText:error duration:2];
        failure(error);
    }];
}
///POST上传图片 单张
- (void)NetWorkingPostWithImageURL:(UIViewController *)Controller hiddenHUD:(BOOL)hidden url:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    if (!hidden) {
        [self Show];
    }
    
    [EDNetworking PostWithImageURL:url Params:params success:^(id  _Nonnull responseObject) {
        
        [self dismiss];
        
        if([responseObject[@"code"] intValue] == 5){
            [[BaseViewController new] 登陆过期];
        }else{
            success(responseObject);
        }
    } failure:^(NSString * _Nonnull error) {
        [self dismiss];
        [XHToast showBottomWithText:error duration:2];
        failure(error);
    }];
}



@end
