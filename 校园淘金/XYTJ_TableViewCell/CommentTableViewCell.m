//
//  CommentTableViewCell.m
//  校园淘金
//
//  Created by zhangfei on 15/5/21.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "CommentTableViewCell.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width


@implementation CommentTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.headerImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.headerImage.layer.cornerRadius=40/2;
        [self.headerImage.layer setMasksToBounds:YES];
        [self.contentView addSubview:self.headerImage];
        
        self.userName=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImage.frame)+10, 10, 50, 20)];
        self.userName.textColor=[UIColor blueColor];
        [self.contentView addSubview:self.userName];
        
        self.message=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImage.frame)+10, CGRectGetMaxY(self.userName.frame)+15, ScreenWidth-20-20-40, 20)];
        self.message.textColor=[UIColor brownColor];
        [self.contentView addSubview:self.message];
        
        
        
    }
    return self;
    
}
- (void)awakeFromNib {
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
