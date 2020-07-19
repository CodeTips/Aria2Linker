//
//  ALServersController.h
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/17.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ALServersController;
@class ALJsonrpcServer;

@protocol ALServersControllerDelegate <NSObject>

- (void)serversController:(ALServersController *)controller didSelectServer:(ALJsonrpcServer *)server;
- (void)serversController:(ALServersController *)controller didDeleteServer:(ALJsonrpcServer *)server;

@end

@interface ALServersController : BaseViewController

@property (nonatomic, weak) id<ALServersControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
