//
//  HCHelpController.m
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import "HCHelpController.h"
#import "HCHelpTableViewCell.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface HCHelpController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSArray *dataArr;

@end

@implementation HCHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"使用帮助";
    [self LoadUI];
    [self LoadData];
}
- (void)LoadData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:brandId forKey:@"brandId"];
    [self NetWorkingPostWithAddressURL:self hiddenHUD:NO url:@"/api/user/guide/title/list" Params:dic success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            
            self.dataArr = [NSArray arrayWithArray:responseObject[@"data"]];
            
            [self.tableView reloadData];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

- (void)LoadTheVideo:(NSString *)title{
    
    [self NetWorkingPostWithURL:self hiddenHUD:NO url:[NSString stringWithFormat:@"/api/user/guide/get/%@",title] Params:[NSDictionary dictionary] success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 0) {
            [self PlayTheVideo:responseObject[@"data"]];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}

- (void)PlayTheVideo:(NSString *)URLStr{
    
    //步骤1：获取视频路径
    NSString *webVideoPath = URLStr;
    NSURL*webVideoUrl = [NSURL URLWithString:webVideoPath];
    //步骤2：创建AVPlayer
    AVPlayer * avPlayer = [[AVPlayer alloc]initWithURL:webVideoUrl];
    //步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
    AVPlayerViewController *avPlayerVC =[[AVPlayerViewController alloc] init];
    avPlayerVC.player = avPlayer;
    [self presentViewController:avPlayerVC animated:YES completion:nil];
    
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"HCHelpTableViewCell";
    HCHelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HCHelpTableViewCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.name.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    [self LoadTheVideo:dic[@"id"]];
    
}



- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"tableView_Placeholder"];
}
#pragma 无数据点击刷新
-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self LoadData];
}
- (void)LoadUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(DEVICE_WIDTH);
        make.left.offset(0);
        make.top.offset(0);
        make.bottom.offset(-KBottomHeight);
    }];
}

#pragma 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
@end
