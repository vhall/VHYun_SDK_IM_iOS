//
//  UserListViewController.m
//  VHYunSDKDemo_IM
//
//  Created by vhall on 2019/8/26.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "UserListViewController.h"
#import "UIImageView+WebCache.h"

@interface UserItem:NSObject
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)NSString *nick_name;
@property(nonatomic,assign)BOOL     forbidden;
@property(nonatomic,assign)BOOL     online;
@end

@implementation UserItem
- (instancetype)init{
    if (self = [super init]) {
        _online = YES;
    }
    return self;
}
@end

@interface MyButton:UIButton
@property(nonatomic,strong)NSString *userId;
@end

@implementation MyButton
@end





@interface UserListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property(nonatomic,strong)NSMutableArray *userArr;
@property(nonatomic,strong)NSMutableArray *forbiddenArr;
@property(nonatomic,strong)UILabel *headLabel ;
@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _userArr        = [NSMutableArray array];
    _forbiddenArr   = [NSMutableArray array];
    
    _headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    _headLabel.textAlignment = NSTextAlignmentCenter;
    _headLabel.backgroundColor = [UIColor lightGrayColor];
    _tabView.tableHeaderView = _headLabel;
    _headLabel.text = @"在线用户（0）";
    [self updateData];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateData
{
    __weak typeof(self)wf= self;
    [_chatSDK userListWithPage:1 size:200 completed:^(id data, NSError *error) {
        if(data)
        {
            [wf.userArr removeAllObjects];
            [wf.forbiddenArr removeAllObjects];
            
            wf.headLabel.text = [NSString stringWithFormat:@"在线用户（%@）",data[@"total"]];
            NSDictionary *context       = data[@"context"];
            NSArray *disable_users = data[@"disable_users"];
            
            for (NSString* userid in data[@"list"]) {
                UserItem *item = [[UserItem alloc]init];
                item.userId = userid;
                
                NSDictionary *dic = [UserListViewController objectWithJsonString:context[userid]];
                if([dic isKindOfClass:[NSDictionary class]])
                {
                    item.nick_name = dic[@"nick_name"];
                    item.avatar    = dic[@"avatar"];
                }
                
                for (NSString* tuserid in disable_users) {
                    if([userid isEqualToString:tuserid])
                    {
                        item.forbidden = YES;
                        break;
                    }
                }
                
                if(item.forbidden)
                    [wf.forbiddenArr addObject:item];
                else
                    [wf.userArr addObject:item];
            }
            
            //查找未在线禁言者
            for (NSString* tuserid in disable_users) {
                BOOL ishave = NO;
                for ( UserItem *item in wf.forbiddenArr) {
                    if([tuserid isEqualToString:item.userId]){
                        ishave = YES;
                        break;
                    }
                }
                if(!ishave)
                {
                    UserItem *item = [[UserItem alloc]init];
                    item.userId = tuserid;
                    item.forbidden = YES;
                    item.online = NO;
                    [wf.forbiddenArr addObject:item];
                }
            }
            
            [wf.tabView reloadData];
        }
    }];
}

- (void) mybtnClicked:(MyButton*)btn
{
    __weak typeof(self)wf= self;
    [_chatSDK forbidden:!btn.selected targetId:btn.userId completed:^(NSError *error) {
        if(!error)
        {
            [wf showMsg:btn.selected?@"取消禁言成功":@"禁言成功" afterDelay:1];
            [wf updateData];
        }
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userArr.count+_forbiddenArr.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static   NSString *Identifier = @"noiseSwitchCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    
    UserItem *item;
    if(indexPath.row<_userArr.count)
        item = _userArr[indexPath.row];
    else if(indexPath.row == _userArr.count)
    {
        cell.textLabel.text = @"--------------   禁言列表   -------------";
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.imageView.image = nil;
        MyButton *btn = [cell.contentView viewWithTag:10001];
        btn.hidden = YES;
        return cell;
    }
    else
        item = _forbiddenArr[indexPath.row-_userArr.count-1];

    NSString *str = [NSString stringWithFormat:@"%@[id:%@]%@",item.nick_name?item.nick_name:@"",item.userId,item.online?@"":@"(offline)"];
    cell.textLabel.text = str;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont systemFontOfSize:13];

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    
    MyButton *btn = [cell.contentView viewWithTag:10001];
    if(!btn)
    {
        btn = [[MyButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-90, 5, 80, 30)];
        [btn addTarget:self action:@selector(mybtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn setTitle:@"禁言" forState:UIControlStateNormal];
        [btn setTitle:@"取消禁言" forState:UIControlStateSelected];
        btn.tag = 10001;
        [cell.contentView addSubview:btn];
    }
    btn.hidden = NO;
    btn.userId = item.userId;
    btn.selected = item.forbidden;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
//JSON字符串转化为字典
+ (id)objectWithJsonString:(NSString *)jsonString
{
    if (![jsonString isKindOfClass:[NSString class]] || jsonString.length <= 0) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingMutableContainers
                                               error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
