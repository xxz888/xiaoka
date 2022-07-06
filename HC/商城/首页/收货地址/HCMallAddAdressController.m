//
//  HCMallAddAdressController.m
//  HC
//
//  Created by tuibao on 2021/12/23.
//

#import "HCMallAddAdressController.h"

@interface HCMallAddAdressController ()<UITextViewDelegate>

@end

@implementation HCMallAddAdressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加地址";
    self.view.backgroundColor = [UIColor whiteColor];
    [self LoadUI];
}

- (void)LoadUI{
    UIView *leftView1 = [[UIView alloc] init];
    leftView1.width = 5;
    self.name_textfield.leftViewMode = UITextFieldViewModeAlways;
    self.name_textfield.leftView = leftView1;
    UIView *leftView2 = [[UIView alloc] init];
    leftView2.width = 5;
    self.phone_textfield.leftViewMode = UITextFieldViewModeAlways;
    self.phone_textfield.leftView = leftView2;
    UIView *leftView3 = [[UIView alloc] init];
    leftView3.width = 5;
    self.city_textfield.leftViewMode = UITextFieldViewModeAlways;
    self.city_textfield.leftView = leftView3;
    self.address_textfield.delegate = self;
    
    
    [self.city_textfield bk_whenTapped:^{
        ///自定义
        KisZDYPickerView *PickerView = [[KisZDYPickerView alloc]init];
        PickerView.Block = ^(NSDictionary *startDic, NSDictionary *endDic) {
            if ([[startDic allKeys] count] > 0 && [[endDic allKeys] count] > 0) {
                self.city_textfield.text = [NSString stringWithFormat:@"%@%@",startDic[@"name"],endDic[@"name"]];
            }
        };
        [PickerView show];
        
    }];
    
}
- (IBAction)saveAction:(UIButton *)sender {
    
    if (self.name_textfield.text.length == 0) {
        [XHToast showBottomWithText:@"请输入收货人姓名"];
        return;
    }
    if (self.phone_textfield.text.length == 0) {
        [XHToast showBottomWithText:@"请输入手机号码"];
        return;
    }else if(self.phone_textfield.text.length != 11){
        [XHToast showBottomWithText:@"请输入正确手机号码"];
        return;
    }
    if (self.city_textfield.text.length == 0) {
        [XHToast showBottomWithText:@"请选择地址"];
        return;
    }
    if (self.address_textfield.text.length == 0) {
        [XHToast showBottomWithText:@"请输入详细地址"];
        return;
    }
    
    NSDictionary *UserDic = [self loadUserData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:UserDic[@"username"] forKey:@"phone"];
    [params setObject:[NSString stringWithFormat:@"%@%@",self.city_textfield.text,self.address_textfield.text] forKey:@"myAddress"];
    [params setObject:self.phone_textfield.text forKey:@"userCall"];
    [params setObject:self.name_textfield.text forKey:@"name"];
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/shop/addMyAddress" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            [XHToast showBottomWithText:@"地址添加成功"];
            [self.xp_rootNavigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSString * _Nonnull error) {

    }];
    
}
//
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"区/街道/小区楼栋/乡村名称"]) {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"区/街道/小区楼栋/乡村名称";
    }
}


@end
