//
//  XYTJ_PersonalDataTableViewCell.m
//  校园淘金--登陆
//
//  Created by scjy on 15/5/16.
//  Copyright (c) 2015年 刘孝勇. All rights reserved.
//

#import "XYTJ_PersonalDataTableViewCell.h"

@implementation XYTJ_PersonalDataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView]; //初始化视图
    }
    return self;
}
#pragma mark--初始化视图
- (void)initView
{
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 55)];
    self.nameLabel.font=[UIFont systemFontOfSize:20];
    [self.contentView addSubview:self.nameLabel];
    self.detailTextField = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, self.bounds.size.width-90, 55)];
    self.detailTextField.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:self.detailTextField];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
