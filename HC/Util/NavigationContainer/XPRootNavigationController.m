//
//  XPRootNavigationController.m
//  https://github.com/xiaopin/NavigationContainer.git
//
//  Created by xiaopin on 2018/8/1.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "XPRootNavigationController.h"
#import <objc/runtime.h>


#pragma mark - 容器控制器
@interface XPContainerViewController : UIViewController

@property (nonatomic, weak) UIViewController *contentViewController;
+ (instancetype)containerViewControllerWithViewController:(UIViewController *)viewController;

@end

@implementation XPContainerViewController

+ (instancetype)containerViewControllerWithViewController:(UIViewController *)viewController {
    if (viewController.parentViewController) {
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
    }
    
    Class cls = [viewController xp_navigationControllerClass];
    NSAssert(![cls isKindOfClass:UINavigationController.class], @"`-xp_navigationControllerClass` must return UINavigationController or its subclasses.");
    //设置默认导航栏样式  如果某个界面需要特定样式，请到具体界面修改
    UINavigationController *nav = [[cls alloc] initWithRootViewController:viewController];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barApp = [[UINavigationBarAppearance alloc] init];
        barApp.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        [barApp configureWithOpaqueBackground];
        barApp.backgroundColor = [UIColor whiteColor];//设置导航栏背景颜色
        barApp.backgroundImage = [UIImage imageNamed:@"HC_TOP_bg"];//设置导航栏背景图片
        barApp.shadowImage = nil;//去掉导航栏底部线条
        barApp.titleTextAttributes = @{NSFontAttributeName:[UIFont getUIFontSize:18 IsBold:YES], NSForegroundColorAttributeName:FontThemeColor};//导航栏标题样式
        [nav.navigationBar setTranslucent:false];
        nav.navigationBar.scrollEdgeAppearance = barApp;//带scroll滑动的页面导航栏样式
        nav.navigationBar.standardAppearance = barApp;//常规页面导航栏样式
    }else{
        //去掉导航栏底部线条
        nav.navigationBar.shadowImage = [UIImage new];
        //设置导航栏背景颜色
        UIImage *navImg =[UIImage imageWithColor:[UIColor whiteColor]];
        navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        [nav.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
        //设置导航栏标题字体颜色
        [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19], NSForegroundColorAttributeName:FontThemeColor}];
        //设置导航栏背景图片
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"HC_TOP_bg"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    //设置返回按钮颜色
    nav.navigationBar.tintColor = FontThemeColor;
    nav.interactivePopGestureRecognizer.enabled = NO;
    
    
    
    XPContainerViewController *containerViewController = [[XPContainerViewController alloc] init];
    containerViewController.contentViewController = viewController;
    containerViewController.hidesBottomBarWhenPushed = viewController.hidesBottomBarWhenPushed;
    [containerViewController addChildViewController:nav];
    [containerViewController.view addSubview:nav.view];
    [nav didMoveToParentViewController:containerViewController];
    
    
    
    return containerViewController;
}

@end


#pragma mark - 全局函数

/// 装包
UIKIT_STATIC_INLINE UIViewController* XPWrapViewController(UIViewController *vc)
{
    if ([vc isKindOfClass:XPContainerViewController.class]) {
        return vc;
    }
    return [XPContainerViewController containerViewControllerWithViewController:vc];
}

/// 解包
UIKIT_STATIC_INLINE UIViewController* XPUnwrapViewController(UIViewController *vc)
{
    if ([vc isKindOfClass:XPContainerViewController.class]) {
        return ((XPContainerViewController*)vc).contentViewController;
    }
    return vc;
}


#pragma mark - 导航栏控制器

@interface XPRootNavigationController ()<UIGestureRecognizerDelegate>
@end

@implementation XPRootNavigationController

#pragma mark Lifecycle

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;

    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];

    // 设置手势代理，拦截手势触发
    pan.delegate = self;

    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];

    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        // 返回按钮目前仅支持图片
        UIImage *backImage = self.backIconImage ?: [self navigationBarBackIconImage];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:viewController action:@selector(xp_popViewController)];
#pragma clang diagnostic pop
        viewController.navigationItem.leftBarButtonItem = backItem;
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:XPWrapViewController(viewController) animated:animated];

}
- (void)handleNavigationTransition:(UIPanGestureRecognizer *)sender{
    
}
#pragma mark <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.childViewControllers.count == 1) {
        return NO;
    }
    
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint offSet   = [gestureRecognizer locationInView:gestureRecognizer.view];
    
    BOOL    result   = (0 < offSet.x && location.x <= (DEVICE_WIDTH/4.0));
    return result;
}

/// 在pop手势生效后能够确保滚动视图静止
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    
    
    
    
    return (gestureRecognizer == self.interactivePopGestureRecognizer);
}

#pragma mark Private

- (void)commonInit {
    UIViewController *topViewController = self.topViewController;

    if (topViewController) {
        UIViewController *wrapViewController = XPWrapViewController(topViewController);
        [super setViewControllers:@[wrapViewController] animated:NO];
    }
    [self setNavigationBarHidden:YES animated:NO];
}

- (UIImage *)navigationBarBackIconImage {
    CGSize const size = CGSizeMake(15.0, 21.0);
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    
    UIColor *color = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0];
    [color setFill];
    [color setStroke];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(10.9, 0)];
    [bezierPath addLineToPoint: CGPointMake(12, 1.1)];
    [bezierPath addLineToPoint: CGPointMake(1.1, 11.75)];
    [bezierPath addLineToPoint: CGPointMake(0, 10.7)];
    [bezierPath addLineToPoint: CGPointMake(10.9, 0)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(11.98, 19.9)];
    [bezierPath addLineToPoint: CGPointMake(10.88, 21)];
    [bezierPath addLineToPoint: CGPointMake(0.54, 11.21)];
    [bezierPath addLineToPoint: CGPointMake(1.64, 10.11)];
    [bezierPath addLineToPoint: CGPointMake(11.98, 19.9)];
    [bezierPath closePath];
    [bezierPath setLineWidth:1.0];
    [bezierPath fill];
    [bezierPath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark setter & getter

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [super setNavigationBarHidden:YES];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [super setNavigationBarHidden:YES animated:NO];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    NSMutableArray<UIViewController *> *aViewControllers = [NSMutableArray array];
    for (UIViewController *vc in viewControllers) {
        [aViewControllers addObject:XPWrapViewController(vc)];
    }
    [super setViewControllers:aViewControllers animated:animated];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    NSMutableArray<UIViewController *> *aViewControllers = [NSMutableArray array];
    for (UIViewController *vc in viewControllers) {
        [aViewControllers addObject:XPWrapViewController(vc)];
    }
    [super setViewControllers:[NSArray arrayWithArray:aViewControllers]];
}

- (NSArray<UIViewController *> *)viewControllers {
    // 返回真正的控制器给外界
    NSMutableArray<UIViewController *> *vcs = [NSMutableArray array];
    NSArray<UIViewController *> *viewControllers = [super viewControllers];
    for (UIViewController *vc in viewControllers) {
        [vcs addObject:XPUnwrapViewController(vc)];
    }
    return [NSArray arrayWithArray:vcs];
}

@end


#pragma mark -

@implementation UIViewController (XPNavigationContainer)

/// 通过返回不同的导航栏控制器可以给每个控制器定制不同的导航栏样式
- (Class)xp_navigationControllerClass {
#ifdef kXPNavigationControllerClassName
    return NSClassFromString(kXPNavigationControllerClassName);
#else
    return [XPContainerNavigationController class];
#endif
}

- (XPRootNavigationController *)xp_rootNavigationController {
    UIViewController *parentViewController = self.navigationController.parentViewController;
    
    if (parentViewController && [parentViewController isKindOfClass:XPContainerViewController.class]) {
        XPContainerViewController *container = (XPContainerViewController*)parentViewController;
        return (XPRootNavigationController*)container.navigationController;
    }
    return nil;
}

- (void)xp_popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma 返回指定界面
- (void)backToAppointedController:(UIViewController *)VC{
//  此法只需要知道你需要返回的控制器的类名称即可
    UINavigationController *navC = self.xp_rootNavigationController;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (UIViewController *vc in navC.viewControllers) {
        [viewControllers addObject:vc];
        if ([vc isKindOfClass:[VC class]]) {
            break;
        }
    }
    if (viewControllers.count == navC.viewControllers.count) {
        [self.xp_rootNavigationController popViewControllerAnimated:YES];
    }
    else {
        [navC setViewControllers:viewControllers animated:YES];
    }
}
- (void)changeTheNavigationBarStyle:(UIColor *)returnColor navTitle:(UIColor *)titleColor navBackgroundColor:(UIColor *)backgroundColor{
    //设置返回按钮颜色
    self.navigationController.navigationBar.tintColor = returnColor;
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barApp = [[UINavigationBarAppearance alloc] init];
        barApp.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        [barApp configureWithOpaqueBackground];
        barApp.backgroundColor = backgroundColor;//设置导航栏背景颜色
        barApp.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];//去掉导航栏底部线条
        barApp.titleTextAttributes = @{NSFontAttributeName:[UIFont getUIFontSize:18 IsBold:YES], NSForegroundColorAttributeName:titleColor};//导航栏标题样式
        
        self.navigationController.navigationBar.scrollEdgeAppearance = barApp;//带scroll滑动的页面导航栏样式
        self.navigationController.navigationBar.standardAppearance = barApp;//常规页面导航栏样式
    }else{
        //去掉导航栏底部线条
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        //设置导航栏背景颜色
        UIImage *navImg =[UIImage imageWithColor:backgroundColor];
        navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        [self.navigationController.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
        //设置导航栏标题字体颜色
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont getUIFontSize:18 IsBold:YES], NSForegroundColorAttributeName:titleColor}];
    }
}
//获取手机当前显示的ViewController
+ (UIViewController*)currentViewController{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[XPRootNavigationController class]]) {
            vc = ((XPRootNavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
//    
//    XPRootNavigationController *rootNavigationController = (XPRootNavigationController *)vc.navigationController;
//
//    NSLog(@"%@",rootNavigationController.viewControllers);
//
//    NSLog(@"%@",XPUnwrapViewController(vc));
//
    return vc;
}

@end


#pragma mark -

@interface UINavigationController (XPNavigationContainer)
@end

@implementation UINavigationController (XPNavigationContainer)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *actions = @[
                             NSStringFromSelector(@selector(pushViewController:animated:)),
                             NSStringFromSelector(@selector(popViewControllerAnimated:)),
                             NSStringFromSelector(@selector(popToViewController:animated:)),
                             NSStringFromSelector(@selector(popToRootViewControllerAnimated:)),
                             NSStringFromSelector(@selector(viewControllers))
                             ];
        
        for (NSString *str in actions) {
            Method original = class_getInstanceMethod(self, NSSelectorFromString(str));
            Method swizzled = class_getInstanceMethod(self, NSSelectorFromString([@"xp_" stringByAppendingString:str]));
            method_exchangeImplementations(original, swizzled);
        }
    });
    
}

#pragma mark Private

- (XPRootNavigationController *)rootNavigationController {
    if (self.parentViewController && [self.parentViewController isKindOfClass:XPContainerViewController.class]) {
        XPContainerViewController *containerViewController = (XPContainerViewController *)self.parentViewController;
        XPRootNavigationController *rootNavigationController = (XPRootNavigationController *)containerViewController.navigationController;
        return rootNavigationController;
    }
    return nil;
}

#pragma mark Override

- (void)xp_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    XPRootNavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        return [rootNavigationController pushViewController:viewController animated:animated];
    }
    [self xp_pushViewController:viewController animated:animated];
}

- (UIViewController *)xp_popViewControllerAnimated:(BOOL)animated {
    XPRootNavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        XPContainerViewController *containerViewController = (XPContainerViewController*)[rootNavigationController popViewControllerAnimated:animated];
        return containerViewController.contentViewController;
    }
    return [self xp_popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)xp_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    XPRootNavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        NSArray<UIViewController*> *array = [rootNavigationController popToViewController:viewController animated:animated];
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (UIViewController *vc in array) {
            [viewControllers addObject:XPUnwrapViewController(vc)];
        }
        return viewControllers;
    }
    return [self xp_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)xp_popToRootViewControllerAnimated:(BOOL)animated {
    XPRootNavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        NSArray<UIViewController*> *array = [rootNavigationController popToRootViewControllerAnimated:animated];
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (UIViewController *vc in array) {
            [viewControllers addObject:XPUnwrapViewController(vc)];
        }
        return viewControllers;
    }
    return [self xp_popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)xp_viewControllers {
    XPRootNavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        return [rootNavigationController viewControllers];
    }
    return [self xp_viewControllers];
}

@end


#pragma mark - 状态栏样式 & 屏幕旋转

@implementation XPContainerNavigationController



- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.topViewController) {
        return XPUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForStatusBarStyle];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    if (self.topViewController) {
        return XPUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.topViewController) {
        return [XPUnwrapViewController(self.topViewController) preferredStatusBarStyle];
    }
    return [super preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if (self.topViewController) {
        return [XPUnwrapViewController(self.topViewController) preferredStatusBarUpdateAnimation];
    }
    return [super preferredStatusBarUpdateAnimation];
}

- (BOOL)prefersStatusBarHidden {
    if (self.topViewController) {
        return [XPUnwrapViewController(self.topViewController) prefersStatusBarHidden];
    }
    return [super prefersStatusBarHidden];
}

- (BOOL)shouldAutorotate {
    if (self.topViewController) {
        return [XPUnwrapViewController(self.topViewController) shouldAutorotate];
    }
    return [super shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self.topViewController) {
        return [XPUnwrapViewController(self.topViewController) preferredInterfaceOrientationForPresentation];
    }
    return [super preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.topViewController) {
        return [XPUnwrapViewController(self.topViewController) supportedInterfaceOrientations];
    }
    return [super supportedInterfaceOrientations];
}

#if __IPHONE_11_0 && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
- (nullable UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures
{
    if (self.topViewController) {
        return XPUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForScreenEdgesDeferringSystemGestures];
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    if (self.topViewController) {
        return [XPUnwrapViewController(self.topViewController) preferredScreenEdgesDeferringSystemGestures];
    }
    return [super preferredScreenEdgesDeferringSystemGestures];
}

- (BOOL)prefersHomeIndicatorAutoHidden
{
    if (self.topViewController) {
        return [XPUnwrapViewController(self.topViewController) prefersHomeIndicatorAutoHidden];
    }
    return [super prefersHomeIndicatorAutoHidden];
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden
{
    if (self.topViewController) {
        return XPUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForHomeIndicatorAutoHidden];
}
#endif

@end
