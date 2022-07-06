//
//  HCMessageDetialController.m
//  HC
//
//  Created by tuibao on 2022/1/14.
//

#import "HCMessageDetialController.h"

@interface HCMessageDetialController ()

@property (nonatomic , strong) UIScrollView *scrollView;

@property (strong, nonatomic)  UILabel *title_lab;
@property (strong, nonatomic)  UILabel *time_lab;
@property (strong, nonatomic)  UILabel *content_lab;

@property (strong, nonatomic)  UILabel *name_lab;
@property (strong, nonatomic)  UILabel *time2_lab;
@property (strong, nonatomic)  UIImageView *gongzhang_img;

@end

@implementation HCMessageDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self LoadUI];
}

- (void)LoadUI{
    
    
    self.title_lab.text = self.dataDic[@"title"];
    self.time_lab.text = self.dataDic[@"createTime"];

    self.content_lab.text = [self.dataDic[@"msg"] stringByReplacingOccurrencesOfString:@"&" withString:@"\n"];

    [UILabel changeSpaceForLabel:self.content_lab withLineSpace:8 WordSpace:0.2];



    NSArray *imgs = [self.dataDic[@"createTime"] componentsSeparatedByString:@" "];

    NSString *str = imgs[0];

    NSArray *time = [str componentsSeparatedByString:@"-"];

    NSString *timeStr = [NSString stringWithFormat:@"%@年%@月%@日",time[0],time[1],time[2]];

    self.time2_lab.text = timeStr;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT));
        make.left.top.offset(0);
    }];
    
    [self.scrollView addSubview:self.title_lab];
    [self.title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    
    [self.scrollView addSubview:self.time_lab];
    [self.time_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title_lab.mas_bottom).offset(10);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    
    [self.scrollView addSubview:self.content_lab];
    [self.content_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH-30);
        make.top.equalTo(self.time_lab.mas_bottom).offset(10);
        make.left.offset(15);
    }];
    
    [self.scrollView addSubview:self.name_lab];
    [self.name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content_lab.mas_bottom).offset(80);
        make.right.equalTo(self.content_lab.mas_right).offset(-15);
    }];
    
    [self.scrollView addSubview:self.time2_lab];
    [self.time2_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name_lab.mas_bottom).offset(10);
        make.centerX.equalTo(self.name_lab);
    }];
    
    [self.scrollView addSubview:self.gongzhang_img];
    [self.gongzhang_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name_lab.mas_top).offset(-50);
        make.centerX.equalTo(self.name_lab);
    }];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    _scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, CGRectGetMaxY(self.time2_lab.frame) + 180);
    
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _scrollView;
}

- (UILabel *)title_lab{
    if (!_title_lab) {
        _title_lab = [UILabel getUILabelText:@"消息标题" TextColor:[UIColor blackColor] TextFont:[UIFont getUIFontSize:18 IsBold:YES] TextNumberOfLines:5];
    }
    return _title_lab;
}


- (UILabel *)time_lab{
    if (!_time_lab) {
        _time_lab = [UILabel getUILabelText:@"2021-01-01" TextColor:[UIColor colorWithHexString:@"#666666"] TextFont:[UIFont getUIFontSize:14 IsBold:NO] TextNumberOfLines:0];
    }
    return _time_lab;
}

- (UILabel *)content_lab{
    if (!_content_lab) {
        _content_lab = [UILabel getUILabelText:@"消息内容" TextColor:[UIColor colorWithHexString:@"#333333"] TextFont:[UIFont getUIFontSize:15 IsBold:NO] TextNumberOfLines:50];
    }
    return _content_lab;
}

- (UILabel *)name_lab{
    if (!_name_lab) {
        _name_lab = [UILabel getUILabelText:@"恒创市场运营部" TextColor:[UIColor blackColor] TextFont:[UIFont getUIFontSize:18 IsBold:NO] TextNumberOfLines:0];
        _name_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _name_lab;
}

- (UILabel *)time2_lab{
    if (!_time2_lab) {
        _time2_lab = [UILabel getUILabelText:@"2021年01月01日" TextColor:[UIColor colorWithHexString:@"#666666"] TextFont:[UIFont getUIFontSize:14 IsBold:NO] TextNumberOfLines:0];
        _time2_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _time2_lab;
}

- (UIImageView *)gongzhang_img{
    if (!_gongzhang_img) {
        _gongzhang_img = [UIImageView getUIImageView:@"HC_dianzizhang"];
    }
    return _gongzhang_img;
}


@end
