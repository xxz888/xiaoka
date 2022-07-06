//
//  HCMallAddAdressController.h
//  HC
//
//  Created by tuibao on 2021/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCMallAddAdressController : BaseViewController


@property (weak, nonatomic) IBOutlet UITextField *name_textfield;

@property (weak, nonatomic) IBOutlet UITextField *phone_textfield;

@property (weak, nonatomic) IBOutlet UITextField *city_textfield;

@property (weak, nonatomic) IBOutlet UITextView *address_textfield;

@property (weak, nonatomic) IBOutlet UIButton *save_btn;


@end

NS_ASSUME_NONNULL_END
