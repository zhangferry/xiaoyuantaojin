//
//  XYTJ_PersonData_ViewController.h
//  校园淘金--登陆
//
//  Created by scjy on 15/5/15.
//  Copyright (c) 2015年 刘孝勇. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XYTJ_PersonData_ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy) NSMutableDictionary *UserDictionary;

@end
