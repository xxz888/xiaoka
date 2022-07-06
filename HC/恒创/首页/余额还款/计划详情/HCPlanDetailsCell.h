//
//  HCPlanDetailsCell.h
//  HC
//
//  Created by tuibao on 2021/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCPlanDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *xuxian_image;

@property (weak, nonatomic) IBOutlet UIImageView *image_img;

@property (weak, nonatomic) IBOutlet UILabel *time_lab;

@property (weak, nonatomic) IBOutlet UILabel *type_lab;

@property (weak, nonatomic) IBOutlet UILabel *money_lab;

@property (weak, nonatomic) IBOutlet UILabel *plan_type_lab;

@end

NS_ASSUME_NONNULL_END
