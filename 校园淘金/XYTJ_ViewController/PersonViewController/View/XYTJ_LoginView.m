//
//  XYTJ_LoginView.m
//  校园淘金--登陆
//
//  Created by scjy on 15/5/14.
//  Copyright (c) 2015年 刘孝勇. All rights reserved.
//

#import "XYTJ_LoginView.h"
#import "XYTJ_PersonalViewController.h"
#define ScreenWidth self.bounds.size.width
#define ScreenHeight self.bounds.size.height
@implementation XYTJ_LoginView

-(instancetype)initWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor clearColor];
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView
{
    userDataDic = [NSMutableDictionary dictionary];
    UserDictionary = [NSMutableDictionary dictionary];
    UIView *loginView = [[UIView alloc]initWithFrame:CGRectMake(40, ScreenHeight/3-40, ScreenWidth-80, ScreenHeight/3)];
    loginView.translatesAutoresizingMaskIntoConstraints=NO;
    loginView.backgroundColor = [UIColor colorWithRed:0.630 green:0.919 blue:1.000 alpha:1.000];
    loginView.tag = 100;
    [self addSubview:loginView];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, loginView.bounds.size.width-160, loginView.bounds.size.height/6)];
    nameLabel.text = @"请登录";
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.backgroundColor = [UIColor clearColor];
    [loginView addSubview:nameLabel];
    UITextField *account=[[UITextField alloc]initWithFrame:CGRectMake(20, loginView.bounds.size.height/6+10, loginView.bounds.size.width-40, loginView.bounds.size.height/4)];
    account.backgroundColor=[UIColor whiteColor];
    account.delegate=self;
    account.placeholder=@"请输入帐号";
    account.tag=1;
    account.borderStyle=UITextBorderStyleRoundedRect;
    account.clearButtonMode=UITextFieldViewModeWhileEditing;
    [loginView addSubview:account];
    UITextField *passWord=[[UITextField alloc]initWithFrame:CGRectMake(20, loginView.bounds.size.height/4+loginView.bounds.size.height/6+12, loginView.bounds.size.width-40, loginView.bounds.size.height/4)];
    passWord.backgroundColor=[UIColor whiteColor];
    passWord.delegate=self;
    passWord.placeholder=@"请输入密码";
    passWord.tag=2;
    passWord.borderStyle=UITextBorderStyleRoundedRect;
    passWord.secureTextEntry=YES;
    [loginView addSubview:passWord];
    UIButton *startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setTitle:@"登 录" forState:UIControlStateNormal];
    startButton.backgroundColor=[UIColor cyanColor];
    startButton.frame = CGRectMake(80, loginView.bounds.size.height *3/4+10, loginView.bounds.size.width-160, loginView.bounds.size.height/4-10);
    
    [startButton addTarget:self action:@selector(logining) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:startButton];
    UIButton *newButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [newButton setTitle:@"新用户" forState:UIControlStateNormal];
    newButton.frame = CGRectMake(10, loginView.bounds.size.height *5/6+10, 60, loginView.bounds.size.height/6-10);
    [newButton addTarget:self action:@selector(newUser) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:newButton];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelToLogin) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(CGRectGetMaxX(startButton.frame)+10, loginView.bounds.size.height *5/6+10, 60, loginView.bounds.size.height/6-10);
    [loginView addSubview:cancelButton];
    
    
}
-(void)logining
{
    UITextField *textField1=(UITextField *)[self viewWithTag:1];
    UITextField *textField2=(UITextField *)[self viewWithTag:2];
    acc1=textField1.text;
    pass1=textField2.text;
    NSLog(@"%@ %@",acc1,pass1);
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"UserInfo"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSLog(@"%@",array);
        for (BmobObject *obj in array) {
            NSString *account = [NSString string];
            NSString *password = [NSString string];
            ID = [NSString string];
            account = [obj objectForKey:@"account"];
            password = [obj objectForKey:@"password"];
            ID = obj.objectId;
            NSString *nickname = [obj objectForKey:@"nickname"];
            NSString *phone = [obj objectForKey:@"phone"];
            NSString *QQ = [obj objectForKey:@"qq"];
            NSString *schoolName = [obj objectForKey:@"school"];
            NSString *address = [obj objectForKey:@"address"];
            NSString *headImageUrl = [obj objectForKey:@"headImageUrl"];
            NSData *headImagedata=[NSData dataWithContentsOfURL:[NSURL URLWithString:headImageUrl]];
            NSDictionary *allDic = [NSDictionary dictionaryWithObjectsAndKeys:password,@"password",ID,@"id",nickname,@"nickname",phone,@"phone",schoolName,@"school",address,@"address",QQ,@"qq",headImagedata,@"headImagedata", nil];
            [UserDictionary setObject:allDic forKey:account];
        }
        NSLog(@"111%@",UserDictionary);
        [self check];
    }];
}
-(void)check
{
    UITextField *textField1=(UITextField *)[self viewWithTag:1];
    UITextField *textField2=(UITextField *)[self viewWithTag:2];
    NSLog(@"%@",ID);
    for(id key in UserDictionary)
    {
        if ([acc1 isEqualToString:key]) {
            num2 = 1;
        }
    }
    if (num2 == 1 && [pass1 isEqualToString:UserDictionary[acc1][@"password"]]) {
        userDataDic = UserDictionary[acc1];
        self.success = YES;
        
        NSArray *documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path=[[documents lastObject]stringByAppendingPathComponent:@"MyID.id"];
        NSLog(@"%@",path);
        NSArray *dataArr=@[UserDictionary[acc1][@"id"]];
        NSArray *documents2=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path2=[[documents2 lastObject]stringByAppendingPathComponent:@"MyData.id"];
        NSMutableDictionary *datadic = [NSMutableDictionary dictionaryWithDictionary:userDataDic];
        NSLog(@"%@",datadic);
        [datadic writeToFile:path2 atomically:YES];
        BOOL iss= [dataArr writeToFile:path atomically:YES];
        if (iss == YES) {
            NSLog(@"%@",path);
        }

        
        [self.delegate getBOOL:YES objectID:UserDictionary[acc1][@"id"] UserData:UserDictionary[acc1]];
        [self removeFromSuperview];
        [textField1 removeFromSuperview];
        [textField2 removeFromSuperview];
    }else{
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请输入正确的帐号或密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alter show];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    弹回键盘
    [textField resignFirstResponder];
    return YES;
}
-(void)cancelToLogin
{
    [self removeFromSuperview];
}
-(void)newUser
{
    UIView *viewed = [self viewWithTag:100];
    [viewed removeFromSuperview];
    UIView *newUserView = [[UIView alloc]initWithFrame:CGRectMake(40, ScreenHeight/3-40, ScreenWidth-80, ScreenHeight/3)];
    newUserView.backgroundColor = [UIColor colorWithRed:0.630 green:0.919 blue:1.000 alpha:1.000];
    newUserView.tag = 200;
    [self addSubview:newUserView];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, newUserView.bounds.size.width-100, newUserView.bounds.size.height/6)];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.text = @"注册新用户";
    nameLabel.backgroundColor = [UIColor clearColor];
    [newUserView addSubview:nameLabel];
    UITextField *account=[[UITextField alloc]initWithFrame:CGRectMake(20, newUserView.bounds.size.height/6+10, newUserView.bounds.size.width-40, newUserView.bounds.size.height/4)];
    account.backgroundColor=[UIColor whiteColor];
    account.delegate=self;
    account.placeholder=@"请输入帐号";
    account.tag=3;
    account.borderStyle=UITextBorderStyleRoundedRect;
    account.clearButtonMode=UITextFieldViewModeWhileEditing;
    [newUserView addSubview:account];
    UITextField *passWord=[[UITextField alloc]initWithFrame:CGRectMake(20, newUserView.bounds.size.height/4+newUserView.bounds.size.height/6+12, newUserView.bounds.size.width-40, newUserView.bounds.size.height/4)];
    passWord.backgroundColor=[UIColor whiteColor];
    passWord.delegate=self;
    passWord.placeholder=@"请输入密码";
    passWord.tag=4;
    passWord.borderStyle=UITextBorderStyleRoundedRect;
    passWord.secureTextEntry=YES;
    [newUserView addSubview:passWord];
    
    UIButton *saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保 存" forState:UIControlStateNormal];
    saveButton.backgroundColor=[UIColor cyanColor];
    [saveButton addTarget:self action:@selector(saving) forControlEvents:UIControlEventTouchUpInside];
    saveButton.frame = CGRectMake(80, newUserView.bounds.size.height *3/4+10, newUserView.bounds.size.width-160, newUserView.bounds.size.height/4-10);
    [newUserView addSubview:saveButton];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"返回登录" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToLogin) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(CGRectGetMaxX(saveButton.frame), newUserView.bounds.size.height *5/6+10, 80, newUserView.bounds.size.height/6-10);
    [newUserView addSubview:backButton];

}
-(void)saving
{
    UITextField *textField3=(UITextField *)[self viewWithTag:3];
    UITextField *textField4=(UITextField *)[self viewWithTag:4];
    acc2=textField3.text;
    pass2=textField4.text;
    newUser = [[BmobObject alloc]initWithClassName:@"UserInfo"];
    [newUser setObject:acc2 forKey:@"account"];
    [newUser setObject:pass2 forKey:@"password"];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"UserInfo"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            NSLog(@"%@", [obj objectForKey:@"account"]);
            NSLog(@"%@", acc2);
            NSString *string1 = [obj objectForKey:@"account"];
            if ([acc2 isEqualToString:string1]) {
                num1 = 1;
            }
        }
        [self ee];
    }];
}
-(void)ee
{
    if (num1 == 1) {
        UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"该帐号已存在" delegate:nil  cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert1 show];
    }else{
        [newUser saveInBackground];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已保存" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
-(void)backToLogin
{
    UIView *viewed = [self viewWithTag:200];
    [viewed removeFromSuperview];
    [self initView];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
