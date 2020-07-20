//
//  ALPrivacyController.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/20.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALPrivacyController.h"
#import <WebKit/WKWebView.h>

@interface ALPrivacyController ()

@end

@implementation ALPrivacyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"隐私协议";
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.bottom)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://188.131.178.60/privacy.html"]]];
    [self.view addSubview:webView];
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
