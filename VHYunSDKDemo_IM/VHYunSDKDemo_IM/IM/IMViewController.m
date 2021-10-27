//
//  IMViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "IMViewController.h"
#import <VHCore/VHLiveBase.h>
#import <VHIM/VHImSDK.h>
#import "UIImageView+WebCache.h"
#import "UserListViewController.h"
#import "ChangeUserInfoViewController.h"

@interface IMViewController ()<VHImSDKDelegate>
{
    
}
@property(nonatomic,strong)VHImSDK * chatSDK;
@property(nonatomic,strong)NSMutableArray *msgArr;
@property (weak, nonatomic) IBOutlet UITextField *msgTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextField *imagemsgTextField;
@property (weak, nonatomic) IBOutlet UILabel *chLabel;
@property (weak, nonatomic) IBOutlet UISwitch *forbiddenAllSwitch;

@end

@implementation IMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _msgArr = [NSMutableArray array];
    
    _chatSDK = [[VHImSDK alloc]initWithChannelID:self.channelID accessToken:self.accessToken delegate:self];
    _chatSDK.delegate = self;
    
    _tableView.rowHeight = 60;
    
    _chLabel.text = _channelID;
    _tableView.tableFooterView = [[UIView alloc]init];
    
    [self loadHistoryMsg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}


- (IBAction)sendBtnClicked:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if(_msgTextField.text.length > 0 )
    {
        __weak typeof(self) wf = self;
        [self showProgressDialog:_sendBtn];
        [_chatSDK sendMessage:_msgTextField.text completed:^(NSError *error) {
             [wf hideProgressDialog:wf.sendBtn];
            if(error)
                [wf showMsg:[NSString stringWithFormat:@"%ld%@",error.code,error.domain] afterDelay:2];
            else
                [wf showMsg:@"发送成功" afterDelay:2];
        }];
    }
}
- (IBAction)sendImageBtnClicked:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if(_imagemsgTextField.text.length > 0 )
    {
        __weak typeof(self) wf = self;
        [self showProgressDialog:self.view];
        [_chatSDK sendMessage:@[_imagemsgTextField.text] type:VHIMMessageTypeImage text:_msgTextField.text audit:YES context:[VHLiveBase getContext] completed:^(NSError *error) {
            [wf hideProgressDialog:wf.view];
            if(error)
                [wf showMsg:[NSString stringWithFormat:@"%ld%@",error.code,error.domain] afterDelay:2];
            else
                [wf showMsg:@"发送成功" afterDelay:2];
        }];
    }
}

- (IBAction)sendCustomBtnClicked:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    NSString *customMessage = @"{\"key\":\"value\",\"key1\":0.12,\"key2\":1,\"key3\":\"汉语\"}";

    __weak typeof(self) wf = self;
    [self showProgressDialog:self.view];
    [_chatSDK sendCustomMessage:customMessage  completed:^(NSError *error) {
        [wf hideProgressDialog:wf.view];
        if(error)
            [wf showMsg:[NSString stringWithFormat:@"%ld%@",error.code,error.domain] afterDelay:2];
        else
            [wf showMsg:@"发送成功" afterDelay:2];
    }];
}

- (IBAction)forbiddenAll:(UISwitch*)sender {
    [_chatSDK forbiddenAll:sender.on completed:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}
//历史消息
- (void)loadHistoryMsg
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSString* endTime=[dateFormat stringFromDate:[NSDate date]];
    
    __weak typeof(self) wf = self;
    [_chatSDK messageListWithPage:1 size:200 startTime:@"2020/03/01" endTime:endTime completed:^(id data, NSError *error) {
        if(data)
        {
            for (NSDictionary *msg in data[@"list"]) {
                VHMessage *message = [[VHMessage alloc]init];
                message.service_type = MSG_Service_Type_IM;
                message.data = @{MSG_Type:msg[MSG_Type],MSG_IM_Text_Content:msg[@"data"],MSG_IM_Image_Urls:msg[@"image_urls"]?msg[@"image_urls"]:@[]};
                message.nick_name = msg[@"nick_name"];
                message.avatar = msg[@"avatar"];
                message.date_time = msg[@"date_time"];
                message.sender_id = msg[@"third_party_user_id"];
                [wf.msgArr addObject:message];
            }
            [wf.tableView reloadData];
        }
    }];
}
- (IBAction)onineBtnClicked:(id)sender {
    UserListViewController *vc = [[UserListViewController alloc]init];
    vc.chatSDK = _chatSDK;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)userBtnClicked:(id)sender {
    ChangeUserInfoViewController *vc = [[ChangeUserInfoViewController alloc]init];
//    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _msgArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static   NSString *Identifier = @"noiseSwitchCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];

    for (int i = 0; i < cell.subviews.count; i++) {
        UIView *imageView = [cell.contentView viewWithTag:1000+i];
        if(imageView)
            [imageView removeFromSuperview];
    }
    
    VHMessage *message = _msgArr[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@[id:%@]%@",message.nick_name?message.nick_name:@"",message.sender_id,message.date_time];
    cell.textLabel.text = str;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    if([message.service_type isEqualToString:MSG_Service_Type_IM])
    {
        if([message.data[MSG_Type] isEqualToString:MSG_IM_Type_Text])
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",message.data[MSG_IM_Text_Content]];
        else if([message.data[MSG_Type] isEqualToString:MSG_IM_Type_Image])
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@",message.data[MSG_IM_Text_Content],message.data[MSG_IM_Image_Urls]];
            
            NSArray* arr = message.data[MSG_IM_Image_Urls];
            for (int i = 0; i<arr.count; i++) {
                UIImageView *imageView = [cell.contentView viewWithTag:1000+i];
                if(!imageView)
                    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 20, 40, 40)];
                imageView.frame = CGRectMake(95+i*42, 17, 40, 40);
                imageView.tag = 1000+i;
                imageView.layer.borderColor = [UIColor greenColor].CGColor;
                imageView.layer.borderWidth = 0.5;
                [imageView sd_setImageWithURL:[NSURL URLWithString:arr[i]]];
                [cell.contentView addSubview:imageView];
            }
        }
        //其他情况可自行处理
    }
    else if([message.service_type isEqualToString:MSG_Service_Type_Customt])
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"【自定义】%@",message.data];
    }
    else if([message.service_type isEqualToString:MSG_Service_Type_Online])
    {
        if([message.data[MSG_Type] isEqualToString:MSG_Online_Join])
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"【上线】pv: %ld uv: %ld ",(long)message.pv,(long)message.uv];
        }
        else if([message.data[MSG_Type] isEqualToString:MSG_Online_Leave])
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"【下线】pv: %ld uv: %ld ",(long)message.pv,(long)message.uv];
        }
    }
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:message.avatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    cell.imageView.contentMode = UIViewContentModeScaleToFill; 
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - VHImSDKDelegate
/**
 *  接收IM消息
 *  @param imSDK IM实例
 *  @param message   IM消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveChatMessage:(VHMessage*)message
{
    if([message.data[MSG_Type] isEqualToString:MSG_IM_Type_Text] || [message.data[MSG_Type] isEqualToString:MSG_IM_Type_Image] )
    {
        [_msgArr insertObject:message atIndex:0];
        [_tableView reloadData];
    }
    else if([message.data[MSG_Type] isEqualToString:MSG_IM_Type_Disable] ||
            [message.data[MSG_Type] isEqualToString:MSG_IM_Type_Permit]  ||
            [message.data[MSG_Type] isEqualToString:MSG_IM_Type_Disable_All] ||
            [message.data[MSG_Type] isEqualToString:MSG_IM_Type_Permit_All])//禁言消息刷新用户列表 包括自己被禁言消息和他人被禁言消息
    {
        UserListViewController *vc = (UserListViewController*)self.presentedViewController;
        if([vc isKindOfClass:[UserListViewController class]])
        {
            [vc updateData];
        }
    }
}

/**
 *  上下线消息
 *  @param imSDK IM实例
 *  @param message   消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveOnlineMessage:(VHMessage*)message
{
    [_msgArr insertObject:message atIndex:0];
    [_tableView reloadData];
    
    UserListViewController *vc = (UserListViewController*)self.presentedViewController;
    if([vc isKindOfClass:[UserListViewController class]])
    {
        [vc updateData];
    }
}

/**
 *  接收自定义消息
 *  @param imSDK IM实例
 *  @param message   自定义消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveCustomMessage:(VHMessage*)message
{
    [_msgArr insertObject:message atIndex:0];
    [_tableView reloadData];
}

- (void)imSDK:(VHImSDK *)imSDK forbidden:(BOOL)forbidden
{
    if(imSDK.forbiddenAll || imSDK.forbidden)
    {
        _msgTextField.text =  @"";
        _msgTextField.placeholder = imSDK.forbiddenAll?@"全体禁言":@"您已被禁言~";
        _msgTextField.enabled = NO;
        _imagemsgTextField.enabled = NO;
        _sendBtn.enabled = NO;
        [self.view endEditing:YES];
    }
    else
    {
        _sendBtn.enabled = YES;
        _msgTextField.placeholder = @"来聊天吧~";
        _msgTextField.enabled = YES;
        _imagemsgTextField.enabled = YES;
    }
}

- (void)imSDK:(VHImSDK *)imSDK forbiddenAll:(BOOL)forbiddenAll
{
    if(imSDK.forbiddenAll || imSDK.forbidden)
    {
        _msgTextField.text =  @"";
        _msgTextField.placeholder = imSDK.forbiddenAll?@"全体禁言":@"您已被禁言~";
        _msgTextField.enabled = NO;
        _imagemsgTextField.enabled = NO;
        _sendBtn.enabled = NO;
        [self.view endEditing:YES];
    }
    else
    {
        _sendBtn.enabled = YES;
        _msgTextField.placeholder = @"来聊天吧~";
        _msgTextField.enabled = YES;
        _imagemsgTextField.enabled = YES;
    }
    
    _forbiddenAllSwitch.on = forbiddenAll;
}
/**
 *  错误回调
 *  @param imSDK IM实例
 *  @param error    错误
 */
- (void)imSDK:(VHImSDK *)imSDK error:(NSError *)error
{
    [self showMsg:[NSString stringWithFormat:@"%ld%@",(long)error.code,error.domain] afterDelay:2];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


@end
