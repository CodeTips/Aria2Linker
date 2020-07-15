//
//  ButtonCell.h
//  huigongyou-project
//
//  Created by zj14 on 2017/4/6.
//  Copyright © 2017年 ss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Bootstrap.h"

#define ButtonCellText @"ButtonCellText"
@interface ButtonCell : UITableViewCell
@property (strong, nonatomic) void (^clickEvent)(void);
- (id)initWithBtnStyle:(StrapButtonStyle)style title:(NSString *)title clickEvent:(void (^)(void))clickEvent;
@end
