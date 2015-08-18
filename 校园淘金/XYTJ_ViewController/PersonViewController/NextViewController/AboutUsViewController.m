//
//  AboutUsViewController.m
//  校园淘金
//
//  Created by scjy on 15/5/31.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "AboutUsViewController.h"
#define ScreenWidth self.view.bounds.size.width
#define ScreenHeight self.view.bounds.size.height
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatView];
}

-(void)creatView
{
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-ScreenHeight/16, ScreenHeight/5, ScreenHeight/8,ScreenHeight/8)];
    logo.layer.cornerRadius = 10;
    [logo.layer setMasksToBounds:YES];
    logo.image = [UIImage imageNamed:@"Icon"];
    [self.view addSubview:logo];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-80, CGRectGetMaxY(logo.frame)+5, 160, 15)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithWhite:0.753 alpha:1.000];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"校园淘金：v1.0";
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    UILabel *team = [[UILabel alloc]initWithFrame:CGRectMake(80, ScreenHeight/2+60, 110, 30)];
    team.text = @"研发团队：";
    team.textColor = [UIColor colorWithWhite:0.700 alpha:1.000];
    team.backgroundColor = [UIColor clearColor];
    team.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:team];
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(team.frame), ScreenHeight/2+60, ScreenWidth-120, 30)];
    content.text = @"XYTJ团队";
    content.backgroundColor = [UIColor clearColor];
    content.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:content];
    
    
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
