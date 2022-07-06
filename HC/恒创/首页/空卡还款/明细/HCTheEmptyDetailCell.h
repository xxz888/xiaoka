//
//  HCTheEmptyDetailCell.h
//  HC
//
//  Created by tuibao on 2022/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCTheEmptyDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@end

NS_ASSUME_NONNULL_END
