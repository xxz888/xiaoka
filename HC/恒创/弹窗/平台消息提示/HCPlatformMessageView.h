//
//  HCPlatformMessageView.h
//  HC
//
//  Created by tuibao on 2022/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCPlatformMessageView : UIView

@property (weak, nonatomic) IBOutlet UIButton *clean_btn;
@property (weak, nonatomic) IBOutlet UILabel *title_lab;

@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UIImageView *bg_image;

@property (weak, nonatomic) IBOutlet UIView *conent_view;
@property (weak, nonatomic) IBOutlet UILabel *msgtitle_lab;

@property (weak, nonatomic) IBOutlet UILabel *msg_lab;


@end

NS_ASSUME_NONNULL_END
