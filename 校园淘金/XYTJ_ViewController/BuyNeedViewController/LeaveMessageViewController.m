//
//  LeaveMessageViewController.m
//  校园淘金
//
//  Created by scjy on 15/5/16.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "LeaveMessageViewController.h"
#import "CommentTableViewCell.h"
#import <BmobSDK/Bmob.h>
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface LeaveMessageViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView  *textSendView;
    UIButton *send;
    int keyboardHeight;
    NSString *message;
    NSMutableArray *messageArray;
    NSString *_objectID;
    
    UITableView *myTableView;
    NSMutableArray *dataArray;
    UITextField *textInputField;
    
    NSString *myID;
    NSDictionary *myDic;
}
@end

@implementation LeaveMessageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _objectID=self.objectID;
    [self initkeyBoard];
    [self initData];
    [self initView];

}

-(void)initkeyBoard{
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
}

-(void)getMyID
{
    
    NSArray *documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[[documents lastObject]stringByAppendingPathComponent:@"MyID.id"];
    NSArray *idarr=[NSArray arrayWithContentsOfFile:path];
    myID=idarr[0];
    NSLog(@"%@",myID);
    NSArray *documents2=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path2=[[documents2 lastObject]stringByAppendingPathComponent:@"MyData.id"];
    myDic = [NSDictionary dictionaryWithContentsOfFile:path2];
    NSString *myNickname = myDic[@"nickname"];
    NSLog(@"%@",myNickname);
}


-(void)initView{
    
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 35)];
    titleView.backgroundColor=[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:titleView];
    
    UIButton *returnBUtton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[returnBUtton setTitle:@"返回" forState:UIControlStateNormal];
    [returnBUtton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    returnBUtton.frame=CGRectMake(10, 0, 30, 35);
    [returnBUtton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [returnBUtton addTarget:self action:@selector(returnMain) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:returnBUtton];
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-20, 0, 40, 35)];
    titleLable.text=@"评论";
    titleLable.textColor=[UIColor whiteColor];
    [titleView addSubview:titleLable];
    
    self.view.backgroundColor=[UIColor colorWithRed:230.0/255 green:237.0/255 blue:238.0/255 alpha:1.0f];
    textSendView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-40, ScreenWidth, 40)];
    textSendView.layer.borderWidth=1;
    textSendView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    textSendView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:textSendView];
//    [self.view bringSubviewToFront:textSendView];
    
    send=[[UIButton  alloc]initWithFrame:CGRectMake(ScreenWidth-50, 0, 50, 40)];
    send.backgroundColor=[UIColor whiteColor];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send setBackgroundColor:[UIColor grayColor]];
    send.layer.cornerRadius=5;
    [send addTarget:self action:@selector(upp) forControlEvents:UIControlEventTouchUpInside];
    [textSendView addSubview:send];
    
    textInputField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-50, 40)];
    textInputField.delegate=self;
    textInputField.placeholder=@"点击这里评论";
    [textSendView addSubview:textInputField];
    
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight-40-50) style:UITableViewStylePlain];
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    myTableView.delegate=self;
    myTableView.dataSource=self;
    [self.view addSubview:myTableView];

    
}

-(void)initData{
    
    dataArray=[NSMutableArray array];
    messageArray=[NSMutableArray array];
#pragma mark-数据查询
    BmobQuery *bquery=[BmobQuery queryWithClassName:@"userNeedData"];
    [bquery getObjectInBackgroundWithId:_objectID block:^(BmobObject *object, NSError *error) {
        
        if (!error) {
            if (object) {
                
                NSArray *array=[object objectForKey:@"messages"];
                dataArray=[array copy];
            
            }
            [myTableView reloadData];
            
            }
        
    }];
    
}
#pragma mark-发布评论
-(void)upp{
    
    if ([message isEqual:@""]) {
        
        NSLog(@"评论不能为空");
    }else{
        
        BmobQuery *bquery=[BmobQuery queryWithClassName:@"userNeedData"];
        [bquery getObjectInBackgroundWithId:_objectID block:^(BmobObject *object, NSError *error) {
           
            if (!error) {
                if (object) {
                    
                    messageArray=[object objectForKey:@"messages"];
                    [messageArray addObject:message];
                    BmobObject *obj=[BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                    
                    [obj setObject:[NSArray arrayWithArray:messageArray] forKey:@"messages"];
                    [obj updateInBackground];
                    
                    [self initData];
                    
                    [textInputField resignFirstResponder];
                    textInputField.text=@"";
                    message=@"";
                    
                }else{
                    NSLog(@"发布失败");
                }
            }
            
        }];
        
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"cellID";
    CommentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.headerImage.image=[UIImage imageNamed:@"userDefault"];
    cell.userName.text=@"匿名";
    cell.message.text=dataArray[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)returnMain{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//textField的代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    textSendView.frame=CGRectMake(0, ScreenHeight-40-keyboardHeight, ScreenWidth, 40);
    message=textField.text;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    message=textField.text;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    textSendView.frame=CGRectMake(0, ScreenHeight-40, ScreenWidth, 40);
    [textField resignFirstResponder];
    
    return YES;
}

//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardHeight = keyboardRect.size.height;
    
    [self.view addSubview:textSendView];
    [UIView animateWithDuration:0.2 animations:^{
        textSendView.frame=CGRectMake(0, ScreenHeight-40-keyboardHeight, ScreenWidth, 40);
    }];

    
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
