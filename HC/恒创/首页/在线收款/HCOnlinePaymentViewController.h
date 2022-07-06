//
//  HCOnlinePaymentViewController.h
//  HC
//
//  Created by tuibao on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCOnlinePaymentViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *top_image;
@property (weak, nonatomic) IBOutlet UIView *navigation_View;
@property (weak, nonatomic) IBOutlet UIButton *nav_back;
@property (weak, nonatomic) IBOutlet UILabel *nav_title;
@property (weak, nonatomic) IBOutlet UIButton *history;


@property (weak, nonatomic) IBOutlet UIView *content_view;
@property (weak, nonatomic) IBOutlet UIImageView *login_image;
@property (weak, nonatomic) IBOutlet UILabel *login_title;

@property (weak, nonatomic) IBOutlet UIView *amount_view;
@property (weak, nonatomic) IBOutlet UILabel *amount_lab;
@property (weak, nonatomic) IBOutlet UITextField *amount_textfield;
@property (weak, nonatomic) IBOutlet UIView *amount_line;

@property (weak, nonatomic) IBOutlet UILabel *amount_center_title;
@property (weak, nonatomic) IBOutlet UILabel *amount_center_number;
@property (weak, nonatomic) IBOutlet UIView *amount_left_line;
@property (weak, nonatomic) IBOutlet UILabel *amount_left_title;
@property (weak, nonatomic) IBOutlet UILabel *amount_left_number;
@property (weak, nonatomic) IBOutlet UIView *amount_right_line;
@property (weak, nonatomic) IBOutlet UILabel *amount_right_title;
@property (weak, nonatomic) IBOutlet UILabel *amount_right_number;

@property (weak, nonatomic) IBOutlet UILabel *pay_title;
@property (weak, nonatomic) IBOutlet UIImageView *pay_image;
@property (weak, nonatomic) IBOutlet UILabel *pay_content;
@property (weak, nonatomic) IBOutlet UILabel *pay_more;

@property (weak, nonatomic) IBOutlet UILabel *account_title;
@property (weak, nonatomic) IBOutlet UIImageView *account_image;
@property (weak, nonatomic) IBOutlet UILabel *account_content;
@property (weak, nonatomic) IBOutlet UILabel *account_more;




@end

NS_ASSUME_NONNULL_END
