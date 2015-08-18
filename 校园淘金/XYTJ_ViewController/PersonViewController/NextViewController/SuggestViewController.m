//
//  SuggestViewController.m
//  校园淘金--new
//
//  Created by scjy on 15/5/2.
//  Copyright (c) 2015年 刘孝勇. All rights reserved.
//

#import "SuggestViewController.h"
#define ScreenWidth self.view.bounds.size.width
#define ScreenHeight self.view.bounds.size.height
@interface SuggestViewController ()
{
    UITextView *addOpinion;
}
@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, ScreenHeight/8, ScreenWidth-40, 75)];
    label.text = @"请把您的宝贵意见告诉我们，我们将及时处理相关问题，以便给您提供更好的服务";
    label.font = [UIFont systemFontOfSize:20];
    label.numberOfLines = 3;
    [self.view addSubview:label];
    addOpinion = [[UITextView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame)+20, ScreenWidth-40, ScreenHeight/3)];
    addOpinion.font = [UIFont systemFontOfSize:20];
    addOpinion.layer.borderWidth = 1.0;
    addOpinion.backgroundColor = [UIColor whiteColor];
    addOpinion.delegate = self;
    [self.view addSubview:addOpinion];
    UIButton *provide=[UIButton buttonWithType:UIButtonTypeCustom];
    [provide setTitle:@"提  交" forState:UIControlStateNormal];
    provide.frame=CGRectMake(ScreenWidth/2-100, CGRectGetMaxY(addOpinion.frame)+30, 200, 40);
    provide.backgroundColor=[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    [provide addTarget:self action:@selector(returnTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:provide];
}

-(void)returnTo
{
    
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
