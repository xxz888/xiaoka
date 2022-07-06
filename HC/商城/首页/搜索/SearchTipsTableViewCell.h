//
//  SearchTipsTableViewCell.h
//  XQDQ
//
//  Created by lh on 2021/9/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SearchTipsBlock)(NSString *strName);

@interface SearchTipsTableViewCell : UITableViewCell

-(void)setDataArr:(NSMutableArray *)Arr;

@property (nonatomic , copy) SearchTipsBlock block;

@end

NS_ASSUME_NONNULL_END
