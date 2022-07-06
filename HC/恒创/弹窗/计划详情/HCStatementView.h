//
//  HCStatementView.h
//  HC
//
//  Created by tuibao on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCStatementView : UIView

@property (weak, nonatomic) IBOutlet UIButton *clean_btn;
@property (weak, nonatomic) IBOutlet UILabel *title_lab;

@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UIImageView *bg_image;

@property (weak, nonatomic) IBOutlet UIView *conent_view;

@property (weak, nonatomic) IBOutlet UILabel *order_lab;

@property (weak, nonatomic) IBOutlet UILabel *jine_lab;

@property (weak, nonatomic) IBOutlet UILabel *shouxufei_lab;

@property (weak, nonatomic) IBOutlet UILabel *leixing_lab;

@property (weak, nonatomic) IBOutlet UILabel *miaoshu_lab;

@property (weak, nonatomic) IBOutlet UILabel *shijian_lab;

@property (weak, nonatomic) IBOutlet UILabel *shibai_lab;

@property (weak, nonatomic) IBOutlet UILabel *feilv_lab;

@property (weak, nonatomic) IBOutlet UILabel *zhuangtai_lab;

@end

NS_ASSUME_NONNULL_END
