//
//  AppDelegate.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/5/18.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "AppDelegate.h"
#import <HolmesWithIDFA/Holmes.h>
#import "ALActiveListController.h"
#import "BaseNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    ALActiveListController *vc = [[ALActiveListController alloc] init];
    UINavigationController *navOverView = [[BaseNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navOverView;
    [self.window makeKeyAndVisible];
    
    [Holmes init:@{@"appkey": @"appkey", @"channel" : @"AppleStore"}];

    return YES;
}

@end
