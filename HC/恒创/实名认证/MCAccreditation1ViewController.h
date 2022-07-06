//
//  MCAccreditation1ViewController.h
//  AFNetworking
//
//  Created by apple on 2020/10/30.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCAccreditation1ViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *userXieYiLbl;
- (IBAction)agreeAction:(id)sender;
- (IBAction)selectAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *center_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_view_hight;

@end

NS_ASSUME_NONNULL_END
