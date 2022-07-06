//
//  HCAddCustomerController.m
//  HC
//
//  Created by tuibao on 2021/12/30.
//

#import "HCAddCustomerController.h"
#import "HCCustomerSavingsCardController.h"
@interface HCAddCustomerController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phone_textfield;



@end

@implementation HCAddCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加客户";
    self.view.backgroundColor = [UIColor whiteColor];
    self.phone_textfield.delegate = self;
}


// 显示长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.text.length > 10 && ![string isEqualToString:@""]){
        return NO;
    }
    return YES;
}
- (void)viewDidDisappear:(BOOL)animated {
    
    //清楚栈中当前VC
    NSArray<UIViewController *> * arr = self.xp_rootNavigationController.viewControllers;
    NSMutableArray *array = [NSMutableArray array];
    for (XPContainerNavigationController * VC in arr) {
        if (![VC isKindOfClass:[HCAddCustomerController class]]) {
            [array addObject:VC];
        }
    }
    self.xp_rootNavigationController.viewControllers = array;
    
}

- (IBAction)下一步:(UIButton *)sender {
    
    
    if (self.phone_textfield.text.length == 0) {
        [XHToast showBottomWithText:@"请输入手机号" duration:2];
        return;
    }
    if (self.phone_textfield.text.length != 11) {
        [XHToast showBottomWithText:@"请输入正确手机号" duration:2];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phone_textfield.text forKey:@"phone"];

    [self NetWorkingPostWithAddressURL:self hiddenHUD:YES url:@"/api/user/pre/register" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {

            HCCustomerSavingsCardController *VC = [HCCustomerSavingsCardController new];
            VC.empowerToken = responseObject[@"data"];
            [self.xp_rootNavigationController pushViewController:VC animated:NO];

        }else{
            [XHToast showBottomWithText:responseObject[@"message"] duration:2];
        }
    } failure:^(NSString * _Nonnull error) {

    }];
    
}



@end
