//
//  MyTableViewCell.m
//  4.22-校园淘金-求购界面
//
//  Created by scjy on 15/4/23.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "GouMyTableViewCell.h"
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width


@implementation GouMyTableViewCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        
        self.headImg=[[UIImageView alloc]init];
        self.headImg.frame=CGRectMake(20, 5, 80, 80);
        self.headImg.layer.cornerRadius=80/2;
        [self.headImg.layer setMasksToBounds:YES];
        [self addSubview:self.headImg];
     
        self.nickName=[[UILabel alloc]init];
        self.nickName.frame=CGRectMake(20,  CGRectGetMaxY(self.headImg.frame)+5, 80, 20);
        self.nickName.font=[UIFont systemFontOfSize:13];
        self.nickName.textAlignment=1;
        [self addSubview:self.nickName];

        
        self.nameLable=[[UILabel alloc]init];
        self.nameLable.frame=CGRectMake(CGRectGetMaxX(self.headImg.frame)+50,  5, 70, 20);
        self.nameLable.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.nameLable];
        
       
        self.content=[[UILabel alloc]init];
        self.content.frame=CGRectMake(CGRectGetMaxX(self.headImg.frame)+50, CGRectGetMaxY(self.nameLable.frame)+5, 180, 45);
        self.content.font=[UIFont systemFontOfSize:12];
        self.content.numberOfLines=0;
        [self addSubview:self.content];
        

        self.priceLable=[[UILabel alloc]init];
        self.priceLable.frame=CGRectMake(ScreenWidth-50, CGRectGetMaxY(self.headImg.frame)+5, 40, 20);
        self.priceLable.font=[UIFont systemFontOfSize:16];
        self.priceLable.textColor=[UIColor redColor];
        [self addSubview:self.priceLable];

       
        self.campusName=[[UILabel alloc]init];
         self.campusName.frame=CGRectMake(CGRectGetMaxX(self.headImg.frame)+50, CGRectGetMaxY(self.headImg.frame)+5, 50, 20);
        self.campusName.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.campusName];
        
        self.contact=[[UIButton alloc]init];
        self.contact.frame=CGRectMake(10, CGRectGetMaxY(self.campusName.frame)+10, (ScreenWidth-20-1)/2, 30);
        self.contact.backgroundColor=[UIColor lightGrayColor];
        [self.contact setTitle:@"联系方式" forState:UIControlStateNormal];
        [self.contact setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       
        self.contact.titleLabel.font=[UIFont systemFontOfSize:12];
        self.contact.titleLabel.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.contact];
        
        self.leaveMessage=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.contact.frame)+1,CGRectGetMaxY(self.campusName.frame)+10,(ScreenWidth-20-1)/2,30)];
        self.leaveMessage.backgroundColor=[UIColor lightGrayColor];
        
        [self.leaveMessage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.leaveMessage.titleLabel.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.leaveMessage];
        
//        self.publishDate=[[UILabel alloc]init];
//        self.publishDate.font=[UIFont systemFontOfSize:20];
//        self.publishDate.textColor=[UIColor grayColor];
//        [self.contentView addSubview:self.publishDate];
    }
    return self;
}



@end
