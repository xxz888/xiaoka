//
//  HCBuyDownCell.h
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCBuyDownCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UILabel *quanyi_lab;

@property (weak, nonatomic) IBOutlet UILabel *quanyi_ma_lab;

@property (weak, nonatomic) IBOutlet UILabel *pingtai_lab;
@property (weak, nonatomic) IBOutlet UILabel *number_lab;
@property (weak, nonatomic) IBOutlet UILabel *time_lab;

@end

NS_ASSUME_NONNULL_END
