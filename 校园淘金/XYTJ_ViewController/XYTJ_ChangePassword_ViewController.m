//
//  XYTJ_ChangePassword_ViewController.m
//  校园淘金--登陆
//
//  Created by scjy on 15/5/20.
//  Copyright (c) 2015年 刘孝勇. All rights reserved.
//

#import "XYTJ_ChangePassword_ViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobObject.h>
#define ScreenWidth self.view.bounds.size.width
#define ScreenHeight self.view.bounds.size.height
@interface XYTJ_ChangePassword_ViewController ()
{
    NSString *password;
}
@end

@implementation XYTJ_ChangePassword_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *arr = @[@"原密码",@"新密码",@"确认新密码"];
    for (int i = 0; i<arr.count; i++) {
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(100, ScreenHeight/3+64*i, ScreenWidth-100, 44)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, ScreenHeight/3+64*i, 90, 44)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.tag = 55+i;
        textField.delegate = self;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.text = arr[i];
        [self.view addSubview:label];
        [self.view addSubview:textField];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(80, ScreenHeight/3+64*3+30, ScreenWidth-160, 50);
    button.backgroundColor = [UIColor cyanColor];
    [button setTitle:@"提 交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)searchData
{
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"UserInfo"];
    [bquery getObjectInBackgroundWithId:self.ID block:^(BmobObject *object,NSError *error){
        if (error){
        }else{
            if (object) {
                password = [object objectForKey:@"password"];
                [self SavePassword];
            }
        }
    }];
}

-(void)SavePassword
{
    UITextField *textField1 = (UITextField *)[self.view viewWithTag:55];
    UITextField *textField2 = (UITextField *)[self.view viewWithTag:56];
    UITextField *textField3 = (UITextField *)[self.view viewWithTag:57];
    if ([textField1.text isEqualToString:password]) {
        if (textField2.text.length != 0&&[textField2.text isEqualToString:textField3.text]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"新密码已保存，下次登录请使用新密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            password = textField2.text;
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"UserInfo"];
            [bquery getObjectInBackgroundWithId:self.ID block:^(BmobObject *object,NSError *error){
                if (!error) {
                    if (object) {
                        BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                        [obj1 setObject:textField2.text forKey:@"password"];
                        //异步更新数据
                        [obj1 updateInBackground];
                        [alert show];
                    }
                }else{
                    //进行错误处理
                }
            }];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请确认新密码输入是否一致" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的密码" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
