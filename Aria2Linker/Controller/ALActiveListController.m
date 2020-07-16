//
//  ALActiveListController.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/16.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALActiveListController.h"

@interface ALActiveListController ()

@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation ALActiveListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPopMenu:)];
    
    
}

- (void)showPopMenu:(id)sender
{
    
}


@end
