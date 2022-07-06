//
//  TableViewCell.h
//  HC
//
//  Created by tuibao on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCGroundPointsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *left_lab;
@property (weak, nonatomic) IBOutlet UILabel *center_lab;
@property (weak, nonatomic) IBOutlet UILabel *right_lab;

@end

NS_ASSUME_NONNULL_END
