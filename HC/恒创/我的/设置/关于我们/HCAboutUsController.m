//
//  HCAboutUsController.m
//  HC
//
//  Created by tuibao on 2021/11/26.
//

#import "HCAboutUsController.h"

@interface HCAboutUsController ()
@property (weak, nonatomic) IBOutlet UILabel *title_lab;

@end

@implementation HCAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //app版本
    NSString  *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.title_lab.text = [NSString stringWithFormat:@"%@",app_Version];
    
}



@end
