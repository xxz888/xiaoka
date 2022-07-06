//
//  HCResetPasswordCell.h
//  HC
//
//  Created by tuibao on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCResetPasswordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name_lab;

@property (weak, nonatomic) IBOutlet UITextField *content_textfield;

@property (weak, nonatomic) IBOutlet UIButton *code_btn;


@property (weak, nonatomic) IBOutlet UIView *line;

@property (nonatomic , strong) HCConfirmPayModel *model;

@end

NS_ASSUME_NONNULL_END
