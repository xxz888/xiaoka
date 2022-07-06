//
//  KisZDYPickerView.m
//  FaSoft
//
//  Created by 郭龙波 on 2019/10/31.
//  Copyright © 2019 0-0. All rights reserved.
//

#import "KisZDYPickerView.h"
#define ANIMATION_DURATION   0.3f      //动画时长
@implementation UIView (Frame)

- (void)setPosition:(CGPoint)point atAnchorPoint:(CGPoint)anchorPoint
{
    CGFloat x = point.x - anchorPoint.x * self.frame.size.width;
    CGFloat y = point.y - anchorPoint.y * self.frame.size.height;
    CGRect frame = self.frame;
    frame.origin = CGPointMake(x, y);
    self.frame = frame;
}

@end

@interface KisZDYPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    UIButton *cancelButton;/**<取消按钮>*/
    UIButton *sureButton;/**<确定按钮>*/

    UIPickerView *LeftPicker;/**<zuo>*/
    UIPickerView *RightPicker;/**<结束月份>*/
    
    NSDictionary *LeftDic;
    NSDictionary *RightDic;
    
}

@property (nonatomic, strong) UIWindow *window;                     //window
@property (nonatomic, strong) UIView *blackMask;                    //黑色笼罩
@property (nonatomic, strong) UIView *windowView;                   //显示view

@end

@implementation KisZDYPickerView



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        [self addSubview:self.blackMask];

        [self.windowView setPosition:CGPointMake(0, DEVICE_HEIGHT) atAnchorPoint:CGPointZero];
        [self addSubview:self.windowView];

        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tapGR.numberOfTapsRequired = 1;
        tapGR.numberOfTouchesRequired = 1;
        [self.blackMask addGestureRecognizer:tapGR];
        LeftDic = [NSDictionary dictionary];
        RightDic = [NSDictionary dictionary];
        [self LoadUI];
        
        
        
        
        [self getAddProvince];
        
    }
    return self;
}

- (void)LoadUI{

    //取消
    cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.windowView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.width.offset(100);
        make.height.offset(46);
    }];

    sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.windowView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(0);
        make.width.offset(100);
        make.height.offset(46);
    }];

    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [self.windowView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.height.offset(0.5);
        make.centerX.equalTo(self);
        make.top.equalTo(cancelButton.mas_bottom);
    }];

    
    
    LeftPicker = [[UIPickerView alloc]init];
    LeftPicker.delegate = self;
    LeftPicker.dataSource = self;
    [self.windowView addSubview:LeftPicker];
    [LeftPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.left.offset(10);
        make.width.offset((DEVICE_WIDTH - 30)/2);
        make.bottom.offset(-10);
    }];

    RightPicker = [[UIPickerView alloc]init];
    RightPicker.delegate = self;
    RightPicker.dataSource = self;
    [self.windowView addSubview:RightPicker];
    [RightPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.right.offset(-10);
        make.width.offset((DEVICE_WIDTH - 30)/2);
        make.bottom.offset(-10);
    }];

}

- (NSArray *)LeftArray{
    if (!_LeftArray) {
        _LeftArray = [NSArray array];
    }
    return _LeftArray;
}
- (NSArray *)RightArray{
    if (!_RightArray) {
        _RightArray = [NSArray array];
    }
    return _RightArray;
}

///获取省份
- (void)getAddProvince{
    @weakify(self);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (![NSString isBlankString:self.channelId]) {
        [params setObject:self.channelId forKey:@"channelId"];
    }
    
    [[UIViewController currentViewController] NetWorkingPostWithAddressURL:[UIViewController currentViewController] hiddenHUD:NO url:@"/api/payment/province/list" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            weak_self.LeftArray = responseObject[@"data"];
            [self->LeftPicker reloadAllComponents];
            if (weak_self.LeftArray.count > 0) {
                if (self.provinceAddress.length > 0) {
                    for (int i = 0 ; i < weak_self.LeftArray.count ; i++) {
                        NSDictionary *dic = weak_self.LeftArray[i];
                        if ([dic[@"name"] isEqualToString:self.provinceAddress]) {
                            [self getAddCity:dic[@"id"]];
                            self->LeftDic = dic;
                            [self->LeftPicker selectRow:i inComponent:0 animated:YES];
                        }
                    }
                }else{
                    [self getAddCity:weak_self.LeftArray[0][@"id"]];
                    self->LeftDic =weak_self.LeftArray[0];
                    
                }
            }
        }else{
            [self hide];
            [XHToast showCenterWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        [self hide];
    }];
    
}

///获取市
- (void)getAddCity:(NSString *)parent{
    @weakify(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:parent forKey:@"parent"];

    [[UIViewController currentViewController] NetWorkingPostWithAddressURL:[UIViewController currentViewController] hiddenHUD:YES url:@"/api/payment/city/list" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            weak_self.RightArray = responseObject[@"data"];
            [self->RightPicker reloadAllComponents];
            if (weak_self.RightArray.count > 0) {
                if (self.cityAddress.length > 0) {
                    BOOL isCity = NO;
                    for (int i = 0 ; i < weak_self.RightArray.count ; i++) {
                        NSDictionary *dic = weak_self.RightArray[i];
                        if ([dic[@"name"] isEqualToString:self.cityAddress]) {
                            self->RightDic = dic;
                            [self->RightPicker selectRow:i inComponent:0 animated:YES];
                            isCity = YES;
                        }
                    }
                    if(!isCity){
                        self->RightDic =weak_self.RightArray[0];
                    }
                }else{
                    self->RightDic =weak_self.RightArray[0];
                }
                
            }else{
                self->RightDic = nil;
            }
            
        }else{
            [XHToast showCenterWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];

}





#pragma mark - pickerView的delegate方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (pickerView == LeftPicker) {
        LeftDic = _LeftArray[row];
        [self getAddCity:self.LeftArray[row][@"id"]];
        
    }else{
        RightDic = _RightArray[row];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    if (pickerView == LeftPicker) {
        return _LeftArray.count;
    }else{
        return _RightArray.count;
    }

}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{

    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *rowLabel = [[UILabel alloc]init];
    rowLabel.textAlignment = NSTextAlignmentCenter;
    rowLabel.backgroundColor = [UIColor whiteColor];
    rowLabel.frame = CGRectMake(0, 0, 40,self.frame.size.width);
    rowLabel.font = [UIFont systemFontOfSize:17];
    rowLabel.textColor = [UIColor blackColor];
    [rowLabel sizeToFit];
    if (pickerView == LeftPicker) {
        rowLabel.text = _LeftArray[row][@"name"];
    }else{
        rowLabel.text = _RightArray[row][@"name"];
    }


    return rowLabel;
}

- (void)sureAction{
    if (self.Block) {
        [self hide];
        self.Block(LeftDic, RightDic);
    }
}

- (void)show {
    [self.window addSubview:self];
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.blackMask.alpha = 0.2f;
        [self.windowView setPosition:CGPointMake(0, DEVICE_HEIGHT - KBottomHeight) atAnchorPoint:CGPointMake(0, 1)];
    } completion:^(BOOL finished) {
    }];
}

- (void)hide {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.blackMask.alpha = 0.0f;
        [self.windowView setPosition:CGPointMake(0, DEVICE_HEIGHT) atAnchorPoint:CGPointMake(0, 0)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (UIWindow *)window {
    if (!_window) {
        _window = [UIApplication sharedApplication].keyWindow;
    }
    return _window;
}

- (UIView *)blackMask {
    if (!_blackMask) {
        _blackMask = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _blackMask.clipsToBounds = YES;
        _blackMask.alpha = 0.0f;
        _blackMask.backgroundColor = [UIColor blackColor];
    }
    return _blackMask;
}

- (UIView *)windowView {
    if (!_windowView) {
        _windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 300)];
        _windowView.backgroundColor = [UIColor whiteColor];
        _windowView.clipsToBounds = YES;
    }
    return _windowView;
}

@end

