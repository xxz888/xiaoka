//
//  UISegmentedControl+Style.h
//  HC
//
//  Created by tuibao on 2021/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISegmentedControl (Style)

/// UISegmentedControl 将iOS13风格转化成iOS12之前的风格样式
- (void)ensureiOS12Style;

@end

NS_ASSUME_NONNULL_END
