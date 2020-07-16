//
//  ALActiveListController.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/16.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALActiveListController.h"
#import "ALPopMenuController.h"
#import "ALAddServerController.h"
#import "ALPopMenuItem.h"
#import "LocalCacheUtils.h"

@interface ALActiveListController ()<UIPopoverPresentationControllerDelegate,ALPopMenuControllerDelegate,ALAddServerControllerDelegate>


@end

@implementation ALActiveListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPopMenu:)];
}


- (void)showPopMenu:(UIBarButtonItem *)sender
{
    NSMutableArray *menus = [NSMutableArray array];
    if (self.jsonrpcServer) {
        ALPopMenuItem *addFileItem = [ALPopMenuItem new];
        addFileItem.name = @"添加下载";
        addFileItem.actionType = ALPopMenuItemActionAddFile;
        [menus addObject:addFileItem];
        
        ALPopMenuItem *finshItem = [ALPopMenuItem new];
        finshItem.name = @"完成/停止";
        finshItem.actionType = ALPopMenuItemActionStopList;
        [menus addObject:finshItem];
    }
    
    ALPopMenuItem *serverItem = [ALPopMenuItem new];
    serverItem.name = self.jsonrpcServer ? @"服务器" : @"添加服务器";
    serverItem.actionType = self.jsonrpcServer ? ALPopMenuItemActionServers : ALPopMenuItemActionAddServer;
    [menus addObject:serverItem];
    
    ALPopMenuItem *aboutItem = [ALPopMenuItem new];
    aboutItem.name = @"关于";
    aboutItem.actionType = ALPopMenuItemActionStopList;
    [menus addObject:aboutItem];
    
    ALPopMenuController *menuController = [[ALPopMenuController alloc] init];
    menuController.menus = menus;
    menuController.delegate = self;
    menuController.preferredContentSize = CGSizeMake(120, menus.count * 44);
    menuController.modalPresentationStyle = UIModalPresentationPopover;
    menuController.popoverPresentationController.delegate = self;
    menuController.popoverPresentationController.barButtonItem = sender;
    [self presentViewController:menuController animated:YES completion:^{
        
    }];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}

- (void)popMenuController:(ALPopMenuController *)controller didSelectItem:(ALPopMenuItem *)item
{
    switch (item.actionType) {
        case ALPopMenuItemActionAddFile:{
        }
            break;
        case ALPopMenuItemActionAddServer:{
            ALAddServerController *serverController = [ALAddServerController new];
            serverController.delegate = self;
            [self.navigationController pushViewController:serverController animated:YES];
        }
            break;
        case ALPopMenuItemActionServers:{
            
        }
            break;
        case ALPopMenuItemActionStopList:{
            
        }
            break;
        case ALPopMenuItemActionAbout:{
            
        }
            break;
    }
}

- (void)addServerController:(ALAddServerController *)controller successfullyAddedServer:(JsonrpcServer *)server
{
    self.jsonrpcServer = server;
    NSMutableArray *servers = [NSMutableArray new];
    [servers addObject:server];
    [[LocalCacheUtils getInstance] setJsonrpcArray:servers];
}

@end
