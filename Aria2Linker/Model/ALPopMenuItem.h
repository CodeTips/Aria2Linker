//
//  ALPopMenuItem.h
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/16.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ALPopMenuItemActionType) {
    ALPopMenuItemActionAddFile,
    ALPopMenuItemActionAddServer,
    ALPopMenuItemActionServers,
    ALPopMenuItemActionStopList,
    ALPopMenuItemActionAbout,
};

@interface ALPopMenuItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) ALPopMenuItemActionType actionType;

@end

NS_ASSUME_NONNULL_END
