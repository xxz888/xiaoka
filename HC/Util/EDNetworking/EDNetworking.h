//
//  EDNetworking.h
//  恒创
//
//  Created by /*\ on 2020/4/14.
//  Copyright © 2020 /*\. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


///解析后的数据
typedef void (^SuccessBlock)(id responseObject);
///请求错误
typedef void (^FailureBlock)(NSString *error);

@interface EDNetworking : NSObject

//POST网络请求【返回解析数据】
+ (void)PostWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock __nullable)success failure:(FailureBlock __nullable)failure;

//POST请求 省 市
+ (void)PostWithAddressURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock __nullable)success failure:(FailureBlock __nullable)failure;

//POST上传图片
+ (void)PostWithImageURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock __nullable)success failure:(FailureBlock __nullable)failure;

@end

NS_ASSUME_NONNULL_END
