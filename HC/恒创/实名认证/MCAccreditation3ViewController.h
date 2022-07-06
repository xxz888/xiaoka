//
//  MCAccreditation3ViewController.h
//  OEMSDK
//
//  Created by tuibao on 2021/11/4.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCAccreditation3ViewController : BaseViewController

@property (strong, nonatomic)  UIImageView *top_image;
@property (strong, nonatomic)  UIView *navigation_View;
@property (strong, nonatomic)  UIButton *nav_back;
@property (strong, nonatomic)  UILabel *nav_title;

@property (strong, nonatomic)  UIImageView *sfz_image;
@property (strong, nonatomic)  UIView *left_line_View;
@property (strong, nonatomic)  UIImageView *rlsb_image;
@property (strong, nonatomic)  UIView *right_line_View;
@property (strong, nonatomic)  UIImageView *xyk_image;
@property (strong, nonatomic)  UILabel *sfz_lab;
@property (strong, nonatomic)  UILabel *rlsb_lab;
@property (strong, nonatomic)  UILabel *txyk_lab;

@property (strong, nonatomic)  UILabel *tishi_lab;
@property (strong, nonatomic)  UIImageView *rlsb_center_imageView;

@property (strong, nonatomic)  UILabel *jingshi1_lab;
@property (strong, nonatomic)  UILabel *jingshi2_lab;

@property (strong, nonatomic)  UIView *shouji_left_view;
@property (strong, nonatomic)  UIImageView *shouji_left_imageView;
@property (strong, nonatomic)  UILabel *shouji_left_lab;

@property (strong, nonatomic)  UIView *shouji_center_view;
@property (strong, nonatomic)  UIImageView *shouji_center_imageView;
@property (strong, nonatomic)  UILabel *shouji_center_lab;

@property (strong, nonatomic)  UIView *shouji_right_view;
@property (strong, nonatomic)  UIImageView *shouji_right_imageView;
@property (strong, nonatomic)  UILabel *shouji_right_lab;


@property (strong, nonatomic)  UIButton *finishBtn;

//身份证识别的名称
@property (strong, nonatomic)  NSString *user_name;


@end

NS_ASSUME_NONNULL_END
