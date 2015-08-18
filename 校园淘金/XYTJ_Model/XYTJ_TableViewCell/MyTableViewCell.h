//
//  MyTableViewCell.h
//  校园淘金
//
//  Created by zhangfei on 15/4/22.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "purchaseModel.h"

@interface MyTableViewCell : UITableViewCell

@property(nonatomic,retain)UIImageView *image;
@property(nonatomic,retain)UILabel *title;
@property(nonatomic,retain)UILabel *desc;
@property(nonatomic,retain)UILabel *date;
@property(nonatomic,retain)UILabel *price;
@property(nonatomic,retain)UILabel *address;
@property(nonatomic,retain)UIImageView *dingwei;

-(void)setContentView:(purchaseModel *)purchModel;

@end
