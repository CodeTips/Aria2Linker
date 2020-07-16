//
//  ALFileDownloadViewCell.h
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/16.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Result.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALFileDownloadViewCell : UITableViewCell

@property (strong, nonatomic) TaskInfo *active;

@end

NS_ASSUME_NONNULL_END
