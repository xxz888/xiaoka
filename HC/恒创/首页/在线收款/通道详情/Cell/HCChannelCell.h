//
//  HCChannelCell.h
//  HC
//
//  Created by tuibao on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCChannelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bg_view;

@property (weak, nonatomic) IBOutlet UIImageView *icon_image;

@property (weak, nonatomic) IBOutlet UILabel *title_lab;

@property (weak, nonatomic) IBOutlet UILabel *chakan_lab;

@property (weak, nonatomic) IBOutlet UILabel *dbxe_lab;

@property (weak, nonatomic) IBOutlet UILabel *drxe_lab;

@property (weak, nonatomic) IBOutlet UILabel *jysj_lab;

@property (weak, nonatomic) IBOutlet UILabel *feilv_lab;

@end

NS_ASSUME_NONNULL_END
