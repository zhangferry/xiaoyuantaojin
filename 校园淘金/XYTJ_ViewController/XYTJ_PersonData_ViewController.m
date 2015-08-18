//
//  XYTJ_PersonData_ViewController.m
//  校园淘金--登陆
//
//  Created by scjy on 15/5/15.
//  Copyright (c) 2015年 刘孝勇. All rights reserved.
//

#import "XYTJ_PersonData_ViewController.h"
#import "XYTJ_PersonalViewController.h"
#import "XYTJ_PersonalDataTableViewCell.h"
#import "XYTJ_ChangePassword_ViewController.h"
#import "SuggestViewController.h"
#import "AboutUsViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobObject.h>
@interface XYTJ_PersonData_ViewController ()<UITextFieldDelegate>
{
    
    NSArray *arr1;
    NSArray *arr2;
    NSArray *arr3;
    NSArray *arr4;
    UITableView *personalView;
    NSMutableDictionary *dataDictionary;
    NSMutableDictionary *PersonalData;
    int num;
    UIView *myView;
    UITextField *nickname;
    UITextField *phone;
    UITextField *qq;
    UITextField *school;
    UITextField *address;
    
}
@end

@implementation XYTJ_PersonData_ViewController
#pragma mark--添加左右导航键
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    NSLog(@"%@",self.ID);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回首页" style:UIBarButtonItemStylePlain target:self action:@selector(Ruturn)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存修改" style:UIBarButtonItemStylePlain target:self action:@selector(Save)];
    self.navigationItem.rightBarButtonItem = rightItem;

    dataDictionary = [NSMutableDictionary dictionary];
    for (id key in self.UserDictionary) {
        [dataDictionary setValue:self.UserDictionary[key] forKey:key];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    personalView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    //personalView.
    personalView.backgroundColor= [UIColor colorWithRed:230.0/255 green:237.0/255 blue:238.0/255 alpha:1.0f];
    personalView.delegate = self;
    personalView.dataSource = self;
    [self.view addSubview:personalView];
    arr1 = @[@"昵称",@"手机号",@"QQ号",@"学校",@"地址"];
    arr2 = @[@"意见反馈",@"关于我们",@"修改密码"];
    arr3 = @[@"nickname",@"phone",@"qq",@"school",@"address"];
}
#pragma mark--返回昵称
-(void)Ruturn
{
    XYTJ_PersonalViewController *PVC = [[XYTJ_PersonalViewController alloc]init];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    PVC.nickName = dataDictionary[@"nickname"];
    PVC.isSuccess = YES;
    PVC.nID = self.ID;
}
#pragma mark--键盘弹回
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return arr1.count;
    }
   
    return arr2.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cells";
    XYTJ_PersonalDataTableViewCell *cells=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cells) {
        
        cells.selectionStyle=UITableViewCellSelectionStyleNone;
        cells=[[XYTJ_PersonalDataTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    if (indexPath.section==0) {
        cells.nameLabel.text = arr1[indexPath.row];
        cells.detailTextField.text = dataDictionary[arr3[indexPath.row]];
        cells.detailTextField.tag = 14+indexPath.row;
        cells.detailTextField.delegate = self;
    }else{
        cells.textLabel.font = [UIFont systemFontOfSize:20];
        cells.textLabel.text = arr2[indexPath.row];
    }
    
    return cells;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1&&indexPath.row == 0) {
        SuggestViewController *SVC = [[SuggestViewController alloc]init];
        [self.navigationController pushViewController:SVC animated:YES];
    }
    if (indexPath.section == 1&&indexPath.row == 1) {
        AboutUsViewController *AUVC = [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:AUVC animated:YES];
    }
    if (indexPath.section == 1&&indexPath.row == 2) {
        XYTJ_ChangePassword_ViewController *CPVC = [[XYTJ_ChangePassword_ViewController alloc]init];
        [self.navigationController pushViewController:CPVC animated:YES];
        CPVC.ID = self.ID;
        
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
#pragma mark--获取更新的信息
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    nickname = (UITextField *)[self.view viewWithTag:14];
    phone = (UITextField *)[self.view viewWithTag:15];
    qq = (UITextField *)[self.view viewWithTag:16];
    school = (UITextField *)[self.view viewWithTag:17];
    address = (UITextField *)[self.view viewWithTag:18];
    [dataDictionary setObject:nickname.text forKey:arr3[0]];

}
#pragma mark--保存更新的信息
- (void)Save
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"UserInfo"];
    [bquery getObjectInBackgroundWithId:self.ID block:^(BmobObject *object,NSError *error){
        if (!error) {
            if (object) {
                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                //设置cheatMode为YES
                [obj1 setObject:nickname.text forKey:arr3[0]];
                [obj1 setObject:phone.text forKey:arr3[1]];
                [obj1 setObject:qq.text forKey:arr3[2]];
                [obj1 setObject:school.text forKey:arr3[3]];
                [obj1 setObject:address.text forKey:arr3[4]];
                
                NSArray *documents2=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *path2=[[documents2 lastObject]stringByAppendingPathComponent:@"MyData.id"];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path2];
                NSMutableDictionary *myDataDic = [NSMutableDictionary dictionary];
                //[myDataDic setObject:dic[@"headImagedata"] forKey:@"headImagedata"];
                [myDataDic setObject:dic[@"id"] forKey:@"id"];
                [myDataDic setObject:nickname.text forKey:arr3[0]];
                [myDataDic setObject:phone.text forKey:arr3[1]];
                [myDataDic setObject:qq.text forKey:arr3[2]];
                [myDataDic setObject:school.text forKey:arr3[3]];
                [myDataDic setObject:address.text forKey:arr3[4]];
                [myDataDic writeToFile:path2 atomically:YES];
                
                //异步更新数据
                 UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"信息已保存" delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert1 show];
                [obj1 updateInBackground];
            }
        }else{
            //进行错误处理
        }
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
