//
//  SendViewController.m
//  校园淘金
//
//  Created by scjy on 15/4/21.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "SendViewController.h"
#import "ViewController.h"
#import <BmobSDK/Bmob.h>
#import "UIUtils.h"
#import "MXPullDownMenu.h"
#define ScreenWidth self.view.bounds.size.width
#define ScreenHeight self.view.bounds.size.height

@interface SendViewController ()
{
    
    UIView *bgView;//背景视图
    MXPullDownMenu *menu;
    UILabel *lable;
    UIButton *allTradeType;//分类按钮
    UITextField *text;//交易地点，手机号，qq号
    
    NSString *goodAddress;
    NSString *userPhone;
    NSString *userQQ;
    NSString *goodType;
    NSArray *testArray;
    NSString *myID;
    
}
@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self ain];
    
    
    
}

-(void)ain
{
    [self bgView];
    [self runbg];//运行按钮的整条背景框,运行按钮（取消，下一步）
    [self tradeType];//交易类型
    [self info];//交易地点,手机号,QQ号
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getMyID];
}
-(void)getMyID
{
    
    NSArray *documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[[documents lastObject]stringByAppendingPathComponent:@"MyID.id"];
    NSArray *idarr=[NSArray arrayWithContentsOfFile:path];
    myID=idarr[0];
    NSLog(@"%@",myID);
}
#pragma mark--背景视图
-(void)bgView
{
    
    bgView=[[UIView alloc]init];
    bgView.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
}

#pragma mark--运行按钮的背景框,运行按钮（上一步，完成）
-(void)runbg
{
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    viewTop.backgroundColor=[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    [bgView addSubview:viewTop];

    
    UIView *topBg=[[UIView alloc]init];
    topBg.frame=CGRectMake(0, 20, ScreenWidth, 35);
    topBg.backgroundColor=[UIColor colorWithRed:1.0 green:0 blue:00 alpha:0.5];
    [bgView addSubview:topBg];
    
    UIButton *lastButton=[UIButton buttonWithType:UIButtonTypeCustom];
    lastButton.frame=CGRectMake(5, 22.5, 75, 30);
    [lastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // lastButton.layer.borderWidth=1.0f;//设置边框大小
    lastButton.layer.borderColor=[[UIColor whiteColor]CGColor];//设置边框颜色
    // lastButton.layer.cornerRadius=6.0f;
    lastButton.layer.masksToBounds=YES;
    [lastButton setTitle:@"上一步" forState:UIControlStateNormal];
    [lastButton addTarget:self action:@selector(lastView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:lastButton];
    
    UIButton *successButton=[UIButton buttonWithType:UIButtonTypeCustom];
    successButton.frame=CGRectMake(ScreenWidth-85, 22.5, 75, 30);
    [successButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    successButton.layer.borderWidth=1.0f;//设置边框大小
    successButton.layer.borderColor=[[UIColor whiteColor]CGColor];//设置边框颜色
    successButton.layer.cornerRadius=6.0f;
    successButton.layer.masksToBounds=YES;
    [successButton setTitle:@"完成" forState:UIControlStateNormal];
    [successButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:successButton];
    
}

#pragma mark--交易类型
-(void)tradeType
{
    
    testArray =  @[@[ @"类型",@"手机", @"二手书", @"笔记本", @"自行车", @"其他"] ];
    menu = [[MXPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor greenColor]];
    menu.delegate = self;
    menu.frame = CGRectMake(0, 100, ScreenWidth, 50);
    [bgView addSubview:menu];
    
}

#pragma mark - MXPullDownMenuDelegate
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    
    goodType=testArray[column][row];
    
}

#pragma mark--交易地点,手机号,QQ号
-(void)info
{
    NSArray *tittle=@[@"交易地点",@"  手机号",@"  QQ号"];
    for (int i=0; i<3; i++) {
        lable =[[UILabel alloc]init];
        lable.frame=CGRectMake(0.35*[UIUtils getWindowWidth], CGRectGetMaxY(menu.frame)+ScreenHeight*i*1/6, 80, ScreenHeight*1/12);
        lable.text=tittle[i];
        lable.tag=100+10*i;
        [bgView addSubview:lable];
        
        text=[[UITextField alloc]init];
        text.frame=CGRectMake(10,CGRectGetMaxY(lable.frame)+5*i, ScreenWidth-20, ScreenHeight*1/12);
        text.backgroundColor=[UIColor colorWithRed:0.802 green:0.895 blue:0.776 alpha:1.000];
        text.delegate=self;
        text.tag=100+i;
        text.textAlignment=1;
        lable.tag=100+i;
       
        if (lable.tag==101) {
            text.placeholder=@"请输入11位手机号,不要输错哦亲。";
            
        }
        if (lable.tag==102) {
            text.placeholder=@"请输入QQ号不要输错哦亲。";
        }
        [bgView addSubview:text];
        
        
    }
}

#pragma mark--textField开始编辑的时候，屏幕上移
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (text.tag!=200) {
        
        bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [UITextField animateWithDuration:0.1 animations:^{
            bgView.frame = CGRectMake(0, -215, ScreenWidth, ScreenHeight-215);
            
        }];
    }

}

#pragma mark--textField   点击return后，键盘隐藏
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark-- textField编辑结束的时候，屏幕自动还原
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    switch (textField.tag) {
        case 100:
            goodAddress=textField.text;
            break;
        case 101:
            userPhone=textField.text;
            break;
        case 102:
            userQQ=textField.text;
            break;
        default:
            break;
    }
    
    
    bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}

-(void)lastView
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)finish
{
    
    if (self.imageUrl==nil) {
        
        UIAlertView *publishAlert=[[UIAlertView alloc]initWithTitle:@"发布状态" message:@"未插入图片" delegate:self cancelButtonTitle:@"取消发布" otherButtonTitles:@"插入图片", nil];
        [publishAlert show];
        
    }else{
        
        NSDate *dateNow=[NSDate date];
        BmobObject  *publishGood = [BmobObject objectWithClassName:@"purchaseData"];
        [publishGood setObject:self.imageUrl forKey:@"imageUrl"];
        [publishGood setObject:self.goodTitle forKey:@"goodTitle"];
        [publishGood setObject:self.goodPrice forKey:@"goodPrice"];
        [publishGood setObject:self.goodDesc forKey:@"goodDesc"];
        [publishGood setObject:goodAddress forKey:@"sendAddress"];
        [publishGood setObject:userPhone forKey:@"userPhone"];
        [publishGood setObject:userQQ forKey:@"userQQ"];
        [publishGood setObject:goodType forKey:@"goodType"];
        [publishGood setObject:dateNow forKey:@"publishDate"];
        
        [publishGood setObject:[BmobObject objectWithoutDatatWithClassName:@"UserInfo" objectId:myID] forKey:@"userId"];
        
        [publishGood saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
           
            NSLog(@"objectid :%@",publishGood.objectId);
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"发布状态" message:@"发布成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认发布", nil];
            [alert show];
         }
        }];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
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
