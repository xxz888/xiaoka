//
//  EDNetworking.m
//  恒创
//
//  Created by /*\ on 2020/4/14.
//  Copyright © 2020 /*\. All rights reserved.
//

#import "EDNetworking.h"
#import "AFHTTPSessionManager.h"


#import <MJExtension/MJExtension.h>

@implementation EDNetworking

//POST请求
+ (void)PostWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock __nullable)success failure:(FailureBlock __nullable)failure{
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;
    
    url = [ApiUrl stringByAppendingString:url];
    //如果你不需要将通过body传 那就参数放入parameters里面
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];

    request.timeoutInterval= 20;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //写入token
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserData = [standardDefaults objectForKey:@"UserData"];
    if(UserData != nil){
        //添加请求头
        [request setValue:UserData[@"token"] forHTTPHeaderField:@"token"];
    }
    [request setValue:@"ios" forHTTPHeaderField:@"platform"];
    //app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString  *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [request setValue:app_Version forHTTPHeaderField:@"version"];
    
    // 设置body 在这里将参数放入到body
    [request setHTTPBody:[params mj_JSONData]];
    
    
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response,id responseObject,NSError *error){
        
        
        if(responseObject != nil ){
            //数据解析
            NSString *str1 = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSString * receiveStr = [str1 stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
            
            NSData * datas = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
            if ([[dataDic allKeys] containsObject:@"status"]) {
                if ([dataDic[@"status"] intValue] == 500){
                    failure(@"服务器无响应");
                    return;
                }
            }
            
            success(dataDic);
        }else{
            failure(@"服务器无响应");
        }
    }]resume];
}



//POST请求 非json
+ (void)PostWithAddressURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock __nullable)success failure:(FailureBlock __nullable)failure{
    
    
    url = [ApiUrl stringByAppendingString:url];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //写入token
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserData = [standardDefaults objectForKey:@"UserData"];
    if(UserData != nil){
        //添加请求头
        [manager.requestSerializer setValue:UserData[@"token"] forHTTPHeaderField:@"token"];
    }
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"platform"];
    //app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString  *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"version"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];

    [manager POST:url parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject != nil){
                if ([[responseObject allKeys] containsObject:@"status"]) {
                    if ([responseObject[@"status"] intValue] == 500){
                        failure(@"服务器无响应");
                        return;
                    }
                }

                NSString * receiveStr = [[self dictionaryToJson:responseObject] stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
                NSData * datas = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
                
                success(dataDic);
            }else{
                failure(@"服务器无响应");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(@"服务器无响应");
        }];
    
}
#pragma mark 字典转化字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


//POST上传图片
+ (void)PostWithImageURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock __nullable)success failure:(FailureBlock __nullable)failure{
    
    url = [ApiUrl stringByAppendingString:url];
    //写入token
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserData = [standardDefaults objectForKey:@"UserData"];
    if (UserData != nil) {
        UIImage *image = params[@"file"];
 
        AFHTTPSessionManager * sessionManager = [AFHTTPSessionManager manager];
        // 设置请求超时时间
        sessionManager.requestSerializer.timeoutInterval = 20;
        //请求的序列化
        sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html", nil];
        //添加请求头
        [sessionManager.requestSerializer setValue:UserData[@"token"] forHTTPHeaderField:@"token"];
        [sessionManager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"platform"];
        //app版本
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString  *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        [sessionManager.requestSerializer setValue:app_Version forHTTPHeaderField:@"version"];
        
        [sessionManager POST:url parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString * fileName = [NSString stringWithFormat:@"sfz.jpg"];
            //将UIImage转为NSData，1.0表示不压缩图片质量。
            NSData *data = [self compressImageDataWithMaxLimit:0.2 images:[self compressImageWith:image]];
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //打印下上传进度
            NSLog(@"上传完成比率：%f",uploadProgress.fractionCompleted * 100);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSError * err = nil;
            //数据解析
            NSString *result =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData * datas = [result dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary * data = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
            NSMutableDictionary * data= [NSJSONSerialization JSONObjectWithData:datas options:0 error:&err];
            //上传结束
            success(data);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(@"服务未响应,请重试！");
        }];
        
    }
    
}

+ (UIImage *)compressImageWith:(UIImage *)image{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = 640;
    float height = image.size.height/(image.size.width/width);
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSData *)compressImageDataWithMaxLimit:(CGFloat)maxLimit images:(UIImage *)image{
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.2f; // 最大压缩品质
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    NSInteger imageDataLength = [imageData length];
    while ((imageDataLength <= maxLimit * 1000 * 1000) && (compression >= maxCompression)) {
        compression -= 0.03;
        imageData = UIImageJPEGRepresentation(image, compression);
        imageDataLength = [imageData length];
    }
    return imageData;
}

@end
