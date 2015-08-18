//
//  ShowTableView.h
//  校园淘金
//
//  Created by zhangfei on 15/5/15.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
-(id)initWithDataArray:(NSArray *)dataArray;
- (void)reloadTableViewData:(NSArray *)array;
@end
