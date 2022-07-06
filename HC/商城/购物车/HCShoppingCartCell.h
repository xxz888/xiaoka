//
//  HCShoppingCartCell.h
//  HC
//
//  Created by tuibao on 2021/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCShoppingCartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bg_view;

@property (weak, nonatomic) IBOutlet UIImageView *min_icon;

@property (weak, nonatomic) IBOutlet UILabel *title_lab;

@property (weak, nonatomic) IBOutlet UIImageView *select_icon;

@property (weak, nonatomic) IBOutlet UIImageView *max_icon;

@property (weak, nonatomic) IBOutlet UILabel *name_lab;

@property (weak, nonatomic) IBOutlet UILabel *price_lab;

@property (weak, nonatomic) IBOutlet UILabel *number_lab;

@property (weak, nonatomic) IBOutlet UIImageView *clean_but;

@end

NS_ASSUME_NONNULL_END
