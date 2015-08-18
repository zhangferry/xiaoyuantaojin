//
//  MyPostViewController.m
//  校园淘金--new
//
//  Created by scjy on 15/4/30.
//  Copyright (c) 2015年 刘孝勇. All rights reserved.
//


#import "ShowTableView.h"
#import "MyWantViewController.h"
#import <BmobSDK/Bmob.h>
#import "needInfoModel.h"
#import "LeaveMessageViewController.h"

#import "GouMyTableViewCell.h"
#define ScreenWidth self.view.bounds.size.width
#define ScreenHeight self.view.bounds.size.height
@interface MyWantViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    
    NSString *acc;
    NSMutableArray *postArray;
    UITableView *myTableView;
    NSMutableArray *teleArray;
    NSMutableArray *objectIDArray;
    NSString *telphone;
    NSString *myID;
}
@end

@implementation MyWantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我的求购";
    [self getMyID];
    [self initNetWorkData];
    [self initLayout];
    
}

-(void)getMyID
{
    
    NSArray *documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[[documents lastObject]stringByAppendingPathComponent:@"MyID.id"];
    NSArray *idarr=[NSArray arrayWithContentsOfFile:path];
    myID=idarr[0];
    NSLog(@"%@",myID);
}

-(void)initNetWorkData{
    postArray=[NSMutableArray array];
    teleArray=[NSMutableArray array];
    objectIDArray=[NSMutableArray array];
#pragma mark-数据查询
    BmobQuery *bquery=[BmobQuery queryWithClassName:@"userNeedData"];
    
    [bquery whereKey:@"userId" equalTo:myID];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *obj in array) {
                needInfoModel *objNeed=[[needInfoModel alloc]init];
                objNeed.goodName=[obj objectForKey:@"goodName"];
                objNeed.desc=[obj objectForKey:@"desc"];
                objNeed.contact=[obj objectForKey:@"contact"];
                objNeed.price=[obj objectForKey:@"price"];
                objNeed.address=[obj objectForKey:@"address"];
                objNeed.array=[obj objectForKey:@"messages"];
                objNeed.creatDate=[obj createdAt];
                objNeed.objectID=[obj objectId];
                [postArray addObject:objNeed];
        }
    
        [self performSelectorOnMainThread:@selector(reloadView) withObject:nil waitUntilDone:YES];
    }];
    
}

- (void)reloadView
{
    [myTableView reloadData];
}

-(void)initLayout{
    
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBook)];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    
    self.navigationItem.leftBarButtonItem=left;
    self.navigationItem.rightBarButtonItem=right;
    
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    
    myTableView.delegate=self;
    myTableView.dataSource=self;
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:myTableView];
    
}

-(void)editBook{
    
    [myTableView setEditing:YES animated:YES];//编辑状态
    
}
-(void)finish{
    
    [myTableView setEditing:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"cellID";
    GouMyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell=[[GouMyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor colorWithRed:213.0/255 green:222.0/255 blue:169.0/255 alpha:1.0f];
    }else{
        cell.backgroundColor=[UIColor whiteColor];
    }
    needInfoModel *needModel=[[needInfoModel alloc]init];
    needModel=postArray[indexPath.row];
    cell.headImg.image=[UIImage imageNamed:@"头像"];
    cell.nameLable.text=needModel.goodName;
    cell.content.text=needModel.desc;
    cell.priceLable.text=[NSString  stringWithFormat:@"￥%@",needModel.price];
    cell.campusName.text=needModel.address;
    [cell.contact  addTarget:self action:@selector(contactInfo:) forControlEvents:UIControlEventTouchUpInside];
    cell.contact.tag=200+indexPath.row;
    [teleArray addObject:needModel.contact];
    [objectIDArray addObject:needModel.objectID];
    cell.leaveMessage.tag=300+indexPath.row;
    [cell.leaveMessage setTitle:[NSString stringWithFormat:@"留言(%ld)",needModel.array.count] forState:UIControlStateNormal];
    [cell.leaveMessage  addTarget:self action:@selector(popLeavemessage:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDate *dateNow=[NSDate date];
    NSTimeInterval timeLastFromNow=[dateNow timeIntervalSinceDate:needModel.creatDate];
    int day=timeLastFromNow/(3600*24);
    
    if (day==0) {
        int hour=timeLastFromNow/3600;
        if (hour==0) {
            int minutes=timeLastFromNow/60;
            cell.publishDate.text=[NSString stringWithFormat:@"%d分钟前",minutes];
        }else{
            cell.publishDate.text=[NSString stringWithFormat:@"%d小时前",hour];
        }
    }else{
        cell.publishDate.text=[NSString stringWithFormat:@"%d天前",day];
    }

    return cell;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        NSLog(@"删除");
        needInfoModel *pModel=postArray[indexPath.row];
        BmobObject *bmobject=[BmobObject objectWithoutDatatWithClassName:@"userNeedData" objectId:pModel.objectID];
        
        [bmobject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                
                NSLog(@"删除成功");
                [self initNetWorkData];
                
            }else{
                
                NSLog(@"删除失败");
            }
            
        }];
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
//        [self initNetWorkData];
        //[myTableView reloadData];
        
    }else{
        
        NSLog(@"没有选择");
        
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSLog(@"电话是：%@",telphone);
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telphone]]];
        
        // [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://114"]];
    }else{
        //        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(150, 550,50, 20)];
        //        lable.text=@"QQ号码已经粘贴";
        //        lable.font=[UIFont systemFontOfSize:10];
        //        lable.backgroundColor=[UIColor whiteColor];
        //        lable.textColor=[UIColor blackColor];
        //        [self.view addSubview:lable];
        NSLog(@"qq号复制");
    }
}

-(void)contactInfo:(UIButton *)sender
{
    int a=(int)sender.tag-200;
    NSString *tele=teleArray[a];
    
    UIActionSheet  *sheet=[[UIActionSheet  alloc]initWithTitle:@"联系方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拨打手机" otherButtonTitles:nil , nil];
    [sheet  showInView:self.view];
    telphone=tele;
}
-(void)popLeavemessage:(UIButton *)sender
{
    int a=(int)sender.tag-300;
    NSString *objID=objectIDArray[a];
    LeaveMessageViewController  *leaveMessage=[[LeaveMessageViewController alloc]init];
    leaveMessage.objectID=objID;
    [self presentViewController:leaveMessage animated:YES completion:nil];
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;//编辑状态，删除
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return postArray.count;
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
