//
//  HCBalancePaymentsCell.h
//  HC
//
//  Created by tuibao on 2021/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCBalancePaymentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UIImageView *bg_image;

@property (weak, nonatomic) IBOutlet UIImageView *delete_image;
@property (weak, nonatomic) IBOutlet UIImageView *yinlian_image;
@property (weak, nonatomic) IBOutlet UIImageView *yinhang_image;

@property (weak, nonatomic) IBOutlet UILabel *title_lab;
@property (weak, nonatomic) IBOutlet UILabel *content_lab;

@property (weak, nonatomic) IBOutlet UILabel *jihua_lab;
@property (weak, nonatomic) IBOutlet UILabel *lishi_lab;

@property (weak, nonatomic) IBOutlet UILabel *zhiding_jihua_lab;
@property (weak, nonatomic) IBOutlet UIView *line_view;

//进度值
@property (assign, nonatomic) CGFloat progress;

@end

NS_ASSUME_NONNULL_END
