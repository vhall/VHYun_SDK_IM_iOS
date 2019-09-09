//
//  UserListViewController.h
//  VHYunSDKDemo_IM
//
//  Created by vhall on 2019/8/26.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHBaseViewController.h"
#import <VHIM/VHImSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface UserListViewController : VHBaseViewController
@property (nonatomic,weak)VHImSDK * chatSDK;
- (void)updateData;
@end

NS_ASSUME_NONNULL_END
