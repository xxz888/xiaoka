//
//  HCCustomerSavingsCardController.m
//  HC
//
//  Created by tuibao on 2021/12/30.
//

#import "HCCustomerSavingsCardController.h"
#import "HCAddCustomerController.h"
#define ZhengMian @"身份证正面"
#define FanMian   @"身份证反面"
@interface HCCustomerSavingsCardController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    BOOL isSFZz;//身份证正面
    BOOL isSFZf;//身份证反面
}
///身份证正面
@property (weak, nonatomic) IBOutlet UIImageView *left_IdCard;
///身份证反面
@property (weak, nonatomic) IBOutlet UIImageView *right_IdCard;
///姓名
@property (weak, nonatomic) IBOutlet UITextField *Customer_name;
///身份证号
@property (weak, nonatomic) IBOutlet UITextField *Customer_IdCard;
///储蓄卡账号
@property (weak, nonatomic) IBOutlet UITextField *Customer_CashCard;
///储蓄卡开户行
@property (weak, nonatomic) IBOutlet UITextField *Customer_WhereItIs;
///预留手机号
@property (weak, nonatomic) IBOutlet UITextField *Customer_phoneNumber;

@property (assign , nonatomic) NSString* zhengmianfanmian;

@property (strong, nonatomic) WLCardNoFormatter *cardNoFormatter;

//省/直辖市
@property (nonatomic , strong) NSString *provinceAddress;
//市
@property (nonatomic , strong) NSString *cityAddress;

@end

@implementation HCCustomerSavingsCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"客户信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    isSFZz = NO;
    isSFZf = NO;
    self.provinceAddress = @"";
    self.cityAddress = @"";
    [self LoadUI];
    [self GetTheAddress];
}
- (void)LoadUI{
    
    if (DEVICE_WIDTH > 375) {
        self.left_with.constant = 30;
        self.right_with.constant = 30;
    }
    [self.left_IdCard bk_whenTapped:^{
        [self zhengmianAction];
    }];
    [self.right_IdCard bk_whenTapped:^{
        [self fanmianAction];
    }];
    [self.Customer_WhereItIs bk_whenTapped:^{
        [self AddressAction];
    }];
    self.Customer_phoneNumber.delegate = self;
    self.Customer_phoneNumber.tag = 500;
    self.Customer_CashCard.delegate = self;
    self.Customer_CashCard.tag = 300;
    self.Customer_WhereItIs.delegate = self;
    self.Customer_WhereItIs.tag = 400;
    self.Customer_IdCard.delegate = self;
    self.Customer_IdCard.tag = 200;
    
    self.Customer_IdCard.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    self.Customer_CashCard.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    self.Customer_phoneNumber.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    
    
}
//返回NO以禁止编辑。
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 400) {
        return NO;
    }
    return YES;
}
// 长度控制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.tag == 500 && textField.text.length > 10 && ![string isEqualToString:@""]){
        return NO;
    }
    else if(textField.tag == 200 && textField.text.length > 17 && ![string isEqualToString:@""]){
        return NO;
    }
    else if (textField.tag == 300){
        [self.cardNoFormatter bankNoField:textField shouldChangeCharactersInRange:range replacementString:string];
        return NO;
    }
    return YES;
}

-(void)showSheet:(NSString *)zhengfan{
    self.zhengmianfanmian = zhengfan;
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        //设置照片来源相机
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置用手机后置摄像头
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        imagePickerController.delegate = self;
        //是否显示裁剪框编辑
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        if(![self CameraPermissions]) return;
    }];
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }];
    [alertVc addAction:cancle];
    [alertVc addAction:camera];
    [alertVc addAction:picture];
    [self presentViewController:alertVc animated:YES completion:nil];
}
#pragma mark Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if ([self.zhengmianfanmian isEqualToString:ZhengMian]) {
            //向服务器上传身份证正面
            [self upLoadZhengMian:image];
        }else{
            //向服务器上传身份证反面
            [self upLoadFanMian:image];
        }
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -----------点击上传身份证正面照片---------------
-(void)zhengmianAction{
    [self showSheet:ZhengMian];
}
#pragma mark -----------向服务器上传身份证正面---------------
-(void)upLoadZhengMian:(UIImage *)img{
    @weakify(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:img forKey:@"file"];
    [params setValue:self.empowerToken forKey:@"empowerToken"];
    [self NetWorkingPostWithImageURL:self hiddenHUD:NO url:@"/api/user/ocr/front/upload" Params:params success:^(id  _Nonnull responseObject) {
        NSDictionary *data = responseObject[@"data"];
        
        if ([responseObject[@"code"] intValue] == 0) {
            self->isSFZz = YES;
            weak_self.Customer_name.text = data[@"name"];
            weak_self.Customer_IdCard.text = data[@"number"];
            weak_self.left_IdCard.image = img;
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        [XHToast showBottomWithText:error];
    }];
    
    
}
#pragma mark -----------点击上传身份证反面照片---------------
-(void)fanmianAction{
    [self showSheet:FanMian];
}
#pragma mark -----------向服务器上传身份证反面---------------
-(void)upLoadFanMian:(UIImage *)img{
    @weakify(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:img forKey:@"file"];
    [params setValue:self.empowerToken forKey:@"empowerToken"];
    [self NetWorkingPostWithImageURL:self hiddenHUD:YES url:@"/api/user/ocr/back/upload" Params:params success:^(id  _Nonnull responseObject) {
        
        if ([responseObject[@"code"] intValue] == 0) {
            self->isSFZf = YES;
            weak_self.right_IdCard.image = img;
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        [XHToast showBottomWithText:error];
    }];
    

}
#pragma 调起地址选择
- (void)AddressAction{
    ///自定义
    KisZDYPickerView *PickerView = [[KisZDYPickerView alloc]init];
    PickerView.provinceAddress = self.provinceAddress;
    PickerView.cityAddress = self.cityAddress;
    
    PickerView.Block = ^(NSDictionary *startDic, NSDictionary *endDic) {
        self.Customer_WhereItIs.text = [NSString stringWithFormat:@"%@-%@",startDic[@"name"],endDic[@"name"]];
    };
    [PickerView show];
}
#pragma 获取定位地址
- (void)GetTheAddress{
    @weakify(self);
    [self addLocationManager:^(NSString * _Nonnull province, NSString * _Nonnull city) {
        weak_self.provinceAddress = province;
        weak_self.cityAddress = city;
        weak_self.Customer_WhereItIs.text = [NSString stringWithFormat:@"%@-%@",province,city];
    }];
}
- (IBAction)确认添加:(id)sender {
    
    //监测身份证正面
    if (!isSFZz) {
        [XHToast showBottomWithText:@"请上传身份证正面照"];
        return;
    }
    //监测身份证反面
    if (!isSFZf) {
        [XHToast showBottomWithText:@"请上传身份证反面照"];
        return;
    }
    //监测姓名
    if ([self.Customer_name.text isEqualToString:@""]) {
        [XHToast showBottomWithText:@"请输入正确的姓名"];
        return;
    }
    //监测身份证号
    if ([self.Customer_IdCard.text isEqualToString:@""] || [self.Customer_IdCard.text length] != 18) {
        [XHToast showBottomWithText:@"请输入正确的身份证号"];
        return;
    }
    if([NSString isBlankString:self.Customer_name.text]){
        [XHToast showBottomWithText:@"姓名不能为空"];
        return;
    }
    if([NSString isBlankString:self.Customer_IdCard.text]){
        [XHToast showBottomWithText:@"身份证号不能为空"];
        return;
    }
    if([NSString isBlankString:self.Customer_CashCard.text]){
        [XHToast showBottomWithText:@"储蓄卡号不能为空"];
        return;
    }
    if([NSString isBlankString:self.Customer_WhereItIs.text]){
        [XHToast showBottomWithText:@"开卡户地不能为空"];
        return;
    }
    if([NSString isBlankString:self.Customer_phoneNumber.text]){
        [XHToast showBottomWithText:@"手机号不能为空"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.Customer_name.text forKey:@"fullname"];
    [params setValue:self.Customer_IdCard.text forKey:@"idcard"];
    [params setValue:self.empowerToken forKey:@"empowerToken"];
    
    [self NetWorkingPostWithURL:self hiddenHUD:YES url:@"/api/user/idcard/update" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [self addCashCard];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        [XHToast showBottomWithText:error];
    }];
    
}

- (void)addCashCard{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.Customer_name.text forKey:@"fullname"];//用户名
//    [params setValue:self.savingsCard[@"bank_name"] forKey:@"bankName"];//银行卡名称
    [params setValue:[self.Customer_CashCard.text RemoveTheBlankSpace:self.Customer_CashCard.text] forKey:@"bankcard"];//银行卡号
    [params setValue:self.Customer_WhereItIs.text forKey:@"provinceCity"];//开户地
    [params setValue:self.Customer_phoneNumber.text forKey:@"phone"];//预留手机号
    [params setValue:self.empowerToken forKey:@"empowerToken"];
    
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/bind/debit/card" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [XHToast showBottomWithText:responseObject[@"message"]];
            //发出通知
            NSNotification *LoseResponse = [NSNotification notificationWithName:@"RefreshCustomerTable" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:LoseResponse];
            
            [self.xp_rootNavigationController popViewControllerAnimated:YES];
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        [XHToast showBottomWithText:error];
    }];
}



- (WLCardNoFormatter *)cardNoFormatter {
    if(_cardNoFormatter == nil) {
        _cardNoFormatter = [[WLCardNoFormatter alloc] init];
    }
    return _cardNoFormatter;
}

@end
