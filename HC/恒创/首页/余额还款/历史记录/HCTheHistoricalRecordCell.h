//
//  HCTheHistoricalRecordCell.h
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCTheHistoricalRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bg_view;

@property (weak, nonatomic) IBOutlet UIImageView *log_image;
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UILabel *type_lab;

@property (weak, nonatomic) IBOutlet UILabel *bishu_lab;

@property (weak, nonatomic) IBOutlet UILabel *hk_type_lab;
@property (weak, nonatomic) IBOutlet UILabel *zd_amount_lab;

@property (weak, nonatomic) IBOutlet UILabel *sy_ShouldAlso_lab;

@property (weak, nonatomic) IBOutlet UILabel *time_lab;

@property (weak, nonatomic) IBOutlet UILabel *order_lab;


@end

NS_ASSUME_NONNULL_END
