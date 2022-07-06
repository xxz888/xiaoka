//
//  HCWithdrawalSuccessView.h
//  HC
//
//  Created by tuibao on 2021/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCWithdrawalSuccessView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bg_image;
@property (weak, nonatomic) IBOutlet UILabel *top_lab;

@property (weak, nonatomic) IBOutlet UIImageView *content_image;

@property (weak, nonatomic) IBOutlet UIView *conent_view;

@property (weak, nonatomic) IBOutlet UILabel *title_lab;

@property (weak, nonatomic) IBOutlet UIButton *btn;


@end

NS_ASSUME_NONNULL_END
