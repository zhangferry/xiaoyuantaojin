//
//  main.m
//  校园淘金
//
//  Created by zhangfei on 15/4/22.
//  Copyright (c) 2015年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        [Bmob registerWithAppKey:@"e54a8a8b3afac69a1b3b155fac862f85"];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
    }
}
