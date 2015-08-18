//
//  purchaseModel.h
//  校园淘金
//
//  Created by zhangfei on 15/5/11.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface purchaseModel : NSObject

@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,retain)UIImage *loadImage;
@property(nonatomic,copy)NSString *goodTitle;
@property(nonatomic,copy)NSString *goodDesc;
@property(nonatomic,copy)NSString *goodPrice;
@property(nonatomic,copy)NSString *goodType;
@property(nonatomic,copy)NSString *sendAddress;
@property(nonatomic,copy)NSString *userPhone;
@property(nonatomic,copy)NSString *userQQ;
@property(nonatomic,copy)NSDate *publishDate;
@property(nonatomic,copy)NSString *goodID;
@property(nonatomic,copy)NSString *userID;

@end
