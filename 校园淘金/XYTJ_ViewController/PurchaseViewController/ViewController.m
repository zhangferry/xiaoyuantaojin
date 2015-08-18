//
//  ViewController.m
//  校园淘金
//
//  Created by zhangfei on 15/4/22.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewCell.h"
#import "PurchaseViewController.h"
#import "SearchViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobQuery.h>
#import "JSDropDownMenu.h"
#import "purchaseModel.h"
#import "ShowTableView.h"


@interface ViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate>
{
    
    ShowTableView *myTableView;
    float width;
    UIScrollView *myScroll;
    UIPageControl *pageControl;
    NSDictionary *dataDic;
    NSMutableDictionary *plistDic;
    int curPage;
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    NSMutableArray *dataArray;
    NSMutableArray *dataAdd;
    
    BmobQuery *bquery1;
    BmobQuery *bquery2;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initData];
    //[self initNetWorkData:bquery1];
    [self initView];
    
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",[path lastObject]);//沙河目录
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    //[self initData];
    [self initNetWorkData:bquery1];
    
}

#pragma mark-加载数据
-(void)initData{
    
    width=self.view.frame.size.width;
    bquery1=[BmobQuery queryWithClassName:@"purchaseData"];
    [bquery1 orderByDescending:@"publishDate"];
}
-(void)initNetWorkData:(BmobQuery *)bquery{
    
    bquery.limit=100;
    
    dataArray=[NSMutableArray array];
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
           
            [dataArray addObject:objPurchase];
           
            
        }
       
        [myTableView reloadData];
        [self performSelectorOnMainThread:@selector(initTableView) withObject:nil waitUntilDone:YES];//主线程加载UI视图
        
    }];
    
}

#pragma mark-下拉菜单
-(void)dropDownMenu{
    NSArray *type = @[@"全部", @"手机", @"二手书", @"笔记本", @"自行车",@"其他"];
   
    _data1 = [NSMutableArray arrayWithObjects:@{@"title":@"类型", @"data":type}, nil];
    //_data1 = [NSMutableArray arrayWithObjects:@"类型", @"手机", @"二手书", @"笔记本", @"自行车",  nil];
    _data2 = [NSMutableArray arrayWithObjects:@"发布最近",  @"价格最低",   nil];
    
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 55) andHeight:30];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    
    [self.view addSubview:menu];
    
}
#pragma mark-加载视图
-(void)initView
{
    
    [self dropDownMenu];
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    viewTop.backgroundColor=[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:viewTop];
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, width, 35)];
    headView.backgroundColor=[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    
    [self.view addSubview:headView];
    
    UILabel *schoolName=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 150, 35)];
    schoolName.text=@"河南科技大学";
    schoolName.textColor=[UIColor whiteColor];
    [self.view addSubview:schoolName];
    
    UIButton *buttonSearch=[UIButton buttonWithType:UIButtonTypeCustom];
    //[buttonSearch setTitle:@"搜索" forState:UIControlStateNormal];
    [buttonSearch setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    buttonSearch.frame=CGRectMake(width-30, 20, 35, 35);
    [buttonSearch addTarget:self action:@selector(Search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSearch];
    
    self.view.backgroundColor=[UIColor whiteColor];
#pragma mark-tableview
    
    myScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 80, width, width/3)];
    //myScroll.backgroundColor=[UIColor grayColor];
    myScroll.contentSize=CGSizeMake(width*3, 0);
    myScroll.pagingEnabled=YES;
    myScroll.delegate=self;
    myScroll.bounces=NO;
    myScroll.showsHorizontalScrollIndicator=NO;
    [myScroll setScrollEnabled:YES];
    CGPoint newOffset=myScroll.contentOffset;
    [myScroll setContentOffset:newOffset animated:YES];
    [self.view addSubview:myScroll];

    NSArray *array=@[@"1.jpg",@"2.jpg",@"3.jpg"];
    for (int i=0; i<3; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(width*i, 0, width, CGRectGetHeight(myScroll.frame))];
        imageView.image=[UIImage imageNamed:array[i]];
        [myScroll addSubview:imageView];
    }
    
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(myScroll.frame)-20, width, 20)];
    
    pageControl.numberOfPages=3;
    [pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    pageControl.pageIndicatorTintColor=[UIColor brownColor];
    pageControl.currentPageIndicatorTintColor=[UIColor orangeColor];
    [self.view addSubview:pageControl];
    
    NSTimer *timer1=[NSTimer timerWithTimeInterval:2 target:self selector:@selector(changePage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:timer1 forMode:NSDefaultRunLoopMode];
    
}
-(void)initTableView{
    
    myTableView=[[ShowTableView alloc]initWithDataArray:dataArray];
    myTableView.frame=CGRectMake(0, CGRectGetMaxY(myScroll.frame), width, self.view.frame.size.height-CGRectGetMaxY(myScroll.frame)-50);
    myTableView.delegate=self;
    [self.view addSubview:myTableView];
    [myTableView reloadTableViewData:dataArray];
    
}

#pragma mark-视图滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page=myScroll.contentOffset.x/width;
    pageControl.currentPage=page;
    
}

-(void)changePage{
    if (curPage==3) {
        curPage=0;
    }
    [UIView animateWithDuration:0.5 animations:^{
        myScroll.contentOffset=CGPointMake(width*curPage, 0);
    }];
    pageControl.currentPage=curPage;
    curPage++;
}
#pragma mark-搜索功能
-(void)Search{
    
    SearchViewController *search=[[SearchViewController alloc]init];
    [self presentViewController:search animated:YES completion:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return width/3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PurchaseViewController *purch=[[PurchaseViewController alloc]init];
    //purchaseModel *puModel=[[purchaseModel alloc]init];
    purchaseModel *puModel=dataArray[indexPath.row];
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

#pragma mark-下拉菜单代理
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 2;
}
-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    if (column==2) {
        return YES;
    }
    return NO;
}
-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column==0) {
        return YES;
    }
    return NO;
}
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==0) {
        return 0.3;
    }
    return 1;
}
-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        return _currentData1Index;
    }
    if (column==1) {
        return _currentData2Index;
    }
    return 0;
}
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (column==0) {
        if (leftOrRight==0) {
            
            return _data1.count;
        } else{
            
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    } else if (column==1){
        
        return _data2.count;
        
    } else if (column==2){
        
        return _data3.count;
    }
    return 0;
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return [[_data1[0] objectForKey:@"data"] objectAtIndex:0];
            break;
        case 1: return _data2[0];
            break;
        case 2: return _data3[0];
            break;
        default:
            return nil;
            break;
    }
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    } else if (indexPath.column==1) {
        
        return _data2[indexPath.row];
        
    } else {
        
        return _data3[indexPath.row];
    }
}
#pragma mark-排序
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column == 0) {
        if(indexPath.leftOrRight==0){
            _currentData1Index = indexPath.row;
            
            return;
        }else{
            
            NSDictionary *menuDic1 = [_data1 objectAtIndex:indexPath.leftRow];
            NSString *goodType=[[menuDic1 objectForKey:@"data"] objectAtIndex:indexPath.row];
            dataAdd=[NSMutableArray array];
            
#pragma mark -谓词查询
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"goodType CONTAINS[cd] %@",goodType];
            
            NSArray *filterdArray=[dataArray filteredArrayUsingPredicate:predicate];
            
            [dataAdd addObjectsFromArray:filterdArray];
            
            if ([goodType isEqualToString:@"全部"]) {
                
                [myTableView reloadTableViewData:dataArray];
            }else{
            
            [myTableView reloadTableViewData:dataAdd];
            }
        }
    } else if(indexPath.column == 1){

        switch (indexPath.row) {
            case 0:
                bquery2=[BmobQuery queryWithClassName:@"purchaseData"];
                [bquery2 orderByDescending:@"publishDate"];
                [self initNetWorkData:bquery2];
                
                break;
            case 1:
                bquery2=[BmobQuery queryWithClassName:@"purchaseData"];
                [bquery2 orderByAscending:@"goodPrice"];
                [self initNetWorkData:bquery2];
                
                break;
//            case 2:
//                bquery2=[BmobQuery queryWithClassName:@"purchaseData"];
//                [bquery2 orderByAscending:@"goodPrice"];//价格升序
//                [self initNetWorkData:bquery2];
//                
//                break;
            
                
            default:
                break;
        }
        
        _currentData2Index = indexPath.row;
        
    } else{
        
        _currentData3Index = indexPath.row;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
