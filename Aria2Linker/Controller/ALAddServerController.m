//
//  ALAddServerController.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/16.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALAddServerController.h"
#import "ALTextField.h"
#import "UIButton+Bootstrap.h"
#import "ALJsonrpcServer.h"
#import "APIUtils.h"

@interface ALAddServerController ()

@property (nonatomic, strong) UITextField *serverName, *serverAddress, *serverPassword;

@end

@implementation ALAddServerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加服务器";
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)];
    nameLabel.text = @"Aria2 RPC 别名";
    nameLabel.font = [UIFont systemFontOfSize:ymFontSizeNormal];
    [self.view addSubview:nameLabel];
    [nameLabel sizeToFit];
    
    _serverName = [[ALTextField alloc] initWithFrame:CGRectMake(nameLabel.right + 10, 4, self.view.width - 40 - nameLabel.width, 36)];
    _serverName.placeholder = @"请输入服务别名";
    _serverName.font = [UIFont systemFontOfSize:ymFontSizeNormal];
    [self.view addSubview:_serverName];
    nameLabel.centerY = _serverName.centerY;
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _serverName.bottom + 10, 120, 44)];
    addressLabel.text = @"Aria2 RPC 地址";
    addressLabel.font = [UIFont systemFontOfSize:ymFontSizeNormal];
    [self.view addSubview:addressLabel];
    
    _serverAddress = [[ALTextField alloc] initWithFrame:CGRectMake(nameLabel.right + 10, _serverName.bottom + 10 + 4, _serverName.width, 36)];
    _serverAddress.placeholder = @"请输入服务地址";
    _serverAddress.font = [UIFont systemFontOfSize:ymFontSizeNormal];
    [self.view addSubview:_serverAddress];
    
    NSString *str = [[UIPasteboard generalPasteboard] string];
    _serverAddress.text = ![CommonUtils stringIsNull:str] && [str hasPrefix:@"http://"] ? str :  @"http://";
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _serverAddress.bottom + 10, 120, 44)];
    passwordLabel.text = @"Aria2 RPC 秘钥";
    passwordLabel.font = [UIFont systemFontOfSize:ymFontSizeNormal];
    [self.view addSubview:passwordLabel];
    
    _serverPassword = [[ALTextField alloc] initWithFrame:CGRectMake(nameLabel.right + 10,_serverAddress.bottom + 10 + 4, _serverName.width, 36)];
    _serverPassword.placeholder = @"请输入服务秘钥";
    _serverPassword.font = [UIFont systemFontOfSize:ymFontSizeNormal];
    [self.view addSubview:_serverPassword];
    
    
    UIButton *button = [UIButton buttonWithStyle:StrapDangerStyle andTitle:@"添加服务端" andFrame:CGRectMake(18, _serverPassword.bottom + 20, ymScreen_Width - 18 * 2, 45) target:self action:@selector(buttonAction:)];
    [self.view addSubview:button];
    
    [_serverName becomeFirstResponder];
}

- (void)buttonAction:(id)sender
{
    ALJsonrpcServer *jrs = [ALJsonrpcServer new];
    jrs.name = self.serverName.text.length ? self.serverName.text : @"NO NAME";
    jrs.uri = self.serverAddress.text;
    if (!jrs.uri.length) {
        [MsgUtils showMsg:@"URI 不能为空"];
    }
    jrs.secret = self.serverPassword.text;
    [APIUtils getVersion:jrs.uri rpcPasswd:jrs.secret success:^(Version *version) {
        if ([self.delegate respondsToSelector:@selector(addServerController:successfullyAddedServer:)]) {
            [self.delegate addServerController:self successfullyAddedServer:jrs];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }failure:^(NSString *msg) {
        [MsgUtils showMsg:@"无法连接到服务器,请检查 地址或秘钥是否正确"];
    }];
}


@end
