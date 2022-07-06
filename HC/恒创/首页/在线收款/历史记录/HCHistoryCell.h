//
//  HCHistoryCell.h
//  HC
//
//  Created by tuibao on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UIImageView *icon_image;
@property (weak, nonatomic) IBOutlet UILabel *title_lab;
@property (weak, nonatomic) IBOutlet UILabel *content_number_lab;

@property (weak, nonatomic) IBOutlet UILabel *content_lab;
@property (weak, nonatomic) IBOutlet UILabel *number_lab;
@property (weak, nonatomic) IBOutlet UILabel *type_lab;

@end

NS_ASSUME_NONNULL_END
