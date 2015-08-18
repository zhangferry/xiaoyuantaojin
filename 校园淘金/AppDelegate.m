//
//  AppDelegate.m
//  校园淘金
//
//  Created by zhangfei on 15/4/22.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PublishViewController.h"
#import "XYTJ_PersonalViewController.h"
#import "PurchaseViewController.h"
#import "GouViewController.h"

#import <BmobSDK/Bmob.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)initializaPlat{
    
    //添加新浪微博应用
    
    [ShareSDK
     connectSinaWeiboWithAppKey:@"3201194191"
     
     appSecret:@"0334252914651e8f76bad63337b3b78f"
     
     redirectUri:@"http://appgo.cn"];
    
    //添加腾讯微博应用
    
    [ShareSDK
     connectTencentWeiboWithAppKey:@"801307650"

     appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"

     redirectUri:@"http://www.sharesdk.cn" wbApiCls:[WeiboApi class]];


    //添加QQ空间应用

    [ShareSDK
     connectQZoneWithAppKey:@"100371282" appSecret:@"aed9b0303e3ed1e27bae87c33761161d" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];

    
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    [ShareSDK registerApp:@"77c6592e1a5c"];
    [self initializaPlat];
    
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor=[UIColor whiteColor];
    
    
    ViewController *vc=[[ViewController alloc]init];
    self.window.rootViewController=vc;
    
    XYTJ_PersonalViewController *person=[[XYTJ_PersonalViewController alloc]init];
    PublishViewController *publish=[[PublishViewController alloc]init];
    //ChangeViewController *publish=[[ChangeViewController alloc]init];
    
    GouViewController *gou=[[GouViewController alloc]init];
   
    UINavigationController *nPerson=[[UINavigationController alloc]initWithRootViewController:person];
    
    NSArray *vcList=@[vc,publish,gou,nPerson];
    
    UITabBarController *tabBarTao=[[UITabBarController alloc]init];
    
    tabBarTao.selectedIndex=0;
    tabBarTao.viewControllers=vcList;
    //设置tabBar文字
    UITabBarItem *item1=(UITabBarItem *)tabBarTao.tabBar.items[0];
    item1.title=@"选购";
    item1.image=[UIImage imageNamed:@"home"];
    
    UITabBarItem *item2=(UITabBarItem *)tabBarTao.tabBar.items[1];
    item2.title=@"发布";
    item2.image=[UIImage imageNamed:@"add"];
    
    UITabBarItem *item3=(UITabBarItem *)tabBarTao.tabBar.items[2];
    item3.title=@"求购";
    item3.image=[UIImage imageNamed:@"shopping"];
    
    UITabBarItem *item4=(UITabBarItem *)tabBarTao.tabBar.items[3];
    item4.title=@"个人信息";
    item4.image=[UIImage imageNamed:@"user"];
    [tabBarTao.tabBarItem setTitle:@"校园淘金"];
    
    self.window.rootViewController=tabBarTao;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
