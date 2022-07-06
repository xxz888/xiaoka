//
//  HCCashCardCell.h
//  HC
//
//  Created by tuibao on 2021/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCCashCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bg_image;

@property (weak, nonatomic) IBOutlet UIImageView *icon_image;

@property (weak, nonatomic) IBOutlet UILabel *yinhang_lab;

@property (weak, nonatomic) IBOutlet UILabel *name_lab;

@property (weak, nonatomic) IBOutlet UILabel *weihao_lab;
@property (weak, nonatomic) IBOutlet UIImageView *yinlang_lab;
@property (weak, nonatomic) IBOutlet UIButton *xiugai_btn;
@property (weak, nonatomic) IBOutlet UIButton *delete_btn;
@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UILabel *left_lab;


@property (weak, nonatomic) IBOutlet UILabel *right_lab;

@end

NS_ASSUME_NONNULL_END
