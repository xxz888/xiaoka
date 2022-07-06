//
//  HCEarningsCell.h
//  HC
//
//  Created by tuibao on 2021/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCEarningsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *left_title_lab;
@property (weak, nonatomic) IBOutlet UILabel *left_number_lab;

@property (weak, nonatomic) IBOutlet UILabel *right_title_lab;
@property (weak, nonatomic) IBOutlet UILabel *right_number_lab;

@end

NS_ASSUME_NONNULL_END
