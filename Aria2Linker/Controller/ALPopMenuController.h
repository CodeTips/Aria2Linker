//
//  ALPopMenuController.h
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/16.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ALPopMenuController;
@class ALPopMenuItem;

@protocol ALPopMenuControllerDelegate <NSObject>

- (void)popMenuController:(ALPopMenuController *)controller didSelectItem:(ALPopMenuItem *)item;

@end

@interface ALPopMenuController : UIViewController

@property (nonatomic, weak) id<ALPopMenuControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *menus;

@end

NS_ASSUME_NONNULL_END
