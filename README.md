# VHYun_SDK_IM_iOS
微吼云 消息 iOS SDK 及 Demo


集成和调用方式，参见官方文档：http://www.vhallyun.com/docs/show/309.html <br>


### APP工程集成SDK基本设置
1、关闭bitcode 设置<br>
2、plist 中 App Transport Security Settings -> Allow Arbitrary Loads 设置为YES<br>
3、注册`AppKey`  [VHLiveBase registerApp:`AppKey`]; <br>
4、检查工程 `Bundle ID` 是否与`AppKey`对应 <br>


### 版本更新信息
#### 版本 v2.1.0 更新时间：2020.03.12
更新内容：<br>
1、支持中途修改昵称等信息<br>
2、历史消息支持图文消息<br>

#### 版本 v2.0.1 更新时间：2019.09.09
更新内容：<br>
1、新增禁言全体禁言<br>
2、新增获取最近消息<br>
3、新增获取用户列表<br>
4、消息AI审核过滤<br>


#### 版本 v2.0.0 更新时间：2019.08.21
更新内容：<br>
1、新消息结构<br>
2、支持图文消息<br>
