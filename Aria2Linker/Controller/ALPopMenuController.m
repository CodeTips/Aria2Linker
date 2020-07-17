//
//  ALPopMenuController.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/16.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALPopMenuController.h"
#import "ALPopMenuItem.h"

static NSString *kALPopMenuItemCell = @"ALPopMenuItemCell";

@interface ALPopMenuItemCell : UITableViewCell

@end

@implementation ALPopMenuItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    return self;
}

@end

@interface ALPopMenuController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ALPopMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, self.preferredContentSize.width, self.preferredContentSize.height);
        if (@available(iOS 13.0, *)) {
            frame = CGRectMake(0, 13, self.preferredContentSize.width, self.preferredContentSize.height);
        }
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [_tableView registerClass:[ALPopMenuItemCell class] forCellReuseIdentifier:kALPopMenuItemCell];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;

    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ALPopMenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kALPopMenuItemCell forIndexPath:indexPath];
    ALPopMenuItem *item = [self.menus objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menus.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        ALPopMenuItem *item = [self.menus objectAtIndex:indexPath.row];
        if ([self.delegate respondsToSelector:@selector(popMenuController:didSelectItem:)]) {
            [self.delegate popMenuController:self didSelectItem:item];
        }
    }];
}

@end
