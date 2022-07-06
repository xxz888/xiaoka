//
//  HCOnlineController.m
//  HC
//
//  Created by tuibao on 2021/11/26.
//

#import "HCOnlineController.h"

@interface HCOnlineController ()

@end

@implementation HCOnlineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"在线客服";
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
    NSString *url = @"https://tb.53kf.com/code/client/fc25d13606aea048aad115359d019b9f5/1";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [web loadRequest:request];

    
}



@end
