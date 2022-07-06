//
//  HCInviteFriendsController.h
//  HC
//
//  Created by tuibao on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCInviteFriendsController : BaseViewController


@property (weak, nonatomic) IBOutlet UIImageView *bg_image;
@property (weak, nonatomic) IBOutlet UIImageView *QrCode_img;

@property (weak, nonatomic) IBOutlet UIView *content_view;

@property (weak, nonatomic) IBOutlet UIView *navigation_View;
@property (weak, nonatomic) IBOutlet UIButton *nav_back;

@property (weak, nonatomic) IBOutlet UIImageView *content_image;

@property (weak, nonatomic) IBOutlet UIButton *baocun_btn;

@end

NS_ASSUME_NONNULL_END
