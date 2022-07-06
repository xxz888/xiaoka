//
//  HCMaterialController.h
//  HC
//
//  Created by tuibao on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCMaterialController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *navigation_View;
@property (weak, nonatomic) IBOutlet UIButton *nav_back;

@property (weak, nonatomic) IBOutlet UIImageView *bg_image;
@property (weak, nonatomic) IBOutlet UIView *bottom_view;
@property (weak, nonatomic) IBOutlet UIView *bottom_left_view;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_left_icon;
@property (weak, nonatomic) IBOutlet UILabel *bottom_left_lab;

@property (weak, nonatomic) IBOutlet UILabel *bottom_center_lab;
@property (weak, nonatomic) IBOutlet UILabel *bottom_right_lab;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_right_image;



@end

NS_ASSUME_NONNULL_END
