//
//  HCMessageCell.h
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bg_view;

@property (weak, nonatomic) IBOutlet UILabel *title_lab;


@property (weak, nonatomic) IBOutlet UILabel *content_lab;

@property (weak, nonatomic) IBOutlet UILabel *time_lab;


@end

NS_ASSUME_NONNULL_END
