//
//  HCMallCustomerController.m
//  HC
//
//  Created by tuibao on 2021/12/14.
//

#import "HCMallCustomerController.h"
#import "HCOnlineController.h"
@interface HCMallCustomerController ()

@end

@implementation HCMallCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"客服中心";
    
    [self.zaixian_view bk_whenTapped:^{
        [self 在线客服];
    }];
    
    [self.qq_view bk_whenTapped:^{
        [self QQ客服];
    }];
    
}

- (void)在线客服{
    [self.xp_rootNavigationController pushViewController:[HCOnlineController new] animated:YES];
}
- (void)QQ客服{
    //是否安装QQ http://shang.qq.com 免费开通推广
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){
        
        //用来接收临时消息的客服QQ号码(注意此QQ号需开通QQ推广功能,否则陌生人向他发送消息会失败)
        NSString *QQ = @"493883049";
        //调用QQ客户端,发起QQ临时会话
        NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
        
    }else{
        [XHToast showBottomWithText:@"请先安装QQ聊天软件"];
    }
}



@end
