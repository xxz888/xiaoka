//
//  HCInvestmentDetailCell.h
//  HC
//
//  Created by tuibao on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCInvestmentDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bg_view;

@property (weak, nonatomic) IBOutlet UILabel *title_lab;

@property (weak, nonatomic) IBOutlet UILabel *number_lab1;
@property (weak, nonatomic) IBOutlet UILabel *number_lab2;
@property (weak, nonatomic) IBOutlet UILabel *number_lab3;
@property (weak, nonatomic) IBOutlet UILabel *number_lab4;

@property (weak, nonatomic) IBOutlet UIButton *right_btn;

@end

NS_ASSUME_NONNULL_END
