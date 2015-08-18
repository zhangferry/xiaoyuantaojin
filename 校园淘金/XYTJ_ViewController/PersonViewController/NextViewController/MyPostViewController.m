//
//  MyPostViewController.m
//  校园淘金--new
//
//  Created by scjy on 15/4/30.
//  Copyright (c) 2015年 刘孝勇. All rights reserved.
//

#import "MyPostViewController.h"
#import "ShowTableView.h"
#import <BmobSDK/Bmob.h>
#import "purchaseModel.h"
#import "PurchaseViewController.h"
#import "MyTableViewCell.h"
#define ScreenWidth self.view.bounds.size.width
#define ScreenHeight self.view.bounds.size.height
@interface MyPostViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSString *acc;
    NSMutableArray *postArray;
    UITableView *myTableView;
    NSString *myID;

}
@end

@implementation MyPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMyID];
    self.title=@"我的发布";
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
#pragma mark-数据查询
    BmobQuery *bquery=[BmobQuery queryWithClassName:@"purchaseData"];
    
    [bquery whereKey:@"userId" equalTo:myID];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *obj in array) {
            
            purchaseModel *objPurchase=[[purchaseModel alloc]init];
            objPurchase.imageUrl=[obj objectForKey:@"imageUrl"];
            objPurchase.goodTitle=[obj objectForKey:@"goodTitle"];
            objPurchase.goodDesc=[obj objectForKey:@"goodDesc"];
            objPurchase.goodPrice=[NSString stringWithFormat:@"￥%@",[obj objectForKey:@"goodPrice"]];
            objPurchase.sendAddress=[obj objectForKey:@"sendAddress"];
            objPurchase.goodType=[obj objectForKey:@"goodType"];
            objPurchase.userPhone=[obj objectForKey:@"userPhone"];
            objPurchase.userQQ=[obj objectForKey:@"userQQ"];
            objPurchase.publishDate=[obj objectForKey:@"publishDate"];
            objPurchase.goodID=[obj objectId];
            [postArray addObject:objPurchase];
            
        }
        [myTableView reloadData];
    }];
    
}

-(void)initLayout{
    
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBook)];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];

    self.navigationItem.leftBarButtonItem=left;
    self.navigationItem.rightBarButtonItem=right;

    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-100) style:UITableViewStylePlain];
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    myTableView.delegate=self;
    myTableView.dataSource=self;
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
    MyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell=[[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    purchaseModel *purchase=postArray[indexPath.row];
    [cell setContentView:purchase];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //[postArray removeObjectAtIndex:indexPath.row];
        NSLog(@"删除");
        purchaseModel *pModel=postArray[indexPath.row];
        BmobObject *bmobject=[BmobObject objectWithoutDatatWithClassName:@"purchaseData" objectId:pModel.goodID];
        //NSString *string=pModel.goodID;
        [bmobject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                
                NSLog(@"删除成功");
                [self initNetWorkData];
            }else{
                
                NSLog(@"删除失败");
            }
            
        }];
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[myTableView reloadData];
        
    }else{
        
        NSLog(@"没有选择");
        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;//编辑状态，删除
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenWidth/3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return postArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PurchaseViewController *purch=[[PurchaseViewController alloc]init];
    
    purchaseModel *puModel=postArray[indexPath.row];
    NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:puModel.imageUrl]];
    purch.image=[UIImage imageWithData:imageData];
    purch.name=puModel.goodTitle;
    purch.desc=puModel.goodDesc;
    purch.price=puModel.goodPrice;
    purch.address=puModel.sendAddress;
    purch.goodID=puModel.goodID;
    purch.userPhone=puModel.userPhone;
    purch.userQQ=puModel.userQQ;
    
    [self presentViewController:purch animated:YES completion:nil];
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
