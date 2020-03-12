//
//  ViewController.m
//  VHYunSDKDemo_IM
//
//  Created by vhall on 2019/7/19.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+vhall.h"
#import <VHIM/VHImSDK.h>
#import "IMViewController.h"



#define VHScreenHeight          ([UIScreen mainScreen].bounds.size.height)
#define VHScreenWidth           ([UIScreen mainScreen].bounds.size.width)
#define VH_SH                   ((VHScreenWidth<VHScreenHeight) ? VHScreenHeight : VHScreenWidth)
#define VH_SW                   ((VHScreenWidth<VHScreenHeight) ? VHScreenWidth  : VHScreenHeight)


@interface ViewController ()
{
    UITextField *_businessIDTextField;
    UITextField *_accessTokenTextField;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSDKView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showInitSDKVC];
}
- (void)nextPage:(UIButton*)btn
{
    if(_businessIDTextField.text.length == 0 || _accessTokenTextField.text.length == 0)
    {
        [self showMsg:@"参数不能为空" afterDelay:1.5];
        return;
    }

    DEMO_Setting.imChannelID = _businessIDTextField.text;
    DEMO_Setting.accessToken = _accessTokenTextField.text;
    
    IMViewController * vc = [[IMViewController alloc] init];
    vc.channelID    = DEMO_Setting.imChannelID;
    vc.accessToken  = DEMO_Setting.accessToken;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)initSDKView
{
    
    UITextField *businessIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, VHScreenWidth-40, 30)];
    businessIDTextField.placeholder = @"请输入channelID ch_xxxx";
    businessIDTextField.text = DEMO_Setting.imChannelID;
    businessIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    businessIDTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    businessIDTextField.delegate  = self;
    _businessIDTextField = businessIDTextField;
    
    [self.view addSubview:businessIDTextField];
    
    UITextField *accessTokenTextField = [[UITextField alloc] initWithFrame:CGRectMake(businessIDTextField.left, businessIDTextField.bottom+10, businessIDTextField.width, businessIDTextField.height)];
    accessTokenTextField.placeholder = @"请输入 accessToken";
    accessTokenTextField.text = DEMO_Setting.accessToken;
    accessTokenTextField.borderStyle = UITextBorderStyleRoundedRect;
    accessTokenTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    accessTokenTextField.delegate  = self;
    _accessTokenTextField = accessTokenTextField;
    [self.view addSubview:accessTokenTextField];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(accessTokenTextField.left, accessTokenTextField.bottom+10, accessTokenTextField.width, accessTokenTextField.height)];
    [nextBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:nextBtn];
    
    UILabel * label= [[UILabel alloc] initWithFrame:CGRectMake(0, VHScreenHeight - 100, VHScreenWidth, 20)];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.text = [NSString stringWithFormat:@"微吼云 IM SDK v%@",[VHImSDK getSDKVersion]];
    [self.view addSubview:label];
}


@end
