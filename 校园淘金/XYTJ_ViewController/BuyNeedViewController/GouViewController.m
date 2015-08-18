//
//  GouViewController.m
//  校园淘金
//
//  Created by zhangfei on 15/4/23.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "GouViewController.h"
#import "GouMyTableViewCell.h"
#import "NextViewController.h"
#import "ViewController.h"
#import <BmobSDK/Bmob.h>
#import "needInfoModel.h"
#import "XYTJ_LoginView.h"
#import "LeaveMessageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface GouViewController ()
{
    UITableView *myTableView;
   
    NSMutableDictionary *plistDic;
    int lineNum;
    NSArray *allUser;
    NSMutableArray *dataArray;
    NSMutableArray *objectIDArray;
    needInfoModel *objNeed;
    NSString *telphone;
    NSMutableArray *teleArray;
    NSArray *messageArray;
    NSString *myID;
    UIView *titleView;
    
    
    UIImage *netImage;
   
  
    NSMutableArray *imageUrlArray;
    NSMutableArray *nickNameArray;
    NSMutableArray *addressArray;
    NSMutableArray *IDArray;
    NSDictionary *myDic;
}
@end

@implementation GouViewController

- (void)viewDidLoad {
    self.title=@"求购区";
#pragma mark-上传文件
    
    self.view.backgroundColor=[UIColor  whiteColor];
    [self getMyID];
   
    [self initView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self getMyID];
    [self initData];
    
}
// 求购信息的内容
-(void)initView{
   
    
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    viewTop.backgroundColor=[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:viewTop];
    
    titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth,35 )];
    titleView.backgroundColor=[UIColor  colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:titleView];
    
    
    UIButton *publishGoods=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-100, 0, 100, 35)];
    [publishGoods setTitle:@"发布求购" forState:UIControlStateNormal];
    [publishGoods addTarget:self action:@selector(pushToNext) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:publishGoods];
    
    
}
-(void)initTableView{
    myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), self.view.bounds.size.width,self.view.bounds.size.height-CGRectGetMaxY(titleView.frame)-50 ) style:UITableViewStylePlain];
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    myTableView.delegate=self;
    myTableView.dataSource=self;
    
    [self.view addSubview:myTableView];
}


-(void)initData{
    IDArray=[NSMutableArray array];
    dataArray=[NSMutableArray array];
    teleArray=[NSMutableArray array];
    objectIDArray=[NSMutableArray array];
    nickNameArray=[NSMutableArray array];
    addressArray=[NSMutableArray array];
    imageUrlArray=[NSMutableArray array];
    
#pragma mark-数据查询
    BmobQuery *bquery=[BmobQuery queryWithClassName:@"userNeedData"];
    [bquery orderByDescending:@"creatDate"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error) {
            
            for (BmobObject *obj in array) {
                objNeed=[[needInfoModel alloc]init];
                objNeed.goodName=[obj objectForKey:@"goodName"];
                objNeed.desc=[obj objectForKey:@"desc"];
                objNeed.contact=[obj objectForKey:@"contact"];
                objNeed.price=[obj objectForKey:@"price"];
                objNeed.address=[obj objectForKey:@"address"];
                objNeed.array=[obj objectForKey:@"messages"];
                
                objNeed.creatDate=[obj createdAt];
                objNeed.objectID=[obj objectId];
                [IDArray addObject:objNeed.objectID];
                [dataArray addObject:objNeed];
            }
            [self getUserImage];
            
        }else{
            
            NSLog(@"出错");
        }
    }];
    
}

-(void)pushToFirst{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *myCellID=@"myCell";
    GouMyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:myCellID];
    if (!cell) {
        cell=[[GouMyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor colorWithRed:213.0/255 green:222.0/255 blue:169.0/255 alpha:1.0f];
    }else{
        cell.backgroundColor=[UIColor whiteColor];
    }
    needInfoModel *needModel=[[needInfoModel alloc]init];
    needModel=dataArray[indexPath.row];
    
#pragma mark-用户头像
    
    NSLog(@"%lu",(long)imageUrlArray.count);
    
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:imageUrlArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"userDefault"]];
    
    cell.nameLable.text=needModel.goodName;
    cell.nickName.text=nickNameArray[indexPath.row];
    cell.content.text=needModel.desc;
    cell.priceLable.text=[NSString  stringWithFormat:@"￥%@",needModel.price];
    cell.campusName.text=addressArray[indexPath.row];
    [cell.contact  addTarget:self action:@selector(contactInfo:) forControlEvents:UIControlEventTouchUpInside];
    cell.contact.tag=200+indexPath.row;
    [teleArray addObject:needModel.contact];
    [objectIDArray addObject:needModel.objectID];
    cell.leaveMessage.tag=300+indexPath.row;
    
    [cell.leaveMessage setTitle:[NSString stringWithFormat:@"留言(%ld)",(unsigned long)needModel.array.count] forState:UIControlStateNormal];
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

-(void)creatThread{
    
    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(initTableView) object:nil];
    
    [NSThread sleepForTimeInterval:2];
    [thread start];
    
}


-(void)getUserImage{
    
    BmobQuery *query=[BmobQuery queryWithClassName:@"userNeedData"];
    [query includeKey:@"userId"];
    for (int i=0; i<IDArray.count; i++) {
        
        [query getObjectInBackgroundWithId:IDArray[i] block:^(BmobObject *object, NSError *error) {
            
            if (!error) {
                BmobObject *userInfo=[object objectForKey:@"userId"];
                
                [imageUrlArray addObject:[userInfo objectForKey:@"headImageUrl"]];
                [nickNameArray addObject:[userInfo objectForKey:@"nickname"]];
                [addressArray addObject:[userInfo objectForKey:@"address"]];
                NSLog(@"%@",[userInfo objectForKey:@"nickname"]);
                NSLog(@"userId:%@",[userInfo objectId]);
                
            }
            if (i == IDArray.count-1) {
                if (nickNameArray.count != 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (myTableView) {
                            [myTableView reloadData];
                        }else{
                            [self initTableView];
                        }
                    });
                }
            }
        }];
        
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

-(void)popLeavemessage:(UIButton *)sender
{
    int a=(int)sender.tag-300;
    NSString *objID=objectIDArray[a];
    LeaveMessageViewController  *leaveMessage=[[LeaveMessageViewController alloc]init];
    leaveMessage.objectID=objID;
    [self presentViewController:leaveMessage animated:YES completion:nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
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

-(void)pushToNext{
    
    if (myID) {
        NextViewController *next=[[NextViewController alloc]init];
        
        [self presentViewController:next animated:YES completion:nil];
    }else{
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请到个人中心登录您的帐号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
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
