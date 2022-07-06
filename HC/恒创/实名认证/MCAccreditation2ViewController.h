//
//  MCAccreditation2ViewController.h
//  OEMSDK
//
//  Created by apple on 2020/10/30.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCAccreditation2ViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *top_image;
@property (weak, nonatomic) IBOutlet UIView *navigation_View;
@property (weak, nonatomic) IBOutlet UIButton *nav_back;
@property (weak, nonatomic) IBOutlet UILabel *nav_title;

@property (weak, nonatomic) IBOutlet UIImageView *sfz_image;
@property (weak, nonatomic) IBOutlet UIView *left_line_View;
@property (weak, nonatomic) IBOutlet UIImageView *rlsb_image;
@property (weak, nonatomic) IBOutlet UIView *right_line_View;
@property (weak, nonatomic) IBOutlet UIImageView *xyk_image;
@property (weak, nonatomic) IBOutlet UILabel *sfz_lab;
@property (weak, nonatomic) IBOutlet UILabel *rlsb_lab;
@property (weak, nonatomic) IBOutlet UILabel *txyk_lab;



@property (weak, nonatomic) IBOutlet UILabel *tishi_lab;

@property (weak, nonatomic) IBOutlet UIImageView * zhengImv;
@property (weak, nonatomic) IBOutlet UIImageView *fanImv;

@property (weak, nonatomic) IBOutlet UIView *nama_view;
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UIView *nama_line;

@property (weak, nonatomic) IBOutlet UIView *id_view;
@property (weak, nonatomic) IBOutlet UILabel *id_lab;
@property (weak, nonatomic) IBOutlet UITextField *idTf;
@property (weak, nonatomic) IBOutlet UIView *id_line;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
- (IBAction)finishAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
