//
//  PurchaseViewController.h
//  校园淘金
//
//  Created by zhangfei on 15/4/22.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *goodID;
@property(nonatomic,copy)NSString *userID;
@property(nonatomic,copy)NSString *userPhone;
@property(nonatomic,copy)NSString *userQQ;

@end
