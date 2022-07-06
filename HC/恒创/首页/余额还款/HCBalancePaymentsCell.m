//
//  HCBalancePaymentsCell.m
//  HC
//
//  Created by tuibao on 2021/11/9.
//

#import "HCBalancePaymentsCell.h"

//RGB颜色
#define kRGBColor(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define percent 0.9//第一段动画百分比
#define duration_First 1.0 //第一段动画时间
#define duration_Second 1.0//第二段动画时间
#define TimeInterval 0.01  //定时器刷新间隔

#define lineWH 45

@interface HCBalancePaymentsCell()

/** 圆环底层视图 */
@property (nonatomic, strong) UIView *bgView;
@property (strong, nonatomic) UILabel *progressLab;

//进度条
@property (nonatomic,strong) CAShapeLayer *progressLayer;
//定时器
@property (strong, nonatomic) NSTimer *timer;

//当前显示进度值
@property (assign, nonatomic) CGFloat showProgress;


@end

@implementation HCBalancePaymentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadUI];
}

- (void)loadUI{
    
    [self.bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
    
    [self.bg_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(10);
        make.right.bottom.offset(-10);
    }];
    [self.delete_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.offset(17);
        make.left.offset(17);
    }];
    
    [self.yinlian_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.offset(10);
        make.right.offset(-25);
    }];
    self.lishi_lab.layer.masksToBounds = YES;
    self.lishi_lab.layer.borderColor = [UIColor colorWithHexString:@"#D79C64"].CGColor;
    self.lishi_lab.layer.borderWidth = 0.5;
    self.lishi_lab.layer.cornerRadius = 5;
    self.lishi_lab.userInteractionEnabled = YES;
    [self.lishi_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(56, 17));
        make.top.equalTo(self.yinlian_image.mas_bottom).offset(3);
        make.right.offset(-25);
    }];

    [self.yinhang_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self.delete_image.mas_bottom).offset(-1);
        make.left.equalTo(self.delete_image.mas_right).offset(6);
    }];
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yinhang_image.mas_top).offset(0);
        make.left.equalTo(self.yinhang_image.mas_right).offset(10);
    }];
    [self.content_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title_lab.mas_bottom).offset(8);
        make.left.equalTo(self.title_lab.mas_left);
    }];
    
    
    [self.line_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.offset(30);
        make.right.offset(-30);
        make.top.equalTo(self.content_lab.mas_bottom).offset(12);
    }];
    
    [self.jihua_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yinhang_image.mas_left);
        make.top.equalTo(self.line_view.mas_bottom).offset(14);
    }];
    
    self.zhiding_jihua_lab.layer.masksToBounds = YES;
    self.zhiding_jihua_lab.layer.borderColor = [UIColor colorWithHexString:@"#D79C64"].CGColor;
    self.zhiding_jihua_lab.layer.borderWidth = 0.5;
    self.zhiding_jihua_lab.layer.cornerRadius = 5;
    self.zhiding_jihua_lab.userInteractionEnabled = YES;
    [self.zhiding_jihua_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(56, 17));
        make.centerY.equalTo(self.jihua_lab);
        make.right.offset(-25);
    }];
    
    //创建基本视图
    [self createSubview];
    
}


- (void)createSubview{
    
    [self.bg_view addSubview:self.bgView];
    [self.bgView addSubview:self.progressLab];
    
    self.bgView.frame = CGRectMake(DEVICE_WIDTH- 130, CGRectGetMaxY(self.zhiding_jihua_lab.frame)-20-4, lineWH, lineWH);
    
    [self.progressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
    }];
    
    //创建路径及layer
    [self createLayerPath];
    
}

- (void)createLayerPath{

//    [self.bgView setNeedsLayout];
//    [self.bgView layoutIfNeeded];
    
    //贝塞尔曲线画圆弧
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(lineWH/2, lineWH/2) radius:(lineWH-17)/2.0 startAngle:-M_PI/2 endAngle:3*M_PI/2 clockwise:YES];
    //设置颜色
    [kRGBColor(0xF6F6F9) set];
    circlePath.lineWidth = 10;
    //开始绘图
    [circlePath stroke];
    
    //创建背景视图
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = self.bgView.bounds;
    bgLayer.fillColor = [UIColor clearColor].CGColor;//填充色 - 透明
    bgLayer.lineWidth = 4;//线条宽度
    bgLayer.strokeColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.5].CGColor;//线条颜色
    bgLayer.strokeStart = 0;//起始点
    bgLayer.strokeEnd = 1;//终点
    bgLayer.lineCap = kCALineCapRound;//让线两端是圆滑的状态
    bgLayer.path = circlePath.CGPath;//这里就是把背景的路径设为之前贝塞尔曲线的那个路径
    [self.bgView.layer addSublayer:bgLayer];
    
    //创建进度条视图
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bgView.bounds;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.lineWidth = 4;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeColor = kRGBColor(0xC8A159).CGColor;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.path = circlePath.CGPath;
    [self.bgView.layer addSublayer:_progressLayer];
    
    //创建渐变色图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [self.bgView.layer addSublayer:gradientLayer];
    
    //#C8A159 #EBD6AB  C6A05D
    CAGradientLayer *leftGradientLayer = [CAGradientLayer layer];
    leftGradientLayer.frame = CGRectMake(0, 0, lineWH/2, lineWH);
    [leftGradientLayer setColors:[NSArray arrayWithObjects:(id)kRGBColor(0xEBD6AB).CGColor, (id)kRGBColor(0xC6A05D).CGColor, nil]];
    [leftGradientLayer setLocations:@[@0.0,@1.0]];
    [leftGradientLayer setStartPoint:CGPointMake(0, 0)];
    [leftGradientLayer setEndPoint:CGPointMake(0, 1)];
    [gradientLayer addSublayer:leftGradientLayer];
    
    CAGradientLayer *rightGradientLayer = [CAGradientLayer layer];
    rightGradientLayer.frame = CGRectMake(lineWH/2, 0, lineWH/2, lineWH);
    [rightGradientLayer setColors:[NSArray arrayWithObjects:(id)kRGBColor(0xEBD6AB).CGColor, (id)kRGBColor(0xC6A05D).CGColor, nil]];
    [rightGradientLayer setLocations:@[@0.0,@1.0]];
    [rightGradientLayer setStartPoint:CGPointMake(0, 0)];
    [rightGradientLayer setEndPoint:CGPointMake(0, 1)];
    [gradientLayer addSublayer:rightGradientLayer];
    [gradientLayer setMask:_progressLayer];
    
}

- (void)configFirstAnimate{
    CABasicAnimation *animation_1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation_1.fromValue = @0;
    animation_1.toValue = [NSNumber numberWithDouble:self.progress*percent];
    animation_1.duration = duration_First;
    animation_1.fillMode = kCAFillModeForwards;
    animation_1.removedOnCompletion = NO;
    [self.progressLayer addAnimation:animation_1 forKey:nil];
    
}

- (void)configSecondAnimate{
    CABasicAnimation *animation_2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation_2.fromValue = [NSNumber numberWithDouble:self.progress*percent];
    animation_2.toValue = [NSNumber numberWithDouble:self.progress];
    animation_2.duration = duration_Second;
    animation_2.fillMode = kCAFillModeForwards;
    animation_2.removedOnCompletion = NO;
    [self.progressLayer addAnimation:animation_2 forKey:nil];
    
}

- (void)startTimer{
    [self deleteTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(animate:) userInfo:nil repeats:YES];
}

- (void)animate:(NSTimer *)time{
    if (self.showProgress <= self.progress*percent) {
        self.showProgress += TimeInterval*self.progress*percent/duration_First;
    }else if (self.showProgress <= self.progress){
        self.showProgress += TimeInterval*self.progress*(1-percent)/duration_Second;
    }else{
        [self deleteTimer];
    }
    
    if (self.showProgress > 1) {
        self.showProgress = 1;
    }
    
    NSString *progressStr = [NSString stringWithFormat:@"%.0f%%",self.showProgress*100];
    self.progressLab.text = progressStr;
}

- (void)deleteTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - action
- (void)setProgress:(CGFloat)progress{
    //进度值
    _progress = progress;
    
    
    if (progress != 10000) {
        [self.bgView setHidden:NO];
        [self.progressLab setHidden:NO];
        [self deleteTimer];
        [self.progressLayer removeAllAnimations];
        self.progressLayer.strokeEnd = 0;
        self.progressLab.text = @"0%";

        self.showProgress = 0;
        
        __weak __typeof(&*self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            //设置第一段动画
            [weakSelf configFirstAnimate];
            //开启定时器
            [weakSelf startTimer];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration_First * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //设置第二段动画
                [weakSelf configSecondAnimate];
            });
        });
    }else{
        [self.bgView setHidden:YES];
        [self.progressLab setHidden:YES];
    }
    
}




#pragma mark - getter

- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]init];
    }
    return _bgView;
}



- (UILabel *)progressLab{
    if (_progressLab == nil) {
        _progressLab = [[UILabel alloc]init];
        _progressLab.textColor = FontThemeColor;
        _progressLab.textAlignment = NSTextAlignmentLeft;
        _progressLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:8];
        _progressLab.text = @"0%";
    }
    return _progressLab;
}

@end
