//
//  HCModifyTheInformationCell.h
//  HC
//
//  Created by tuibao on 2021/11/10.
//

#import <UIKit/UIKit.h>
#import "HCConfirmPayModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HCModifyTheInformationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title_lab;
@property (weak, nonatomic) IBOutlet UITextField *content_textfield;
@property (weak, nonatomic) IBOutlet UIView *line_view;

@property (nonatomic , strong) NSIndexPath *index;
@property (nonatomic , strong) HCConfirmPayModel *model;

@end

NS_ASSUME_NONNULL_END
