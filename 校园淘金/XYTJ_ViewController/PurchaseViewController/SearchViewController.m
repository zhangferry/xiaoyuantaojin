//
//  SearchViewController.m
//  校园淘金
//
//  Created by zhangfei on 15/4/24.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "SearchViewController.h"
#import "ShowTableView.h"
#import "purchaseModel.h"
#import "PurchaseViewController.h"
#import <BmobSDK/Bmob.h>
@interface SearchViewController ()

{
    UISearchBar *mySearchBar;
    ShowTableView *myTableView;
    NSString *searchKeyWord;
    float width;
    BmobQuery *bquery;
    NSMutableArray *dataArray;
    
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initNetWorkData];
    [self initView];
   
    
}

-(void)initNetWorkData{
    
    width=self.view.frame.size.width;
    if (searchKeyWord.length==0) {
        //----空操作
    }else{
    
    bquery=[BmobQuery queryWithClassName:@"purchaseData"];
    
    [bquery whereKey:@"goodTitle" matchesWithRegex:searchKeyWord];
    dataArray=[NSMutableArray array];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *obj in array) {
            purchaseModel *objPurchase=[[purchaseModel alloc]init];
            objPurchase.imageUrl=[obj objectForKey:@"imageUrl"];
            objPurchase.goodTitle=[obj objectForKey:@"goodTitle"];
            objPurchase.goodDesc=[obj objectForKey:@"goodDesc"];
            objPurchase.goodPrice=[NSString stringWithFormat:@"￥%@",[obj objectForKey:@"goodPrice"]];
            objPurchase.sendAddress=[obj objectForKey:@"sendAddress"];
            objPurchase.userPhone=[obj objectForKey:@"userPhone"];
            objPurchase.userQQ=[obj objectForKey:@"userQQ"];
            objPurchase.publishDate=[obj objectForKey:@"publishDate"];
            [dataArray addObject:objPurchase];
        }
        
        [myTableView reloadTableViewData:dataArray];
        
    }];
    }
}
-(void)initView{
    

    mySearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(30, 20, width-60, 30)];
    mySearchBar.delegate=self;
    
    [self.view addSubview:mySearchBar];
    
    UIButton *buttonSearch=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonSearch setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    buttonSearch.frame=CGRectMake(CGRectGetMaxX(mySearchBar.frame), 20, 30, 30);
    [buttonSearch addTarget:self action:@selector(Search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSearch];
    
    UIButton *returnSearch=[UIButton buttonWithType:UIButtonTypeCustom];
    [returnSearch setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    returnSearch.alpha=0.3;
    returnSearch.frame=CGRectMake(0, 20, 30, 30);
    [returnSearch addTarget:self action:@selector(Return) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnSearch];
    
    myTableView=[[ShowTableView alloc]initWithDataArray:dataArray];
    myTableView.frame=CGRectMake(0, CGRectGetMaxY(mySearchBar.frame), width, self.view.frame.size.height-CGRectGetHeight(mySearchBar.frame));
    myTableView.delegate=self;
    [self.view addSubview:myTableView];
   
}

-(void)Search{
    

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return width/3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PurchaseViewController *purch=[[PurchaseViewController alloc]init];
    purchaseModel *puModel=dataArray[indexPath.row];
    NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:puModel.imageUrl]];
    purch.image=[UIImage imageWithData:imageData];
    purch.name=puModel.goodTitle;
    purch.desc=puModel.goodDesc;
    purch.price=puModel.goodPrice;
    
    [self presentViewController:purch animated:YES completion:nil];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchKeyWord=searchBar.text;
    bquery=[BmobQuery queryWithClassName:@"purchaseData"];
    [bquery whereKey:@"goodType" matchesWithRegex:searchKeyWord];
    [self initNetWorkData];
    [myTableView reloadData];
    [searchBar resignFirstResponder];
    
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    return YES;
}
-(void)Return{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
