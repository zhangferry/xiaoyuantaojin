//
//  PersonMessagesTableViewCell.m
//  校园淘金
//
//  Created by zhangfei on 15/5/23.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "PersonMessagesTableViewCell.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width

@implementation PersonMessagesTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        
        self.myMessageView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-40, 50)];
        self.myMessageView.layer.cornerRadius=10;
        [self.myMessageView.layer setMasksToBounds:YES];
        [self.contentView addSubview:self.myMessageView];
        
        self.myImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        self.myImageView.layer.cornerRadius=40/2;
        [self.myImageView.layer setMasksToBounds:YES];
        [self.myMessageView addSubview:self.myImageView];
        
        self.myTitleLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.myImageView.frame)+10, 5, 40, 15)];
        self.myTitleLable.font=[UIFont systemFontOfSize:14];
        self.myTitleLable.textColor=[UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.5];
        [self.myMessageView addSubview:self.myTitleLable];
        
        self.myMessageLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.myImageView.frame)+10, CGRectGetMaxY(self.myTitleLable.frame)+10, ScreenWidth-80, 10)];
        self.myMessageLable.textColor=[UIColor blackColor];
        self.myMessageLable.font=[UIFont systemFontOfSize:10];
        [self.myMessageView addSubview:self.myMessageLable];
        
    }
    
    return self;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
