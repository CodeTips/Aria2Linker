//
//  BaseNavigationController.m
//  Coding_iOS
//
//  Created by Ease on 15/2/5.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIColor+expanded.h"

@interface BaseNavigationController ()
@property (strong, nonatomic) UIView *navLineV;
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

/**
 * 允许子VC设置状态栏样式
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

@end
