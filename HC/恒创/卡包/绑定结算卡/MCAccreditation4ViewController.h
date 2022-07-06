//
//  MCAccreditation4ViewController.h
//  OEMSDK
//
//  Created by tuibao on 2021/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCAccreditation4ViewController : BaseViewController

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

@property (strong, nonatomic)  UIView *tishi_view;
@property (strong, nonatomic)  UILabel *tishi_lab1;
@property (strong, nonatomic)  UILabel *tishi_lab2;

@property (strong, nonatomic)  UIImageView *kapian_image;

@property (strong, nonatomic)  UIView *nama_view;
@property (strong, nonatomic)  UILabel *name_lab;
@property (strong, nonatomic)  UITextField *name_textField;
@property (strong, nonatomic)  UIView *nama_line;

@property (strong, nonatomic)  UIView *kahao_view;
@property (strong, nonatomic)  UILabel *kahao_lab;
@property (strong, nonatomic)  UITextField *kahao_textField;
@property (strong, nonatomic)  UILabel *kahao_tishi_lab;
@property (strong, nonatomic)  UIView *kahao_line;


@property (strong, nonatomic)  UIView *huhang_view;
@property (strong, nonatomic)  UILabel *huhang_lab;
@property (strong, nonatomic)  UITextField *huhang_textField;
@property (strong, nonatomic)  UIView *huhang_line;

@property (strong, nonatomic)  UIView *phone_view;
@property (strong, nonatomic)  UILabel *phone_lab;
@property (strong, nonatomic)  UITextField *phone_textField;

@property (strong, nonatomic)  UIButton *finishBtn;


@end

NS_ASSUME_NONNULL_END
