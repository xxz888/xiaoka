//
//  HCBarnerView.h
//  KaDeShiJie
//
//  Created by tuibao on 2021/11/6.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HCBarnerViewDelegate<NSObject>
//判断点击的那个
-(void)sendImageName:(NSInteger)selectImage;

@end



@interface HCBarnerView : UIView

@property (nonatomic,weak)id<HCBarnerViewDelegate>delegate;
//传一个frame 和 装有图片名字的数组过来
//参数一：frame
//参数二：装有图片名字的数组
//参数三：BOOL如果是YES，那么自动滚动，如果是NO不滚动
-(id)initWithFrame:(CGRect)frame andImageNameArray:
(NSMutableArray * )imageNameArray andIsRunning:(BOOL)isRunning;

@end

NS_ASSUME_NONNULL_END
