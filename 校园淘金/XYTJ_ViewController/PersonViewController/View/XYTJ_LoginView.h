//
//  XYTJ_LoginView.h
//  校园淘金--登陆
//
//  Created by scjy on 15/5/14.
//  Copyright (c) 2015年 刘孝勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobObject.h>
@protocol LoginSuccessDelegate<NSObject>
-(void)getBOOL:(BOOL)isSuccess objectID:(NSString *)ID UserData:(NSMutableDictionary *)UserDic;



@end
@interface XYTJ_LoginView : UIView<UITextFieldDelegate>
{
    NSString *acc1;
    NSString *pass1;
    NSString *acc2;
    NSString *pass2;
    int num1;
    BmobObject *newUser;
    NSArray *userArray;
    UIButton *save;
    NSMutableDictionary *UserDictionary;
    int num2;
    NSString *ID;
    NSMutableDictionary *userDataDic;
}
@property (nonatomic,assign) BOOL success;
@property (nonatomic,assign) id<LoginSuccessDelegate>delegate;

@end
