//
//  HCTheQueryMaterrialCell.h
//  HC
//
//  Created by tuibao on 2022/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCTheQueryMaterrialCell : UITableViewCell


@property (nonatomic , strong) NSDictionary *data;


@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UIViewController *viewController_cell;

@end

NS_ASSUME_NONNULL_END
