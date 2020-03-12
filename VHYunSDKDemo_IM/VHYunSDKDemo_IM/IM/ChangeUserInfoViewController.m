//
//  ChangeUserInfoViewController.m
//  VHYunSDKDemo_IM
//
//  Created by vhall on 2020/3/6.
//  Copyright © 2020 vhall. All rights reserved.
//

#import "ChangeUserInfoViewController.h"
#import <VHCore/VHLiveBase.h>
#import "VHStystemSetting.h"

@interface ChangeUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *avatarTextField;
@end

@implementation ChangeUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _userIDTextField.text = DEMO_Setting.third_party_user_id;
    _nicknameTextField.text = DEMO_Setting.nickName;
    _avatarTextField.text = DEMO_Setting.avatar;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)updateBtnClicked:(id)sender {
    DEMO_Setting.third_party_user_id =_userIDTextField.text;
    if(DEMO_Setting.third_party_user_id.length<=0)
    {
        [self showMsg:@"用户ID 不能为空" afterDelay:1];
        return;
    }
    DEMO_Setting.nickName = _nicknameTextField.text?_nicknameTextField.text:@"";
    DEMO_Setting.avatar   = _avatarTextField.text?_avatarTextField.text:@"";
    [VHLiveBase setThirdPartyUserId:DEMO_Setting.third_party_user_id context:@{@"nick_name":DEMO_Setting.nickName,@"avatar":DEMO_Setting.avatar}];

    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
