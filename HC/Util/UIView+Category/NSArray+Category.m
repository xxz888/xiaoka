//
//  NSArray+Category.m
//  XQDQ
//
//  Created by lh on 2021/9/27.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)

+ (NSMutableArray*)getRandomArrFrome:(NSArray*)arr{
    NSMutableArray *newArr = [NSMutableArray new];
    while (newArr.count != arr.count) {
        //生成随机数
        int x =arc4random() % arr.count;
        id obj = arr[x];
        if (![newArr containsObject:obj]) {
            [newArr addObject:obj];
        }
    }
    return newArr;
}

@end
