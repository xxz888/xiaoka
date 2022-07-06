//
//  MCAccreditation2ViewController.m
//  OEMSDK
//
//  Created by apple on 2020/10/30.
//

#import "MCAccreditation2ViewController.h"



#define ZhengMian_FailString @"身份证正面识别失败"
#define FanMian_FailString   @"身份证反面识别失败"

#define ZhengMian @"身份证正面"
#define FanMian   @"身份证反面"
@interface MCAccreditation2ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    BOOL isSFZz;//身份证正面
    BOOL isSFZf;//身份证反面
}
@property(strong,nonatomic)NSString * address;

@property(assign,nonatomic)NSString * zhengmianfanmian;



@end

@implementation MCAccreditation2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}
-(void)setUI{
    isSFZz = NO;
    isSFZf = NO;
    //选择省
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhengmianAction:)];
    [self.zhengImv addGestureRecognizer:tap1];
    //选择市
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fanmianAction:)];
    [self.fanImv addGestureRecognizer:tap2];
    //添加约束
    [self loadUI];
    
}

- (IBAction)backfanhuiAction:(id)sender {
    [self backToAppointedController:[HCHomeViewController new]];
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
-(void)zhengmianAction:(id)sender{
    [self showSheet:ZhengMian];
}
#pragma mark -----------向服务器上传身份证正面---------------
-(void)upLoadZhengMian:(UIImage *)img{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:img forKey:@"file"];
    
    [self NetWorkingPostWithImageURL:self hiddenHUD:NO url:@"/api/user/ocr/front/upload" Params:params success:^(id  _Nonnull responseObject) {
        NSDictionary *data = responseObject[@"data"];
        
        if ([data[@"code"] intValue] == 0) {
            self->isSFZz = YES;
            self.nameTf.text = data[@"name"];
            self.idTf.text = data[@"number"];
            self.zhengImv.image = img;
        }else{
            [XHToast showBottomWithText:data[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        [XHToast showBottomWithText:error];
    }];
    
    
}
#pragma mark -----------点击上传身份证反面照片---------------
-(void)fanmianAction:(id)sender{
    [self showSheet:FanMian];
}
#pragma mark -----------向服务器上传身份证反面---------------
-(void)upLoadFanMian:(UIImage *)img{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:img forKey:@"file"];
    
    
    [self NetWorkingPostWithImageURL:self hiddenHUD:YES url:@"/api/user/ocr/back/upload" Params:params success:^(id  _Nonnull responseObject) {
        
        if ([responseObject[@"code"] intValue] == 0) {
            self->isSFZf = YES;
            self.fanImv.image = img;
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        [XHToast showBottomWithText:error];
    }];
    

}

#pragma mark -----------点击完成跳转活物识别界面---------------
- (IBAction)finishAction:(id)sender {
  
    
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
    if ([self.nameTf.text isEqualToString:@""]) {
        [XHToast showBottomWithText:@"请输入正确的姓名"];
        return;
    }
    //监测身份证号
    if ([self.idTf.text isEqualToString:@""] || [self.idTf.text length] != 18) {
        [XHToast showBottomWithText:@"请输入正确的身份证号"];
        return;
    }
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.nameTf.text forKey:@"fullname"];
    [params setValue:self.idTf.text forKey:@"idcard"];

    [self NetWorkingPostWithURL:self hiddenHUD:YES url:@"/api/user/idcard/update" Params:params success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            
            MCAccreditation3ViewController *VC = [MCAccreditation3ViewController new];
            
            VC.user_name = self.nameTf.text;
            
            [self.xp_rootNavigationController pushViewController:VC animated:YES];
            
        }else{
            [XHToast showBottomWithText:responseObject[@"message"]];
        }
    } failure:^(NSString * _Nonnull error) {
        [XHToast showBottomWithText:error];
    }];
    
    
    
    
    
    
}


- (void)loadUI{
    
    [self.top_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(Ratio(161));
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
    
    
    
    
    [self.tishi_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top_image.mas_bottom).offset(Ratio(26));
        make.left.offset(16);
    }];
    
    [self.zhengImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(162, 139.5));
        make.top.equalTo(self.tishi_lab.mas_bottom).offset(Ratio(17));
        make.left.offset((DEVICE_WIDTH - 324)/3);
    }];
    [self.fanImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(162, 139.5));
        make.top.equalTo(self.tishi_lab.mas_bottom).offset(Ratio(17));
        make.left.equalTo(self.zhengImv.mas_right).offset((DEVICE_WIDTH - 324)/3);
    }];
    
    [self.nama_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 46));
        make.top.equalTo(self.zhengImv.mas_bottom).offset(Ratio(40));
        make.left.offset(16);
    }];
    [self.name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 26));
        make.centerY.equalTo(self.nama_view);
        make.left.offset(0);
    }];
    [self.nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    
    [self.id_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 46));
        make.top.equalTo(self.nama_view.mas_bottom).offset(Ratio(10));
        make.left.offset(16);
    }];
    [self.id_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 26));
        make.centerY.equalTo(self.id_view);
        make.left.offset(0);
    }];
    [self.idTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.centerY.equalTo(self.id_view);
        make.left.equalTo(self.id_lab.mas_right).offset(2);
        make.right.offset(-10);
    }];
    [self.id_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 0.5));
        make.top.equalTo(self.id_view.mas_bottom).offset(0);
        make.left.offset(16);
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-32, 46));
        make.left.offset(16);
        make.top.equalTo(self.id_line.mas_bottom).offset(50);
    }];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
@end
