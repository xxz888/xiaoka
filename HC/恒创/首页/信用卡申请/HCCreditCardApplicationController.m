//
//  HCCreditCardApplicationController.m
//  HC
//
//  Created by tuibao on 2021/11/30.
//

#import "HCCreditCardApplicationController.h"

@interface HCCreditCardApplicationController ()

@end

@implementation HCCreditCardApplicationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"在线办卡";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //打开网页
    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    web.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:web];
    
    [web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.bottom.offset(-KBottomHeight);
    }];
    
    //加载服务器url的方法*/
    NSString *url = @"http://h5.bjyoushengkj.com/wechat/pages/wailian/wailian.html?merCode=aa9db42d3372495897ee5a4f8a117a16";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [web loadRequest:request];
}



@end
