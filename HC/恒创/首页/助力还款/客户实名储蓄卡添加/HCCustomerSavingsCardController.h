//
//  HCCustomerSavingsCardController.h
//  HC
//
//  Created by tuibao on 2021/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCCustomerSavingsCardController : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left_with;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right_with;

@property (nonatomic , strong) NSString *empowerToken;

@end

NS_ASSUME_NONNULL_END
