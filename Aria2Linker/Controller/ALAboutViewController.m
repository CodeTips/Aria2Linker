//
//  ALAboutViewController.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/17.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALAboutViewController.h"
#import "ALPrivacyController.h"

@interface ALAboutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ALAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于";
    self.view.backgroundColor = [UIColor whiteColor];
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    _iconImage.image = [UIImage imageNamed:@"launch_icon"];
    _iconImage.layer.cornerRadius = 12;
    _iconImage.clipsToBounds = YES;
    [self.view addSubview:_iconImage];
    _iconImage.centerX = self.view.width / 2;
    _iconImage.top = 110;
    
    _infoLabel = [UILabel new];
    _infoLabel.font = [UIFont systemFontOfSize:ymFontSizeSmaller];
    _infoLabel.textColor = ymColorGrayDark;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *versionString = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _infoLabel.text = [NSString stringWithFormat:@"%@ V%@",NSLocalizedString(@"艾琳", nil),versionString];
    [_infoLabel sizeToFit];
    _infoLabel.centerX = _iconImage.centerX;
    _infoLabel.top = _iconImage.bottom + 15;
    [self.view addSubview:_infoLabel];
    
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _infoLabel.bottom + 10, self.view.width, self.view.height - _infoLabel.bottom - 10) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier" forIndexPath:indexPath];
    cell.textLabel.text = @"隐私协议";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ALPrivacyController *privacy = [ALPrivacyController new];
    [self.navigationController pushViewController:privacy animated:YES];
}

@end
