//
//  HCTradingTypeView.m
//  HC
//
//  Created by tuibao on 2021/11/8.
//

#import "HCTradingTypeView.h"

@implementation HCTradingTypeView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    
    self.determine_btn.layer.cornerRadius = 5;
    [self.determine_btn setEnlargeEdgeWithTop:10 right:10 bottom:15 left:15];
}

@end
