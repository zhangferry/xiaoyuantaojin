//
//  MyTableViewCell.h
//  4.22-校园淘金-求购界面
//
//  Created by scjy on 15/4/23.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GouMyTableViewCell : UITableViewCell

@property(nonatomic,retain)UIImageView *headImg;

@property(nonatomic,retain)UILabel *nameLable;
@property(nonatomic,retain)UILabel *content;
@property(nonatomic,retain)UILabel *priceLable;
@property(nonatomic,retain)UILabel *campusName;
@property(nonatomic,retain)UIButton *contact;
@property(nonatomic,retain)UIButton *leaveMessage;
@property(nonatomic,retain)UILabel *publishDate;


@end
