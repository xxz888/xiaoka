//
//  OMGToast.h
//  yzgApp
//
//  Created by SH on 15/4/7.
//  Copyright (c) 2015年 SH. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DEFAULT_DISPLAY_DURATION 2.0f

@interface OMGToast : NSObject
{
    NSString *text;
    UIButton *contentView;
    CGFloat  duration;
}

+ (void)showWithText:(NSString *) text_;
+ (void)showWithText:(NSString *) text_
            duration:(CGFloat)duration_;

+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset_;
+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset
            duration:(CGFloat) duration_;

+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_;
+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_
            duration:(CGFloat) duration_;

@end