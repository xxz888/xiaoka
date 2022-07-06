//
//  liveness.h
//  liveness
//
//  Created by apple on 2019/8/13.
//  Copyright © 2019年 ymt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol LivenessDetectDelegate <NSObject>

- (void) onLiveDetectCompletion:(NSDictionary*)result;

@end

@interface Liveness : NSObject

@property (nonatomic,strong,readonly) NSArray *liveDetectValueCache;
@property (nonatomic,assign,readonly) NSInteger LiveDetectionNum;

@property (nonatomic, assign) BOOL isRandom;
@property (nonatomic, strong) NSArray *liveDetectArr;

//获取实例对象
+ (id)shareInstance;

- (void)startProcess:(UIViewController *)viewController withParam:(NSDictionary*)param withDelegate:(id<LivenessDetectDelegate>)delegate;

- (NSString *)getLibVersion;

@end

