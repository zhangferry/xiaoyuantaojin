//
//  ShowTableView.m
//  校园淘金
//
//  Created by zhangfei on 15/5/15.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "ShowTableView.h"
#import "MyTableViewCell.h"
#import "purchaseModel.h"
#import "PurchaseViewController.h"
#define ScreenWidth self.frame.size.width
@implementation ShowTableView
{
    
    UIImage *imageNoNetwork;
    NSMutableArray *_dataArray;
    
}

-(id)initWithDataArray:(NSMutableArray *)dataArray{
    
    self=[super init];
    if (self) {
        
        self.delegate=self;
        self.dataSource=self;
        self.showsVerticalScrollIndicator=NO;
        self.separatorStyle=UITableViewCellSeparatorStyleNone;

    }
    return self;
    
}

- (void)reloadTableViewData:(NSArray *)array
{
    _dataArray=[NSMutableArray arrayWithArray:array];
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"cell行数：%ld",_dataArray.count);
    return _dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *cellID=@"cellindefiter";
    MyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell=[[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }else{
        
        //cell.image.image=[UIImage imageNamed:@"noNetwork"];
        
    }
    
    purchaseModel *purchModel=_dataArray[indexPath.row];
    
    
    [cell setContentView:purchModel];
    
    return cell;
}


@end
