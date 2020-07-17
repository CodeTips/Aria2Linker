//
//  BaseViewController.h
//  huigongyou-project
//
//  Created by ss on 2016/9/28.
//  Copyright © 2016年 zj14. All rights reserved.
//

#ifndef BaseViewController_h
#define BaseViewController_h
#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL hiddenRightBarButtonItem;
- (void)showDefaultViewWithMessage:(NSString *)message;
- (void)hiddenDefaultView;

@end

#endif /* BaseViewController_h */
