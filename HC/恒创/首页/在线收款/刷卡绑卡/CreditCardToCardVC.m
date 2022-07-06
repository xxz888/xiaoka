//
//  CreditCardToCardVC.m
//  HC
//
//  Created by tuibao on 2022/5/26.
//

#import "CreditCardToCardVC.h"

@interface CreditCardToCardVC ()

@property (weak, nonatomic) IBOutlet UIView *View1;
@property (weak, nonatomic) IBOutlet UITextField *textfield1;
@property (weak, nonatomic) IBOutlet UITextField *textfield2;
@property (weak, nonatomic) IBOutlet UITextField *textfield3;
@property (weak, nonatomic) IBOutlet UITextField *textfield4;
@property (weak, nonatomic) IBOutlet UITextField *textfield5;

@property (weak, nonatomic) IBOutlet UIView *View5;

@property (weak, nonatomic) IBOutlet UILabel *getCode_lab;

@property (nonatomic , strong) NSDictionary *UserData;

@end

@implementation CreditCardToCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"签约确认";
    self.view.backgroundColor = [UIColor colorWithHexString:@"EFEFEF"];
    
    self.UserData = [NSDictionary dictionaryWithDictionary:[self loadUserData]];
    
    [self LoadUI];
    
}

- (void)LoadUI{
    
    
    [self.View1 getPartOfTheCornerRadius:CGRectMake(0, 0, DEVICE_WIDTH - 40, 50) CornerRadius:10 UIRectCorner:UIRectCornerTopLeft | UIRectCornerTopRight];
    [self.View5 getPartOfTheCornerRadius:CGRectMake(0, 0, DEVICE_WIDTH - 40, 50) CornerRadius:10 UIRectCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    
    
    
    self.textfield3.secureTextEntry = YES;
    self.textfield4.secureTextEntry = YES;
    self.textfield5.keyboardType = UIKeyboardTypeNumberPad;
    self.textfield1.text = self.UserData[@"fullname"];
    
    if (self.cardData.count > 0) {
        self.textfield2.text = [NSString getSecrectStringWithAccountNo:self.cardData[@"cardNo"]];
        
        self.textfield3.text = self.cardData[@"expiredTime"];
        
        self.textfield4.text = self.cardData[@"securityCode"];
        
        
    }
    
    [self.getCode_lab bk_whenTapped:^{
        [self getBindCard];
    }];
    
}
//预绑卡
- (void)getBindCard{
    
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.UserData[@"id"] forKey:@"userId"];//用户id
    [params setValue:self.UserData[@"fullname"] forKey:@"userName"];//用户姓名
    [params setValue:self.cardData[@"bankName"] forKey:@"bankName"];//银行卡名称
    [params setValue:self.cardData[@"cardNo"] forKey:@"bankCard"];//银行卡号
    [params setValue:self.cardData[@"phone"] forKey:@"bankPhone"];//银行手机
    [params setValue:self.cardData[@"securityCode"] forKey:@"securityCode"];//安全码
    [params setValue:self.cardData[@"expiredTime"] forKey:@"expiredTime"];//有效期
    [params setValue:self.cardData[@"idCard"] forKey:@"idCard"];//有效期
    [params setValue:self.channelId forKey:@"channelId"];//通道ID
    [params setValue:brandId forKey:@"brandId"];//品牌ID
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/payment/fast/bindcard" Params:params success:^(id  _Nonnull responseObject) {
        
        if ([responseObject[@"code"] intValue] == 0) {
            if([responseObject[@"message"] isEqualToString:@"重复签约"]){
                [self.xp_rootNavigationController popViewControllerAnimated:YES];

                if (self.block) {
                    self.block(@"确认绑卡");
                }
            }else{
                [XHToast showBottomWithText:@"短信发送成功"];
                self.getCode_lab.userInteractionEnabled = NO;
                [self changeSendBtnText];
            }
        }
        else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

///确认绑卡
- (IBAction)签约确认:(id)sender {
    
    if (self.textfield5.text.length == 0) {
        [XHToast showBottomWithText:@"请输入验证码"];
        return;
    }
    if (self.textfield5.text.length != 6) {
        [XHToast showBottomWithText:@"请输入正确验证码"];
        return;
    }
    
    //启动计划 需要绑卡 第二步 确认绑卡
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.textfield5.text forKey:@"smsMsg"];//验证码
    [params setValue:self.cardData[@"cardNo"] forKey:@"bankCard"];//银行卡号
    [params setValue:self.channelId forKey:@"channelId"];//通道id
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/payment/fast/bindcard/confirm" Params:params success:^(id  _Nonnull responseObject) {
        
        if ([responseObject[@"code"] intValue] == 0) {
            [self.xp_rootNavigationController popViewControllerAnimated:YES];
            if (self.block) {
                self.block(@"确认绑卡");
            }
        }
        else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}

//------ 验证码发送按钮动态改变文字 ------//
- (void)changeSendBtnText{

    __block NSInteger second = 60;
    // 全局队列 默认优先级
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 定时器模式 事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // NSEC_PER_SEC是秒 *1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (second >= 0) {
                
                self.getCode_lab.text = [NSString stringWithFormat:@"%lds", second];
                
                second--;
                
                
            }else {
                self.getCode_lab.userInteractionEnabled = YES;
                dispatch_source_cancel(timer);
                self.getCode_lab.text = @"重新发送";
                
            }
            
        });
    });
    // 启动源
    dispatch_resume(timer);
}

@end
