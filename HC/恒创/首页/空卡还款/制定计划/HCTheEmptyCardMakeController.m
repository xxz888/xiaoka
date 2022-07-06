//
//  HCTheEmptyCardMakeController.m
//  HC
//
//  Created by tuibao on 2022/1/12.
//

#import "HCTheEmptyCardMakeController.h"

@interface HCTheEmptyCardMakeController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icon_image;

@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UILabel *number_lab;
@property (weak, nonatomic) IBOutlet UILabel *editor_lab;


@property (weak, nonatomic) IBOutlet UIView *content_view;
///还款总金额
@property (weak, nonatomic) IBOutlet UITextField *zongjine_textfield;
///手续费
@property (weak, nonatomic) IBOutlet UITextField *yue_textfield;
///每日还款次数
@property (weak, nonatomic) IBOutlet UITextField *NumberPay_textfield;
///消费地区
@property (weak, nonatomic) IBOutlet UITextField *address_lab;

///制定计划
@property (weak, nonatomic) IBOutlet UIButton *custom_btn;

//请求参数
@property (nonatomic , strong) NSMutableDictionary *params;

@property (nonatomic , strong) NSMutableArray * TheCustomArr;

//省/直辖市
@property (nonatomic , strong) NSString *provinceAddress;
//市
@property (nonatomic , strong) NSString *cityAddress;


@end

@implementation HCTheEmptyCardMakeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"制定计划";
    //设置阴影
    [self.content_view setViewTypeshadow];
    self.zongjine_textfield.delegate = self;
    self.zongjine_textfield.keyboardType = UIKeyboardTypeDecimalPad;
    [self GetTheAddress];
    [self ViewAction];
    
}

- (void)ViewAction{
    
    [self.NumberPay_textfield bk_whenTapped:^{
        [self NumberPayAction];
    }];
    
    [self.address_lab bk_whenTapped:^{
        [self ConsumptionAction];
    }];
    
    
}
#pragma 选择消费地区
- (void)ConsumptionAction{
    ///自定义
    KisZDYPickerView *PickerView = [[KisZDYPickerView alloc]init];
    PickerView.provinceAddress = self.provinceAddress;
    PickerView.cityAddress = self.cityAddress;
    
    PickerView.Block = ^(NSDictionary *startDic, NSDictionary *endDic) {
        if ([startDic allKeys].count > 0 && [endDic allKeys].count > 0) {
            
            [self.params setValue:startDic[@"id"] forKey:@"provinceCode"];//省编码
            [self.params setValue:endDic[@"id"] forKey:@"cityCode"];//城市编码
            self.address_lab.text = [NSString stringWithFormat:@"%@-%@",startDic[@"name"],endDic[@"name"]];
    
        }
    };
    [PickerView show];
}
#pragma 获取定位地址
- (void)GetTheAddress{
    @weakify(self);
    [self addLocationManager:^(NSString * _Nonnull province, NSString * _Nonnull city) {
        weak_self.provinceAddress = province;
        weak_self.cityAddress = city;
        [weak_self MatchingLocationAddress:province City:city];
        weak_self.address_lab.text = [NSString stringWithFormat:@"%@-%@",province,city];
    }];
}
#pragma 匹配定位地址的准确性
- (void)MatchingLocationAddress:(NSString *)province City:(NSString *)city{
    
    [self getAddressThan:province City:city isThan:^(NSString * _Nonnull provinceCode, NSString * _Nonnull cityCode, BOOL isThan) {
        if (isThan) {
            [self.params setValue:provinceCode forKey:@"provinceCode"];//省编码
            [self.params setValue:cityCode forKey:@"cityCode"];//城市编码
        }else{
            self.address_lab.text = @"";
        }
    }];
}
#pragma 每次还款次数
- (void)NumberPayAction{
        
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //下次跟进时间
    WSDatePickerView *dateView = [[WSDatePickerView alloc]initWithDateStyle:DateStyleShowOtherString CompleteBlock:^(NSDate *Data, NSString *Str, id OtherString) {
        
        self.NumberPay_textfield.text = Str;
        [self.params setValue:[Str substringToIndex:1] forKey:@"dayRepaymentCount"];//每日还款次数
        
    }];
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@"1次"];
    [arr addObject:@"2次"];
    [arr addObject:@"3次"];
    [arr addObject:@"4次"];
    
    dateView.showYearViewMax = @"每日";
    dateView.MyearArray = arr;
    [dateView show];

}
//限制执行费率只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
   BOOL res = YES;
   NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
   int i = 0;
   while (i < number.length) {
       NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
       NSRange range = [string rangeOfCharacterFromSet:tmpSet];
       if (range.length == 0) {
           res = NO;
           break;
       }
       i++;
   }
   return res;
}
@end
