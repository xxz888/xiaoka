//
//  MCAccreditation4ViewController.m
//  OEMSDK
//
//  Created by tuibao on 2021/11/4.
//

#import "MCAccreditation4ViewController.h"

@interface MCAccreditation4ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

//识别到的银行卡数据
@property (nonatomic , strong) NSDictionary *savingsCard;
@property (strong, nonatomic) WLCardNoFormatter *cardNoFormatter;


//省/直辖市
@property (nonatomic , strong) NSString *provinceAddress;
//市
@property (nonatomic , strong) NSString *cityAddress;

@end

@implementation MCAccreditation4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.provinceAddress = @"";
    self.cityAddress = @"";
    //添加约束
    [self loadUI];
    [self GetTheAddress];
}

#pragma 确定绑定
- (void)FbottomAction{
    

    if([NSString isBlankString:self.name_textField.text]){
        [XHToast showBottomWithText:@"账户姓名不能为空"];
        return;
    }
    if([NSString isBlankString:self.kahao_textField.text]){
        [XHToast showBottomWithText:@"银行卡号不能为空"];
        return;
    }
    if([NSString isBlankString:self.huhang_textField.text]){
        [XHToast showBottomWithText:@"开卡户地不能为空"];
        return;
    }
    if([NSString isBlankString:self.phone_textField.text]){
        [XHToast showBottomWithText:@"手机号不能为空"];
        return;
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.name_textField.text forKey:@"fullname"];//用户名
    [params setValue:self.savingsCard[@"bank_name"] forKey:@"bankName"];//银行卡名称
    [params setValue:[self.kahao_textField.text RemoveTheBlankSpace:self.kahao_textField.text] forKey:@"bankcard"];//银行卡号
    [params setValue:self.huhang_textField.text forKey:@"provinceCity"];//开户地
    [params setValue:self.phone_textField.text forKey:@"phone"];//预留手机号
    
//    [params setValue:@"杨波" forKey:@"fullname"];//用户名
//    [params setValue:@"农业银行" forKey:@"bankName"];//银行卡名称
//    [params setValue:@"6230521350046116477" forKey:@"bankcard"];//银行卡号
//    [params setValue:@"重庆市" forKey:@"provinceCity"];//开户地
//    [params setValue:@"18530619666" forKey:@"phone"];//预留手机号
    
    NSLog(@"data:%@",params);
    
    
    
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:@"/api/user/bind/debit/card" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [XHToast showBottomWithText:responseObject[@"message"]];
            
            [self backAction];
            
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        [XHToast showBottomWithText:error];
    }];
    
 
}

#pragma 识别储蓄卡图片
- (void)getAddCardDate:(UIImage *)image{
    @weakify(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:image forKey:@"file"];
    
    [self NetWorkingPostWithImageURL:self hiddenHUD:NO url:@"/api/user/ocr/bankcard" Params:params success:^(id  _Nonnull responseObject){
        
        if ([responseObject[@"code"] intValue] == 0) {
            NSDictionary *data = responseObject[@"data"];
            if ([[data allKeys] containsObject:@"card_type"]) {
                if ([data[@"card_type"] isEqualToString:@"借记卡"]) {
                    weak_self.savingsCard = [NSDictionary dictionaryWithDictionary:data];
                    [weak_self AddModelData];
                    weak_self.kapian_image.image = image;
                }else{
                    [XHToast showBottomWithText:@"请用储蓄卡识别"];
                }
            }else{
                [XHToast showBottomWithText:@"识别错误，请重试！"];
            }
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        [XHToast showBottomWithText:error];
    }];
    
}

#pragma 得到储蓄卡数据
- (void)AddModelData{
    //银行卡号
    self.kahao_textField.text = self.savingsCard[@"card_number"];
}

- (void)showSheet{
    
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
        [self getAddCardDate:image];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)loadUI{
    
    
    [self.view addSubview:self.top_image];
    [self.view addSubview:self.navigation_View];
    [self.view addSubview:self.nav_back];
    [self.view addSubview:self.nav_title];
    [self.view addSubview:self.sfz_image];
    [self.view addSubview:self.left_line_View];
    [self.view addSubview:self.rlsb_image];
    [self.view addSubview:self.right_line_View];
    [self.view addSubview:self.xyk_image];
    [self.view addSubview:self.sfz_lab];
    [self.view addSubview:self.rlsb_lab];
    [self.view addSubview:self.txyk_lab];
    [self.view addSubview:self.tishi_view];
    [self.tishi_view addSubview:self.tishi_lab1];
    [self.view addSubview:self.tishi_lab2];
    [self.view addSubview:self.kapian_image];
    
    [self.view addSubview:self.nama_view];
    [self.nama_view addSubview:self.name_lab];
    [self.nama_view addSubview:self.name_textField];
    [self.view addSubview:self.nama_line];
    
    [self.view addSubview:self.kahao_view];
    [self.kahao_view addSubview:self.kahao_lab];
    [self.kahao_view addSubview:self.kahao_textField];
    [self.kahao_view addSubview:self.kahao_tishi_lab];
    [self.view addSubview:self.kahao_line];
    
    [self.view addSubview:self.huhang_view];
    [self.huhang_view addSubview:self.huhang_lab];
    [self.huhang_view addSubview:self.huhang_textField];
    [self.view addSubview:self.huhang_line];
    
    [self.view addSubview:self.phone_view];
    [self.phone_view addSubview:self.phone_lab];
    [self.phone_view addSubview:self.phone_textField];
    
    [self.view addSubview:self.finishBtn];
    
    
    double topimage_H = 161;
    if(![[self.xp_rootNavigationController.viewControllers objectAtIndex:self.xp_rootNavigationController.viewControllers.count-2] isKindOfClass:[MCAccreditation3ViewController class]]){
        [self.sfz_lab setHidden:YES];
        [self.sfz_image setHidden:YES];
        [self.rlsb_image setHidden:YES];
        [self.rlsb_lab setHidden:YES];
        [self.xyk_image setHidden:YES];
        [self.txyk_lab setHidden:YES];
        [self.left_line_View setHidden:YES];
        [self.right_line_View setHidden:YES];
        
        topimage_H = kTopHeight;
    }
    
    
    [self.top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(topimage_H);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    
    [self.navigation_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 44));
        make.top.equalTo(self.top_image.mas_top).offset(kStatusBarHeight);
        make.left.equalTo(self.view);
    }];
    

    [self.nav_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.centerY.equalTo(self.navigation_View);
    }];
    [self.nav_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navigation_View);
    }];
    
    [self.rlsb_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(self.top_image.mas_top).offset(Ratio(100));
        make.centerX.equalTo(self.view);
    }];
    [self.rlsb_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rlsb_image.mas_bottom).offset(Ratio(7.5));
        make.centerX.equalTo(self.rlsb_image);
    }];
    
    
    [self.sfz_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.rlsb_image);
        make.left.offset(61);
    }];
    [self.sfz_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sfz_image.mas_bottom).offset(Ratio(7.5));
        make.centerX.equalTo(self.sfz_image);
    }];
    
    [self.xyk_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.rlsb_image);
        make.right.equalTo(self.top_image.mas_right).offset(-61);
    }];
    [self.txyk_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyk_image.mas_bottom).offset(Ratio(7.5));
        make.centerX.equalTo(self.xyk_image);
    }];
    
    [self.left_line_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.centerY.equalTo(self.rlsb_image);
        make.left.equalTo(self.sfz_image.mas_right).offset(5);
        make.right.equalTo(self.rlsb_image.mas_left).offset(-5);
    }];
    
    [self.right_line_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.centerY.equalTo(self.rlsb_image);
        make.left.equalTo(self.rlsb_image.mas_right).offset(5);
        make.right.equalTo(self.xyk_image.mas_left).offset(-5);
    }];
    
    
    
    
    
    
    [self.tishi_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, Ratio(42.5)));
        make.top.equalTo(self.top_image.mas_bottom).offset(0);
        make.centerX.equalTo(self.view);
    }];
    [self.tishi_lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-40, Ratio(40)));
        make.center.equalTo(self.tishi_view);
    }];
    
    [self.tishi_lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-40, Ratio(40)));
        make.top.equalTo(self.tishi_view.mas_bottom).offset(0);
        make.centerX.equalTo(self.tishi_view);
    }];
    
    [self.kapian_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(216, 129.5));
        make.top.equalTo(self.tishi_lab2.mas_bottom).offset(Ratio(10));
        make.centerX.equalTo(self.tishi_view);
    }];
    
    
    [self.nama_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 46));
        make.top.equalTo(self.kapian_image.mas_bottom).offset(Ratio(5));
        make.left.offset(16);
    }];
    [self.name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 26));
        make.centerY.equalTo(self.nama_view);
        make.left.offset(0);
    }];
    [self.name_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.centerY.equalTo(self.nama_view);
        make.left.equalTo(self.name_lab.mas_right).offset(2);
        make.right.offset(-10);
    }];
    
    [self.nama_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 0.5));
        make.top.equalTo(self.nama_view.mas_bottom).offset(0);
        make.left.offset(16);
    }];
    
    [self.kahao_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 56));
        make.top.equalTo(self.nama_line.mas_bottom).offset(Ratio(5));
        make.left.offset(16);
    }];
    [self.kahao_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.top.equalTo(self.kahao_view.mas_top).offset(8);
        make.left.offset(0);
    }];
    [self.kahao_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.centerY.equalTo(self.kahao_lab);
        make.left.equalTo(self.kahao_lab.mas_right).offset(2);
        make.right.offset(-10);
    }];
    [self.kahao_tishi_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.kahao_lab.mas_bottom).offset(8);
        make.left.offset(0);
    }];
    [self.kahao_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 0.5));
        make.top.equalTo(self.kahao_view.mas_bottom).offset(0);
        make.left.offset(16);
    }];
    
    [self.huhang_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 46));
        make.top.equalTo(self.kahao_line.mas_bottom).offset(Ratio(5));
        make.left.offset(16);
    }];
    [self.huhang_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 26));
        make.centerY.equalTo(self.huhang_view);
        make.left.offset(0);
    }];
    [self.huhang_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.centerY.equalTo(self.huhang_view);
        make.left.equalTo(self.huhang_lab.mas_right).offset(2);
        make.right.offset(-10);
    }];
    [self.huhang_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 0.5));
        make.top.equalTo(self.huhang_view.mas_bottom).offset(0);
        make.left.offset(16);
    }];
    
    [self.phone_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 46));
        make.top.equalTo(self.huhang_line.mas_bottom).offset(Ratio(5));
        make.left.offset(16);
    }];
    [self.phone_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 26));
        make.centerY.equalTo(self.phone_view);
        make.left.offset(0);
    }];
    [self.phone_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.centerY.equalTo(self.phone_view);
        make.left.equalTo(self.phone_lab.mas_right).offset(2);
        make.right.offset(-10);
    }];
    

    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 46));
        make.left.offset(16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-(KBottomHeight + 16.0));
    }];
    self.kahao_textField.delegate = self;
    self.phone_textField.delegate = self;
}

- (void)backAction{
    if([[self.xp_rootNavigationController.viewControllers objectAtIndex:self.xp_rootNavigationController.viewControllers.count-2] isKindOfClass:[MCAccreditation3ViewController class]]){
        [self backToAppointedController:[HCHomeViewController new]];
    }else{
        //发出通知
        NSNotification *LoseResponse = [NSNotification notificationWithName:@"RefreshCardTable" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:LoseResponse];
        [self.xp_rootNavigationController popViewControllerAnimated:YES];
    }
    
}

#pragma 调起地址选择
- (void)AddressAction{
    ///自定义
    KisZDYPickerView *PickerView = [[KisZDYPickerView alloc]init];
    PickerView.provinceAddress = self.provinceAddress;
    PickerView.cityAddress = self.cityAddress;
    
    PickerView.Block = ^(NSDictionary *startDic, NSDictionary *endDic) {
        self.huhang_textField.text = [NSString stringWithFormat:@"%@-%@",startDic[@"name"],endDic[@"name"]];
    };
    [PickerView show];
}
#pragma 获取定位地址
- (void)GetTheAddress{
    @weakify(self);
    [self addLocationManager:^(NSString * _Nonnull province, NSString * _Nonnull city) {
        weak_self.provinceAddress = province;
        weak_self.cityAddress = city;
        weak_self.huhang_textField.text = [NSString stringWithFormat:@"%@-%@",province,city];
    }];
}


#pragma 懒加载
- (UIImageView *)top_image{
    if (!_top_image) {
        _top_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HC_TOP_bg"]];
    }
    return _top_image;
}
- (UIView *)navigation_View{
    if (!_navigation_View) {
        _navigation_View = [UIView new];
    }
    return _navigation_View;
}
- (UIButton *)nav_back{
    if (!_nav_back) {
        _nav_back = [UIButton new];
        [_nav_back setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_nav_back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_nav_back setEnlargeEdgeWithTop:10 right:20 bottom:10 left:10];
    }
    return _nav_back;
}
- (UILabel *)nav_title{
    if (!_nav_title) {
        _nav_title = [UILabel new];
        _nav_title.text = @"绑定结算卡";
        _nav_title.textColor = FontThemeColor;
        _nav_title.font = [UIFont boldSystemFontOfSize:18];
    }
    return _nav_title;
}


- (UIImageView *)sfz_image{
    if (!_sfz_image) {
        _sfz_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HC_top_unselect"]];
    }
    return _sfz_image;
}
- (UIView *)left_line_View{
    if (!_left_line_View) {
        _left_line_View = [UIView new];
        _left_line_View.backgroundColor = [UIColor whiteColor];
    }
    return _left_line_View;
}
- (UIImageView *)rlsb_image{
    if (!_rlsb_image) {
        _rlsb_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HC_top_unselect"]];
    }
    return _rlsb_image;
}
- (UIView *)right_line_View{
    if (!_right_line_View) {
        _right_line_View = [UIView new];
        _right_line_View.backgroundColor = [UIColor whiteColor];
    }
    return _right_line_View;
}
- (UIImageView *)xyk_image{
    if (!_xyk_image) {
        _xyk_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HC_top_select"]];
    }
    return _xyk_image;
}
- (UILabel *)sfz_lab{
    if (!_sfz_lab) {
        _sfz_lab = [UILabel new];
        _sfz_lab.text = @"添加身份证";
        _sfz_lab.textColor = [UIColor whiteColor];
        _sfz_lab.font = [UIFont systemFontOfSize:12];
        _sfz_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _sfz_lab;
}

- (UILabel *)rlsb_lab{
    if (!_rlsb_lab) {
        _rlsb_lab = [UILabel new];
        _rlsb_lab.text = @"人脸识别";
        _rlsb_lab.textColor = [UIColor whiteColor];
        _rlsb_lab.font = [UIFont systemFontOfSize:12];
        _rlsb_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _rlsb_lab;
}

- (UILabel *)txyk_lab{
    if (!_txyk_lab) {
        _txyk_lab = [UILabel new];
        _txyk_lab.text = @"添加结算卡";
        _txyk_lab.textColor = FontThemeColor;
        _txyk_lab.font = [UIFont systemFontOfSize:12];
        _txyk_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _txyk_lab;
}

- (UIView *)tishi_view{
    if (!_tishi_view) {
        _tishi_view = [UIView new];
        _tishi_view.backgroundColor = [UIColor colorWithHexString:@"FEDEB5"];
    }
    return _tishi_view;
}


- (UILabel *)tishi_lab1{
    if (!_tishi_lab1) {
        _tishi_lab1 = [UILabel new];
        _tishi_lab1.text = @"请添加本人储蓄卡作为结算卡，该卡作为后续刷卡、提现资金的结算账号，户名必须与实名认证姓名一致";
        _tishi_lab1.textColor = [UIColor colorWithHexString:@"666666"];
        _tishi_lab1.font = [UIFont systemFontOfSize:12];
        _tishi_lab1.numberOfLines = 2;
    }
    return _tishi_lab1;
}

- (UILabel *)tishi_lab2{
    if (!_tishi_lab2) {
        _tishi_lab2 = [UILabel new];
        _tishi_lab2.text = @"*建议:工商、农业、交通、招商、民生、华夏、平安等一类卡(不支持二类卡及地方性银行) ";
        _tishi_lab2.textColor = [UIColor colorWithHexString:@"D7A066"];
        _tishi_lab2.font = [UIFont systemFontOfSize:12];
        _tishi_lab2.numberOfLines = 2;
    }
    return _tishi_lab2;
}

- (UIImageView *)kapian_image{
    if (!_kapian_image) {
        _kapian_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HC_icon_kapian"]];
        
        _kapian_image.userInteractionEnabled = YES;
        [_kapian_image bk_whenTapped:^{
            [self showSheet];
        }];
        
    }
    return _kapian_image;
}

- (UIView *)nama_view{
    if (!_nama_view) {
        _nama_view = [UIView new];
    }
    return _nama_view;
}
- (UILabel *)name_lab{
    if (!_name_lab) {
        _name_lab = [UILabel new];
        _name_lab.text = @"账户姓名";
        _name_lab.textColor = [UIColor blackColor];
        _name_lab.font = [UIFont systemFontOfSize:15];
    }
    return _name_lab;
}
- (UITextField *)name_textField{
    if (!_name_textField) {
        _name_textField = [UITextField new];
        _name_textField.placeholder = @"请输入账户姓名";
        _name_textField.font = [UIFont systemFontOfSize:14];
        _name_textField.userInteractionEnabled = NO;
        // 得到个人信息，
        NSDictionary *UserData = [self loadUserData];
        _name_textField.text = [NSString stringWithFormat:@"%@",UserData[@"fullname"]];
        
    }
    return _name_textField;
}
- (UIView *)nama_line{
    if (!_nama_line) {
        _nama_line = [UIView new];
        _nama_line.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"];
    }
    return _nama_line;
}


- (UIView *)kahao_view{
    if (!_kahao_view) {
        _kahao_view = [UIView new];
    }
    return _kahao_view;
}

- (UILabel *)kahao_lab{
    if (!_kahao_lab) {
        _kahao_lab = [UILabel new];
        _kahao_lab.text = @"银行卡号";
        _kahao_lab.textColor = [UIColor blackColor];
        _kahao_lab.font = [UIFont systemFontOfSize:15];
    }
    return _kahao_lab;
}

- (UITextField *)kahao_textField{
    if (!_kahao_textField) {
        _kahao_textField = [UITextField new];
        _kahao_textField.placeholder = @"请扫描银行卡或输入卡号";
        _kahao_textField.font = [UIFont systemFontOfSize:14];
        _kahao_textField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        
        _kahao_textField.tag = 100;
    }
    return _kahao_textField;
}
- (UILabel *)kahao_tishi_lab{
    if (!_kahao_tishi_lab) {
        _kahao_tishi_lab = [UILabel new];
        _kahao_tishi_lab.text = @"请核对卡号信息是否正确，若有误，请手动修改";
        _kahao_tishi_lab.textColor = [UIColor colorWithHexString:@"D8A167"];
        _kahao_tishi_lab.font = [UIFont systemFontOfSize:10];
        
    }
    return _kahao_tishi_lab;
}
- (UIView *)kahao_line{
    if (!_kahao_line) {
        _kahao_line = [UIView new];
        _kahao_line.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"];
    }
    return _kahao_line;
}

- (UIView *)huhang_view{
    if (!_huhang_view) {
        _huhang_view = [UIView new];
    }
    return _huhang_view;
}

- (UILabel *)huhang_lab{
    if (!_huhang_lab) {
        _huhang_lab = [UILabel new];
        _huhang_lab.text = @"开卡户地";
        _huhang_lab.textColor = [UIColor blackColor];
        _huhang_lab.font = [UIFont systemFontOfSize:15];
    }
    return _huhang_lab;
}

- (UITextField *)huhang_textField{
    if (!_huhang_textField) {
        _huhang_textField = [UITextField new];
        _huhang_textField.placeholder = @"请选择银行开卡户地";
        _huhang_textField.font = [UIFont systemFontOfSize:14];
        [_huhang_textField bk_whenTapped:^{
            [self AddressAction];
        }];
    }
    return _huhang_textField;
}

- (UIView *)huhang_line{
    if (!_huhang_line) {
        _huhang_line = [UIView new];
        _huhang_line.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"];
    }
    return _huhang_line;
}

- (UIView *)phone_view{
    if (!_phone_view) {
        _phone_view = [UIView new];
    }
    return _phone_view;
}

- (UILabel *)phone_lab{
    if (!_phone_lab) {
        _phone_lab = [UILabel new];
        _phone_lab.text = @"手机号";
        _phone_lab.textColor = [UIColor blackColor];
        _phone_lab.font = [UIFont systemFontOfSize:15];
    }
    return _phone_lab;
}

- (UITextField *)phone_textField{
    if (!_phone_textField) {
        _phone_textField = [UITextField new];
        _phone_textField.placeholder = @"请输入银行卡绑定的手机号";
        _phone_textField.font = [UIFont systemFontOfSize:14];
        
        _phone_textField.tag = 200;
        _phone_textField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        
    }
    return _phone_textField;
}
// 显示长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if ( textField.tag == 200 && self.phone_textField.text.length > 10 && ![string isEqualToString:@""]) {
        return NO;
    }else if(textField.tag == 100){
        [self.cardNoFormatter bankNoField:textField shouldChangeCharactersInRange:range replacementString:string];
        return NO;
    }
    return YES;
}


- (WLCardNoFormatter *)cardNoFormatter {
    if(_cardNoFormatter == nil) {
        _cardNoFormatter = [[WLCardNoFormatter alloc] init];
    }
    return _cardNoFormatter;
}

- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton new];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"KD_BindCardBtn"] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"确定绑卡" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_finishBtn addTarget:self action:@selector(FbottomAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _finishBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

@end
