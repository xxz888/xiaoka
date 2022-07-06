//
//  HCSwipeFenRunCell.h
//  HC
//
//  Created by tuibao on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCSwipeFenRunCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time_lab;
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UILabel *dengji_lab;
@property (weak, nonatomic) IBOutlet UILabel *huankuan_lab;
@property (weak, nonatomic) IBOutlet UILabel *fenrun_lab;


@property (weak, nonatomic) IBOutlet UIView *line;

@end

NS_ASSUME_NONNULL_END
