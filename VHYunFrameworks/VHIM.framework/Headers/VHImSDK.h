//
//  VHImSDK.h
//  VHImSDK
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VHCore/VHMessage.h>

@protocol VHImSDKDelegate;

typedef NS_ENUM(NSInteger, VHIMMessageType) {
    VHIMMessageTypeText,    //文本消息
    VHIMMessageTypeImage,   //图片消息
    VHIMMessageTypeLink,    //URL消息
    VHIMMessageTypeVideo,   //视频消息 暂不支持
    VHIMMessageTypeVoice,   //语音消息 暂不支持
};

@interface VHImSDK : NSObject
@property (nonatomic,weak)id <VHImSDKDelegate>      delegate;
@property (nonatomic,assign)BOOL                    forbidden;
@property (nonatomic,assign)BOOL                    forbiddenAll;

/**
 * IM模块初始化
 */
- (instancetype)initWithChannelID:(NSString*)channelID accessToken:(NSString*)accessToken delegate:(id <VHImSDKDelegate>)delegate;

/**
 * 发送文本消息
 * @param message   IM消息 最长200字
 */
- (void)sendMessage:(NSString*)message completed:(void (^)(NSError *error))completed;

/**
 * 发送图片、连接等消息
 * @param message IM图片等消息 VHIMMessageTypeImage时传入 NSArray 内部为 图片URL 字符串， VHIMMessageTypeLink连接传入 URL 字符串，
 * @param type   IM消息类型 VHIMMessageType
 * @param text   IM文本消息 最长200字
 * @param audit  是否需要AI审核 默认 YES 需要审核
 */
- (void)sendMessage:(id)message type:(VHIMMessageType)type text:(NSString*)text audit:(BOOL)audit completed:(void (^)(NSError *error))completed;

/**
 * 发送图片、连接等消息
 * @param message IM图片等消息 VHIMMessageTypeImage时传入 NSArray 内部为 图片URL 字符串， VHIMMessageTypeLink连接传入 URL 字符串，
 * @param type   IM消息类型 VHIMMessageType
 * @param text   IM文本消息 最长200字
 * @param audit  是否需要AI审核 默认 YES 需要审核
 * @param context  context 可以通过 [VHLiveBase getContext] 获取当前用户全局 context  后追加新参数 此接口不会修改 用户全局 context
 */
- (void)sendMessage:(id)message type:(VHIMMessageType)type text:(NSString*)text audit:(BOOL)audit context:(NSDictionary*)context completed:(void (^)(NSError *error))completed;

/**
 * 发送自定义消息
 * @param message 自定义消息`
 * 自定义消息有频率限制，每个聊天通道最大发送频率为1000条每分钟，注意不是每个客户端
 */
- (void)sendCustomMessage:(NSString*)message completed:(void (^)(NSError *error))completed;

/**
 * 禁言/取消禁言
 * @param isForbidden YES 禁言、NO 取消禁言
 * @param targetId   操作的 第三方ID third_party_user_id
 */
- (void)forbidden:(BOOL)isForbidden targetId:(NSString*)targetId completed:(void (^)(NSError *error))completed;

/**
 * 全员禁言/取消全员禁言
 * @param isForbidden YES 禁言、NO 取消禁言
 */
- (void)forbiddenAll:(BOOL)isForbidden completed:(void (^)(NSError *error))completed;

/**
 * 获取频道内用户列表
 * @param page 当前页
 * @param size 每页大小
 * data 数据结构
 *  list              用户列表
 *  total             总条数
 *  page_num          当前页
 *  page_all          总页数
 *  disable_users     禁言用户列表
 *  channel_disable   频道是否禁言 true禁言 false 解除禁言
 */
- (void)userListWithPage:(int)page size:(int)size completed:(void (^)(id data,NSError *error))completed;

/**
 * 历史消息查询
 * @param page 当前页
 * @param size 每页大小
 * @param startTime  查询开始时间，格式为：2017/01/01
 * @param endTime  查询结束时间，默认为当前时间，格式为：2017/01/01
 * data 数据结构
 *  list              消息列表
 *  total             总条数
 *  page_num          当前页
 *  page_all          总页数
 */
- (void)messageListWithPage:(int)page size:(int)size startTime:(NSString*)startTime endTime:(NSString*)endTime completed:(void (^)(id data,NSError *error))completed;

/**
 *  获得当前SDK版本号
 */
+ (NSString *) getSDKVersion;
@end

@protocol VHImSDKDelegate <NSObject>
@optional
/**
 *  接收IM消息
 *  @param imSDK IM实例
 *  @param message   chat消息  data中聊天消息格式  说明详见本文件底部注释
 */
- (void)imSDK:(VHImSDK *)imSDK receiveChatMessage:(VHMessage*)message;

/**
 *  接收上下线消息
 *  @param imSDK IM实例
 *  @param message   消息
 *  注意： 消息中的头像和昵称需要 设置 [VHLiveBase setThirdPartyUserId:@"xxxx" context:@{@"nick_name":@"xxxx",@"avatar":@"xxxx"}]; 才能收到
 */
- (void)imSDK:(VHImSDK *)imSDK receiveOnlineMessage:(VHMessage*)message;

/**
 *  接收自定义消息
 *  @param imSDK IM实例
 *  @param message   自定义消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveCustomMessage:(VHMessage*)message;

/**
 *  接收room消息
 *  @param imSDK IM实例
 *  @param message   room消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveRoomMessage:(VHMessage*)message;

/**
 *  错误回调
 *  @param imSDK IM实例
 *  @param error    错误
 */
- (void)imSDK:(VHImSDK *)imSDK error:(NSError *)error;

/**
 *  接收IM消息：当前用户是否被禁言
 *  @param imSDK IM实例
 *  @param forbidden    YES:禁言  NO:取消禁言
 */
- (void)imSDK:(VHImSDK *)imSDK forbidden:(BOOL)forbidden;

/**
 *  接收IM消息：当前频道是否被全体禁言
 *  @param imSDK IM实例
 *  @param forbiddenAll    YES:禁言  NO:取消禁言
 */
- (void)imSDK:(VHImSDK *)imSDK forbiddenAll:(BOOL)forbiddenAll;

/**
 *  接收IM消息
 *  @param imSDK IM实例
 *  @param forbidden    当前用户被禁言
 *  @param forbiddenAll 当前频道被全体禁言
 */
- (void)imSDK:(VHImSDK *)imSDK forbidden:(BOOL)forbidden forbiddenAll:(BOOL)forbiddenAll  DEPRECATED_MSG_ATTRIBUTE("2.1.1及以下版本使用，以上版本建议使用-imSDK:forbidden 和 -imSDK:forbiddenAll代替");


#pragma mark - 兼容v1.8.0 之前版本消息回调 请尽快升级到新的回调接口
/**
 *  接收IM消息
 *  @param imSDK IM实例
 *  @param message   IM消息
 *  注意：请尽快使用 imSDK: receiveChatMessage: 接收 聊天消息。支持更多功能
 */
- (void)imSDK:(VHImSDK *)imSDK receiveMessage:(VHMessage*)message;

/**
 *  上下线消息
 *  @param imSDK IM实例
 *  @param message   消息
 *  注意：请尽快使用 imSDK: receiveOnlineMessage: 接收 上下线消息
 */
- (void)imSDK:(VHImSDK *)imSDK onlineMessage:(VHMessage*)message;
@end

/*
聊天消息格式说明
 type 聊天消息类型：
 {
     text    文本消息
     image    图片消息
     link    URL链接
     video    视频消息
     voice    语音消息
     disable    禁言某个用户
     disable_all    全员禁言
     permit    取消禁言某个用户
     permit_all    取消全员禁言
 }
 text_content    文本内容    文本消息
 image_url    图片URL地址    图片消息
 image_urls    多个图片URL地址    批量发送图片消息
 link_url    链接URL地址    URL链接
 video_url    视频文件地址    视频消息
 voice_url    语音音频文件地址    语音消息
 target_id    被禁言或者被取消禁言的目标用户ID    禁言某个用户、取消禁言某个用户
*/
