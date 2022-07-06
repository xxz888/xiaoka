//
//  LabelScrollView.h
//  向上文字轮播
//
//  Created by bug neo on 2018/8/9.
//  Copyright © 2018年 bug neo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LabelScrollViewBlock)(NSString *str);

@interface LabelScrollView : UIView
@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)showNext;
- (void)removeTimer;
- (void)addTimer;

@property (nonatomic , strong) LabelScrollViewBlock block;

@end
