//
//  HCBetweenStraightCell.h
//  HC
//
//  Created by tuibao on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCBetweenStraightCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *bg_view;

@property (weak, nonatomic) IBOutlet UIImageView *touxiang_image;

@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UILabel *id_lab;

@property (weak, nonatomic) IBOutlet UILabel *dengji_lab;

@property (weak, nonatomic) IBOutlet UIButton *phone_btn;
@property (weak, nonatomic) IBOutlet UILabel *time_lab;
@property (weak, nonatomic) IBOutlet UIView *content_view;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;

@end

NS_ASSUME_NONNULL_END
