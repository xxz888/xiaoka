//
//  KisZDYPickerView.h
//  FaSoft
//
//  Created by 郭龙波 on 2019/10/31.
//  Copyright © 2019 0-0. All rights reserved.
//
///自定义PickerView
#import <UIKit/UIKit.h>


typedef void (^ZDYPickerViewBlock)(NSDictionary * startDic,NSDictionary *endDic);

@interface KisZDYPickerView : UIView
///左侧数据源
@property (nonatomic , strong) NSArray *LeftArray;
///右侧数据源
@property (nonatomic , strong) NSArray *RightArray;

- (void)show;

@property (nonatomic , copy) ZDYPickerViewBlock Block;


//省/直辖市
@property (nonatomic , strong) NSString *provinceAddress;
//市
@property (nonatomic , strong) NSString *cityAddress;


//刷卡查询城市，要传channelId，制定计划时，查询城市，不传channelId  通道ID
@property (nonatomic , strong) NSString *channelId;

@end
