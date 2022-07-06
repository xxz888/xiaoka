//
//  HCMallNineCell.h
//  HC
//
//  Created by tuibao on 2021/12/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCMallNineCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *top_image;
@property (weak, nonatomic) IBOutlet UILabel *title_lab;
@property (weak, nonatomic) IBOutlet UILabel *baoyou_lab;
@property (weak, nonatomic) IBOutlet UILabel *xiaoliang_lab;
@property (weak, nonatomic) IBOutlet UILabel *yuanjia_lab;
@property (weak, nonatomic) IBOutlet UILabel *vip_left_lab;
@property (weak, nonatomic) IBOutlet UIImageView *vip_view;
@property (weak, nonatomic) IBOutlet UILabel *vip_right_lab;

@end

NS_ASSUME_NONNULL_END
