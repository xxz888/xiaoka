//
//  SearchTipsTableViewCell.m
//  XQDQ
//
//  Created by lh on 2021/9/16.
//

#import "SearchTipsTableViewCell.h"
@interface SearchTipsTableViewCell ()

///搜索提示数据源
@property (nonatomic , strong) NSMutableArray *searchTipsArr;

@end

@implementation SearchTipsTableViewCell

- (void)layoutSubviews{
    [super layoutSubviews];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.searchTipsArr = [NSMutableArray array];
        
    }
    return self;
}

-(void)setDataArr:(NSMutableArray *)Arr{
    self.searchTipsArr = Arr;
    [self createUI];
}

- (void)createUI{

    CGFloat tagBtnX = 12;
    CGFloat tagBtnY = 16;
    for (int i= 0; i<self.searchTipsArr.count; i++) {
        
        CGSize tagTextSize = [self.searchTipsArr[i] sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(DEVICE_WIDTH-32-32, 30)];
        
        if (tagBtnX+tagTextSize.width+30 > DEVICE_WIDTH-32) {
            tagBtnX = 12;
            tagBtnY += 26+16;
        }
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.tag = 100+i;
        tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+30, 26);
        [tagBtn setTitle:self.searchTipsArr[i] forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tagBtn.backgroundColor = [UIColor colorWithHexString:@"#FDD8A9"];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        tagBtn.layer.cornerRadius = 13;
        tagBtn.layer.masksToBounds = YES;
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:tagBtn];
        
        tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
        
        if (i == self.searchTipsArr.count-1) {
            UIView *line = [UIView new];
            line.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
            [self.contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(8);
                make.width.offset(DEVICE_WIDTH);
                make.left.offset(0);
                make.top.equalTo(tagBtn.mas_bottom).offset(20);
                make.bottom.offset(0);
            }];
        }
    }
}
#pragma 返回搜索的名称
- (void)tagBtnClick:(UIButton *)btn{
    self.block(btn.titleLabel.text);
}



@end
