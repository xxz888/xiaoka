//
//  HCHelpHKTableViewCell.h
//  HC
//
//  Created by tuibao on 2021/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCHelpHKTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UIImageView *touxiang_image;
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UILabel *phone_lab;
@property (weak, nonatomic) IBOutlet UILabel *Customer_lab;
@property (weak, nonatomic) IBOutlet UILabel *zxjihua_lab;
@property (weak, nonatomic) IBOutlet UILabel *yichangjihua_lab;
@property (weak, nonatomic) IBOutlet UIButton *clean_btn;

@end

NS_ASSUME_NONNULL_END
