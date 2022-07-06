//
//  HCCustomerServiceCell.h
//  HC
//
//  Created by tuibao on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCCustomerServiceCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *bg_view;

@property (weak, nonatomic) IBOutlet UIImageView *top_image;

@property (weak, nonatomic) IBOutlet UILabel *name_lab;

@property (weak, nonatomic) IBOutlet UILabel *content_lab;


@end

NS_ASSUME_NONNULL_END
