//
//  HCInvestmentIncomeController.h
//  HC
//
//  Created by tuibao on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCInvestmentIncomeController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *top_image;
@property (weak, nonatomic) IBOutlet UIView *navigation_View;
@property (weak, nonatomic) IBOutlet UIButton *nav_back;
@property (weak, nonatomic) IBOutlet UILabel *nav_title;
//总收益
@property (weak, nonatomic) IBOutlet UILabel *TotalRevenue_title_lab;
@property (weak, nonatomic) IBOutlet UILabel *TotalRevenue_number_lab;
@property (weak, nonatomic) IBOutlet UILabel *DayRevenue_title_lab;
@property (weak, nonatomic) IBOutlet UILabel *DayRevenue_number_lab;
@property (weak, nonatomic) IBOutlet UILabel *MonthRevenue_title_lab;
@property (weak, nonatomic) IBOutlet UILabel *MonthRevenue_number_lab;

@property (weak, nonatomic) IBOutlet UIImageView *min_bg_image;
@property (weak, nonatomic) IBOutlet UILabel *min_bg_lab1;
@property (weak, nonatomic) IBOutlet UILabel *min_bg_lab2;
@property (weak, nonatomic) IBOutlet UILabel *min_bg_lab3;
@property (weak, nonatomic) IBOutlet UILabel *min_bg_lab4;
@property (weak, nonatomic) IBOutlet UIButton *min_bg_btn;

@property (weak, nonatomic) IBOutlet UIView *center_view;
@property (weak, nonatomic) IBOutlet UILabel *center_view_lab1;
@property (weak, nonatomic) IBOutlet UILabel *center_view_lab2;
@property (weak, nonatomic) IBOutlet UILabel *center_view_lab3;
@property (weak, nonatomic) IBOutlet UILabel *center_view_lab4;
@property (weak, nonatomic) IBOutlet UILabel *center_view_lab5;
@property (weak, nonatomic) IBOutlet UILabel *center_view_lab6;


@property (weak, nonatomic) IBOutlet UIImageView *max_bg_image;
@property (weak, nonatomic) IBOutlet UILabel *max_bg_lab1;
@property (weak, nonatomic) IBOutlet UILabel *max_bg_lab2;
@property (weak, nonatomic) IBOutlet UILabel *max_bg_lab3;
@property (weak, nonatomic) IBOutlet UILabel *max_bg_lab4;
@property (weak, nonatomic) IBOutlet UILabel *max_bg_lab5;
@property (weak, nonatomic) IBOutlet UILabel *max_bg_lab6;
@property (weak, nonatomic) IBOutlet UILabel *max_bg_lab7;
@property (weak, nonatomic) IBOutlet UILabel *max_bg_lab8;


@end

NS_ASSUME_NONNULL_END
