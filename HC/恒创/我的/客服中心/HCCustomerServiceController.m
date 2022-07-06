//
//  HCCustomerServiceController.m
//  HC
//
//  Created by tuibao on 2021/11/18.
//

#import "HCCustomerServiceController.h"
#import "HCCustomerServiceCell.h"
#import "HCOnlineController.h"
@interface HCCustomerServiceController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(strong, nonatomic) UIImageView *top_imageView;
@property(strong, nonatomic) UILabel *top_tishi1_lab;
@property(strong, nonatomic) UILabel *top_tishi2_lab;

@property(strong, nonatomic) UIView *content_Views;
@property(strong, nonatomic) UIImageView *content_bg_image;
@property(strong, nonatomic) UIImageView *content_HeadPortrait;
@property(strong, nonatomic) UILabel *content_title;
@property(strong, nonatomic) UILabel *content_members;
@property(strong, nonatomic) UILabel *content_recommended;

@property (nonatomic , strong) UICollectionView *collectionview;
@property(strong, nonatomic) NSArray *TitleArr;

@property(strong, nonatomic) UILabel *tishi_lab;

@property(strong, nonatomic) NSDictionary *UserData;
@end

@implementation HCCustomerServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"客服中心"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self LoadUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self LoadData];
}
- (void)LoadData{
    
    // 得到个人信息，
    self.UserData = [self loadUserData];
    
    self.content_title.text = [self.UserData[@"fullname"] length] == 0 ? @"未实名" : self.UserData[@"fullname"];
    
    if ([self.UserData[@"vipLevel"] intValue] == 0) {
        self.content_members.text = @"普通";
        [self.content_members mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(30);
        }];
    }else{
        self.content_members.text = [NSString stringWithFormat:@"V%@",self.UserData[@"vipLevel"]];
        [self.content_members mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(20);
        }];
    }
    
    self.content_recommended.text = [NSString stringWithFormat:@"推荐码：%@",self.UserData[@"username"]];
    
    
    [self.collectionview reloadData];
}

- (void)LoadUI{
    
    
    self.TitleArr = [NSArray arrayWithObjects:
                     @{@"name":@"在线客服",@"image":@"icon_kefu_zaixian",@"content":@"售前售后客服\n时间：09:00-18:00"},
                     @{@"name":@"客服微信",@"image":@"icon_kefu_qq",@"content":@"493883049\n时间：09:00-18:00"},
                     @{@"name":@"推荐人",@"image":@"icon_kefu_tuijianren",@"content":[NSString stringWithFormat:@"手机号：%@",[NSString getSecrectStringWithPhoneNumber:self.UserData[@"preUserPhone"]]]},
                     @{@"name":@"官方留言",@"image":@"icon_kefu_liuyan",@"content":@"非工作时间\n请选择在线留言"}, nil];
    
    [self.view addSubview:self.content_bg_image];
    [self.content_bg_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset(0);
        make.height.offset(0.5);
    }];
    
    [self.view addSubview:self.top_imageView];
    [self.top_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, Ratio(116.5)));
        make.top.offset(0.5);
        make.right.left.offset(0);
    }];
    
    [self.view addSubview:self.top_tishi1_lab];
    [self.top_tishi1_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top_imageView.mas_top).offset(Ratio(22.5));
        make.left.offset(72.5);
    }];

    [self.view addSubview:self.top_tishi2_lab];
    [self.top_tishi2_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top_tishi1_lab.mas_bottom).offset(6.5);
        make.left.offset(72.5);
    }];
    
    
    [self.view addSubview:self.content_Views];
    [self.content_Views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 72));
        make.left.offset(15);
        make.top.equalTo(self.top_imageView.mas_bottom).offset(-36);
    }];
    
    

    
    
    self.content_HeadPortrait.layer.masksToBounds = YES;
    self.content_HeadPortrait.layer.cornerRadius = 24;
    [self.content_Views addSubview:self.content_HeadPortrait];
    [self.content_HeadPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(48, 48));
        make.left.equalTo(self.content_Views.mas_left).offset(13);
        make.centerY.equalTo(self.content_Views);
    }];
    
    
    [self.content_Views addSubview:self.content_title];
    [self.content_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content_HeadPortrait.mas_right).offset(13);
        make.centerY.equalTo(self.content_HeadPortrait);
    }];


    self.content_members.layer.masksToBounds = YES;
    self.content_members.layer.cornerRadius = 10;
    [self.content_Views addSubview:self.content_members];
    [self.content_members mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.content_title.mas_right).offset(2);
        make.centerY.equalTo(self.content_title);
    }];
    
    [self.content_Views addSubview:self.content_recommended];
    [self.content_recommended mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.content_Views.mas_right).offset(-13);
        make.centerY.equalTo(self.content_HeadPortrait);
    }];
    
    [self.view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.height.offset(260);
        make.top.equalTo(self.content_Views.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
    }];
    
    [self.view addSubview:self.tishi_lab];
    [self.tishi_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH-30);
        make.height.offset(60);
        make.top.equalTo(self.collectionview.mas_bottom).offset(0);
        make.centerX.equalTo(self.view);
    }];
    
    
    
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}
//设置方块的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cell";
    HCCustomerServiceCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    cell.name_lab.text = self.TitleArr[indexPath.row][@"name"];
    cell.top_image.image = [UIImage imageNamed:self.TitleArr[indexPath.row][@"image"]];
    
    if (indexPath.row == 2) {
        cell.content_lab.text = [NSString stringWithFormat:@"手机号：%@",[NSString getSecrectStringWithPhoneNumber:self.UserData[@"preUserPhone"]]];
    }else{
        cell.content_lab.text = self.TitleArr[indexPath.row][@"content"];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
//cell被选中会调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        
        //弹出选项列表
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"打开QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            //是否安装QQ http://shang.qq.com 免费开通推广
//              if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){
//
//                 //用来接收临时消息的客服QQ号码(注意此QQ号需开通QQ推广功能,否则陌生人向他发送消息会失败)
//                 NSString *QQ = @"493883049";
//                 //调用QQ客户端,发起QQ临时会话
//                 NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ];
//
//                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
//
//              }else{
//                  [XHToast showBottomWithText:@"您的设备未安装QQ聊天软件"];
//              }
//        }];
        UIAlertAction *identifyAction = [UIAlertAction actionWithTitle:@"打开微信并复制客服微信号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = @"493883049";
            
            NSURL * url = [NSURL URLWithString:@"weixin://"];
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
            //先判断是否能打开该url
            if (canOpen){
                //打开微信
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }else {
                [XHToast showBottomWithText:@"您的设备未安装微信APP"];
            }
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
//        [alert addAction:saveAction];
        [alert addAction:identifyAction];
        [alert addAction:cancelAction];

        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (indexPath.row == 0){
        [self.xp_rootNavigationController pushViewController:[HCOnlineController new] animated:YES];
    }else if (indexPath.row == 2){
        if ([self.UserData[@"preUserPhone"] stringValue].length > 0) {
            //拨打电话
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.UserData[@"preUserPhone"]]] options:@{} completionHandler:nil];
        }
    }else{
        [XHToast showBottomWithText:@"暂未开放"];
    }
}

#pragma mark - 懒加载
- (UICollectionView *)collectionview{
    if (!_collectionview) {
        
        CGFloat W = (DEVICE_WIDTH - 15) / 2;
        
        // 1.创建流水布局
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.itemSize = CGSizeMake(W,120);
        
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionview.backgroundColor = [UIColor whiteColor];
        _collectionview.showsVerticalScrollIndicator = NO;
        //注册Cell
        [self.collectionview registerNib:[UINib nibWithNibName:@"HCCustomerServiceCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        
    }
    return _collectionview;
}

- (UIImageView *)top_imageView{
    if (!_top_imageView) {
        _top_imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_kefu_bg"]];
    }
    return _top_imageView;
}
- (UIView *)content_Views{
    if (!_content_Views) {
        _content_Views = [UIView new];
        self.content_Views.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        self.content_Views.layer.shadowOffset = CGSizeMake(0, 0.3);// 阴影偏移，默认(0, -3)
        self.content_Views.layer.shadowOpacity = 0.2;// 阴影透明度，默认0
        self.content_Views.layer.shadowRadius = 3;// 阴影半径，默认3
        self.content_Views.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
        self.content_Views.layer.cornerRadius = 10;
    }
    return _content_Views;
}
- (UIImageView *)content_bg_image{
    if (!_content_bg_image) {
        _content_bg_image = [[UIImageView alloc]init];
        _content_bg_image.backgroundColor = [UIColor colorWithHexString:@"#f9bb00"];
    }
    return _content_bg_image;
}

- (UIImageView *)content_HeadPortrait{
    if (!_content_HeadPortrait) {
        _content_HeadPortrait = [UIImageView getUIImageView:@"icon_touxiang"];
    }
    return _content_HeadPortrait;
}

- (UILabel *)content_title{
    if (!_content_title) {
        _content_title = [UILabel new];
        _content_title.text = @"熊威";
        _content_title.font = [UIFont getUIFontSize:18 IsBold:YES];
        _content_title.textColor = FontThemeColor;
    }
    return _content_title;
}
- (UILabel *)content_members{
    if (!_content_members) {
        _content_members = [UILabel new];
        _content_members.text = @"V1";
        _content_members.textAlignment = NSTextAlignmentCenter;
        _content_members.font = [UIFont getUIFontSize:10 IsBold:YES];
        _content_members.backgroundColor = [UIColor colorWithHexString:@"#F9D8AE"];
        _content_members.textColor = [UIColor colorWithHexString:@"#FEFEFE"];
    }
    return _content_members;
}
- (UILabel *)content_recommended{
    if (!_content_recommended) {
        _content_recommended = [UILabel new];
        _content_recommended.text = @"推荐码：";
        _content_recommended.font = [UIFont getUIFontSize:12 IsBold:YES];
        _content_recommended.textColor = FontThemeColor;
        _content_recommended.textAlignment = NSTextAlignmentRight;
    }
    return _content_recommended;
}

- (UILabel *)tishi_lab{
    if (!_tishi_lab) {
        _tishi_lab = [UILabel new];
        _tishi_lab.text = [NSString stringWithFormat:@"温馨提示:\n为了更快速的解答您的问题,建议优先点击“在线客服”，同时把您的注册手机号姓名和相关问题及时发送，谢谢。"];
        _tishi_lab.font = [UIFont getUIFontSize:10 IsBold:YES];
        _tishi_lab.textColor = [UIColor colorWithHexString:@"#666666"];
        _tishi_lab.numberOfLines = 5;
    }
    return _tishi_lab;
}
- (UILabel *)top_tishi1_lab{
    if (!_top_tishi1_lab) {
        _top_tishi1_lab = [UILabel new];
        _top_tishi1_lab.text = [NSString stringWithFormat:@"安全无风险"];
        _top_tishi1_lab.font = [UIFont getUIFontSize:18 IsBold:YES];
        _top_tishi1_lab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _top_tishi1_lab;
}

- (UILabel *)top_tishi2_lab{
    if (!_top_tishi2_lab) {
        _top_tishi2_lab = [UILabel new];
        _top_tishi2_lab.text = [NSString stringWithFormat:@"一站式信用卡还款平台"];
        _top_tishi2_lab.font = [UIFont getUIFontSize:12 IsBold:NO];
        _top_tishi2_lab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _top_tishi2_lab;
}


@end
