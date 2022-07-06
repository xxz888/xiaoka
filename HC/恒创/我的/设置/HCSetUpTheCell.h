//
//  HCSetUpTheCell.h
//  HC
//
//  Created by tuibao on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCSetUpTheCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UILabel *content_lab;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIImageView *right_image;

@end

NS_ASSUME_NONNULL_END
