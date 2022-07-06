//
//  HCMyTableViewCell.h
//  HC
//
//  Created by tuibao on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCMyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon_image;
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UIImageView *right_but;

@end

NS_ASSUME_NONNULL_END
