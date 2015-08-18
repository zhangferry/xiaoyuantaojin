//
//  NextViewController.m
//  4.22-校园淘金-求购界面
//
//  Created by scjy on 15/4/23.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "NextViewController.h"
#define ScreenWidth self.view.bounds.size.width
#import <BmobSDK/Bmob.h>
#import "GouViewController.h"

#define NUMBERS

@interface NextViewController ()
{
    NSString *price;
    NSMutableDictionary *dataInfo;
    NSString *myID;
    NSDictionary *myDic;
}
@end

@implementation NextViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"求购的宝贝";
    dataInfo=[NSMutableDictionary dictionary];
    
    self.view.backgroundColor=[UIColor colorWithRed:237.0/255 green:237.0/255 blue:238.0/255 alpha:1.0f];
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    viewTop.backgroundColor=[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:viewTop];
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth,35 )];
    titleView.backgroundColor=[UIColor  colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:titleView];
    
    UIButton *returnM=[UIButton buttonWithType:UIButtonTypeCustom];
    [returnM setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    returnM.frame=CGRectMake(5, 0, 35, 35);
    [returnM addTarget:self action:@selector(returnMain) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:returnM];
    
    
    UIButton *publishGoods=[UIButton buttonWithType:UIButtonTypeCustom];
    publishGoods.frame=CGRectMake(CGRectGetMaxX(returnM.frame)+250, 0, 100, 35);
    [publishGoods setTitle:@"发布" forState:UIControlStateNormal];
    [publishGoods addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    publishGoods.tintColor=[UIColor blackColor];
    //publishGoods.titleLabel.font=[UIFont systemFontOfSize:20];
    [titleView addSubview:publishGoods];

    [self  describe];
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
   
    NSArray *documents2=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path2=[[documents2 lastObject]stringByAppendingPathComponent:@"MyData.id"];
    myDic = [NSDictionary dictionaryWithContentsOfFile:path2];
}

//
-(void)describe{
    
    NSArray *arr=@[@"标题",@"描述",@"价格",@"电话"];
    
    for (int i=0; i<4; i++) {
        
        UILabel *goodsLable=[[UILabel alloc]init];
        goodsLable.frame=CGRectMake(0,110+50*i+10, 80, 40);
        goodsLable.backgroundColor=[UIColor  whiteColor];
        goodsLable.text=arr[i];
        goodsLable.textAlignment=1;
        [self.view addSubview:goodsLable];
        
        UITextField *editText=[[UITextField  alloc]init];
        editText.frame=CGRectMake(82, 110+50*i+10, ScreenWidth-82, 40);
        editText.backgroundColor=[UIColor whiteColor];
        editText.textAlignment=0;
        editText.delegate=self;
        editText.text=@"";
        editText.tag=10+i;
        if (editText.tag==11) {
            editText.placeholder=@"  不少于15个字，并且不多于100个字   ";
        }else if(editText.tag==13)
        {
            
            editText.placeholder=@" 输入11位的号码 ";
        }else if (editText.tag==12) {
            editText.placeholder=@" 期望的价格且只能输入数字  ";
        }
        
        [self.view addSubview:editText];
    }

    }

-(void)returnMain{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 10:
            [dataInfo setObject:textField.text forKey:@"name"];
            break;
        case 11:
            [dataInfo setObject:textField.text forKey:@"desc"];
            break;
        case 12:
            [dataInfo setObject:textField.text forKey:@"price"];
            break;
        case 13:
            [dataInfo setObject:textField.text forKey:@"contact"];
            break;
            default:
            break;
    }
    
}
-(void)post{
    
    if ([dataInfo[@"name"] isEqual:@""]) {
        
    }else{
    
        
        NSDate *date=[NSDate date];
        BmobObject  *gameScore = [BmobObject objectWithClassName:@"userNeedData"];
        
        [gameScore setObject:dataInfo[@"name"] forKey:@"goodName"];
        
        [gameScore setObject:dataInfo[@"desc"] forKey:@"desc"];
        [gameScore setObject:dataInfo[@"price"] forKey:@"price"];
        [gameScore setObject:dataInfo[@"contact"] forKey:@"contact"];
        [gameScore setObject:myID forKey:@"userId"];
        //[gameScore setObject:date forKey:@"creatDate"];
       // [gameScore setObject:myDic[@"address"] forKey:@"address"];
        
        [gameScore setObject:date forKey:@"creatDate"];
        
        [gameScore setObject:[BmobObject objectWithoutDatatWithClassName:@"UserInfo" objectId:myID] forKey:@"userId"];
        
        [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"状态" message:@"发布成功" delegate:self cancelButtonTitle:@"继续发布" otherButtonTitles:@"确定", nil];
                alter.delegate=self;
                [alter show];

            }else{
                
            }
        }];

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
//        GouViewController *gouViewController=[[GouViewController alloc]init];
//        
//        [gouViewController initData];
//        [self presentViewController:gouViewController animated:YES completion:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
      
            
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
