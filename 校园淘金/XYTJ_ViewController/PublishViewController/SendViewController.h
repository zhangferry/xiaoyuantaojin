//
//  SendViewController.h
//  校园淘金
//
//  Created by scjy on 15/4/21.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXPullDownMenu.h"
@interface SendViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,MXPullDownMenuDelegate>

@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *goodTitle;
@property(nonatomic,copy)NSString *goodDesc;
@property(nonatomic,copy)NSString *goodPrice;



@end
