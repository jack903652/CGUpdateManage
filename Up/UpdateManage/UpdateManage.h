//
//  UpdateManage.h
//  Up
//
//  Created by bamq on 16/7/19.
//  Copyright © 2016年 bamq. All rights reserved.
//
//  usage
/*
[UpdateManage manage].url =[NSURL URLWithString:@"http://www.baidu.com"];
[UpdateManage manage].updateBlock = ^{
    __block  UpdatePolicy policy = UpdatePolicyNone;
    dispatch_semaphore_t sem =dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(5);
        policy = UpdatePolicyOptional;
        dispatch_semaphore_signal(sem);
    });
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    return policy;
};
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, UpdatePolicy) {
    ///没有更新
    UpdatePolicyNone = 0,
    ///可选更新
    UpdatePolicyOptional,
    ///强制更新
    UpdatePolicyRequired,
};

@interface UpdateManage : NSObject<UIAlertViewDelegate>
+(instancetype)sharedManage;
///打开的链接地址
@property(nonatomic,strong)NSURL *url;
///强制更新提示
@property(nonatomic,copy)NSString *requiedHint;//default @"发现新的版本，请更新！"
///可选更新提示
@property(nonatomic,copy)NSString *optionalHint;//default @"发现新的版本，是否更新？"
///是不是已经做过可选更新提示
@property(nonatomic,assign)BOOL optionalHintDidHint;
///强制更新是否退出
@property(nonatomic,assign)BOOL requiredExit;//default YES
///获取更新策略
@property(nonatomic,copy)UpdatePolicy (^updateBlock)(void);
@end
