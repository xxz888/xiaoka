//
//  NSArray+Category.h
//  XQDQ
//
//  Created by lh on 2021/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Category)

/**
打乱数组顺序
 */
+ (NSMutableArray*)getRandomArrFrome:(NSArray*)arr;

@end

NS_ASSUME_NONNULL_END
