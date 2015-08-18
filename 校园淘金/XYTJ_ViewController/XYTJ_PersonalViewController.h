//
//  XYTJ_PersonalViewController.h
//  校园淘金--登陆
//
//  Created by scjy on 15/5/13.
//  Copyright (c) 2015年 刘孝勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYTJ_LoginView.h"
#import "XYTJ_PersonData_ViewController.h"
@protocol LoginDelegate<NSObject>
-(void)getBOOL:(BOOL)isSuccess objectID:(NSString *)ID;

@end
@interface XYTJ_PersonalViewController : UIViewController<LoginSuccessDelegate>


@property (nonatomic,retain) NSString *nickName;

@property (nonatomic,assign) BOOL isSuccess;

@property (nonatomic,retain) NSString *nID;

@property (nonatomic,assign) id<LoginDelegate>delegate;


@end
