//
//  BaseViewController.m
//  huigongyou-project
//
//  Created by ss on 2016/9/28.
//  Copyright © 2016年 zj14. All rights reserved.
//

#import "BaseViewController.h"

@interface ALDefaultView : UIView

@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation ALDefaultView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.text = self.message;
    self.imageView.center = CGPointMake(self.width / 2, self.height / 2 - 100);
    [self.label sizeToFit];
    self.label.top = self.imageView.bottom + 20;
    self.label.centerX = self.imageView.centerX;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
        _imageView.image = [UIImage imageNamed:@"zanwufuwu"];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = ymNavBackgroundColor;
        [self addSubview:_label];
    }
    return _label;
}


@end


@interface BaseViewController ()

@property (nonatomic,strong) ALDefaultView *defaultView;

@end


@implementation BaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 定义状态栏样式,背景为有色,内容为白色
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 背景色为白色
    self.view.backgroundColor = ymBackgroudColor;

    // 通知nav,设置状态栏样式
    [self setNeedsStatusBarAppearanceUpdate];
    //  设置背景颜色
    self.navigationController.navigationBar.barTintColor = ymNavBackgroundColor;
    // 导航栏上按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //  navbar上加入返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [self backButton];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }

    self.navigationController.navigationBar.translucent = NO;
    // 修复navigationController侧滑关闭失效的问题
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    // 设置字体的颜色和大小,比如title
    NSDictionary *textAttrbutes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:ymFontSizeBigger]
    };
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrbutes];

}

- (void)setHiddenRightBarButtonItem:(BOOL)hiddenRightBarButtonItem
{
    _hiddenRightBarButtonItem = hiddenRightBarButtonItem;
    if (hiddenRightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPopMenu:)];
    }
}

- (void)showPopMenu:(UIBarButtonItem *)sender
{
    
}

- (void)showDefaultViewWithMessage:(NSString *)message
{
    [self.view bringSubviewToFront:self.defaultView];
    self.defaultView.message = message;
    self.defaultView.hidden = NO;
}

- (void)hiddenDefaultView
{
    self.defaultView.hidden = YES;
}

- (ALDefaultView *)defaultView
{
    if (!_defaultView) {
        _defaultView = [[ALDefaultView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_defaultView];
    }
    return _defaultView;
}

- (UIBarButtonItem *)backButton {
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    return backBarButtonItem;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
