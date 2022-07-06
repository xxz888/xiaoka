//
//  HCVersionUpdateView.h
//  HC
//
//  Created by tuibao on 2021/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCVersionUpdateView : UIView

@property (weak, nonatomic) IBOutlet UIButton *clean_btn;
@property (weak, nonatomic) IBOutlet UILabel *title_lab;

@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UIImageView *bg_image;

@property (weak, nonatomic) IBOutlet UIImageView *version_image;

@property (weak, nonatomic) IBOutlet UILabel *content_lab;

@property (weak, nonatomic) IBOutlet UIButton *upgrade_btn;

@property (weak, nonatomic) IBOutlet UILabel *tishi_lab;

@end

NS_ASSUME_NONNULL_END
