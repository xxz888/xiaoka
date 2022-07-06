//
//  HCKeyboardView.m
//  HC
//
//  Created by tuibao on 2021/11/8.
//

#import "HCKeyboardView.h"

@implementation HCKeyboardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, 234);
        self.userInteractionEnabled = YES;
        
    }
    return self;
}


- (IBAction)AddAction:(UIButton *)sender {
    self.block(sender.titleLabel.text);
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self loadUI];
}


- (void)loadUI{
    
    
    
    double btn_W = DEVICE_WIDTH / 4;
    
    double btn_H = 234 / 4;
    
    
    [self AddLayerBoeder:self];
    [self AddLayerBoeder:self.keboard_1_btn];
    [self AddLayerBoeder:self.keboard_2_btn];
    [self AddLayerBoeder:self.keboard_3_btn];
    [self AddLayerBoeder:self.keboard_4_btn];
    [self AddLayerBoeder:self.keboard_5_btn];
    [self AddLayerBoeder:self.keboard_6_btn];
    [self AddLayerBoeder:self.keboard_7_btn];
    [self AddLayerBoeder:self.keboard_8_btn];
    [self AddLayerBoeder:self.keboard_9_btn];
    [self AddLayerBoeder:self.keboard_0_btn];
    [self AddLayerBoeder:self.keboard_d_btn];
    [self AddLayerBoeder:self.keboard_sq_btn];
    [self AddLayerBoeder:self.keboard_clean_btn];
    [self AddLayerBoeder:self.keboard_collection_btn];
    
    [self.keboard_1_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H));
        make.top.left.offset(0);
    }];
    [self.keboard_4_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H));
        make.centerX.equalTo(self.keboard_1_btn);
        make.top.equalTo(self.keboard_1_btn.mas_bottom);
    }];
    [self.keboard_7_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H));
        make.centerX.equalTo(self.keboard_1_btn);
        make.top.equalTo(self.keboard_4_btn.mas_bottom);
    }];
    [self.keboard_sq_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H));
        make.centerX.equalTo(self.keboard_1_btn);
        make.top.equalTo(self.keboard_7_btn.mas_bottom);
        make.bottom.offset(0);
    }];
    
    [self.keboard_2_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H));
        make.top.offset(0);
        make.left.equalTo(self.keboard_1_btn.mas_right);
    }];
    [self.keboard_5_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H));
        make.centerX.equalTo(self.keboard_2_btn);
        make.top.equalTo(self.keboard_2_btn.mas_bottom);
    }];
    [self.keboard_8_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H));
        make.centerX.equalTo(self.keboard_2_btn);
        make.top.equalTo(self.keboard_5_btn.mas_bottom);
    }];
    [self.keboard_0_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H));
        make.centerX.equalTo(self.keboard_2_btn);
        make.top.equalTo(self.keboard_8_btn.mas_bottom);
        make.bottom.offset(0);
    }];
    
    [self.keboard_3_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H));
        make.top.offset(0);
        make.left.equalTo(self.keboard_2_btn.mas_right);
    }];
    [self.keboard_6_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H));
        make.centerX.equalTo(self.keboard_3_btn);
        make.top.equalTo(self.keboard_3_btn.mas_bottom);
    }];
    [self.keboard_9_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H));
        make.centerX.equalTo(self.keboard_3_btn);
        make.top.equalTo(self.keboard_6_btn.mas_bottom);
    }];
    [self.keboard_d_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H));
        make.centerX.equalTo(self.keboard_3_btn);
        make.top.equalTo(self.keboard_9_btn.mas_bottom);
        make.bottom.offset(0);
    }];
    
    [self.keboard_clean_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H));
        make.top.offset(0);
        make.left.equalTo(self.keboard_3_btn.mas_right);
    }];
    
    [self.keboard_collection_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btn_W, btn_H*3));
        make.centerX.equalTo(self.keboard_clean_btn);
        make.top.equalTo(self.keboard_clean_btn.mas_bottom);
        make.bottom.offset(0);
    }];
    
    
}


- (void)AddLayerBoeder:(UIView *)view{
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    view.layer.borderWidth = 0.5;
}



- (void)ShowView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 234);
    @weakify(self);
    [UIView animateWithDuration:.3f animations:^{
        weak_self.frame = CGRectMake(0, DEVICE_HEIGHT - 234, DEVICE_WIDTH, 234);
    }];
}
- (void)disMissView{
    
    self.frame = CGRectMake(0, DEVICE_HEIGHT - 234, DEVICE_WIDTH, 234);
    @weakify(self);
    [UIView animateWithDuration:.3f animations:^{
        weak_self.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 234);
    }
    completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}




    


    

    

@end
