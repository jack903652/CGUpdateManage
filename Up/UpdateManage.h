//
//  UpdateManage.h
//  Up
//
//  Created by bamq on 16/7/19.
//  Copyright © 2016年 bamq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, UpdatePolicy) {
    ///强制更新
    UpdatePolicyRequired,
    ///可选更新
    UpdatePolicyOptional,
    ///没有更新
    UpdatePolicyNone,
};

@interface UpdateManage : NSObject<UIAlertViewDelegate>
+(instancetype)manage;
///打开的链接地址
@property(nonatomic,strong)NSURL *url;
///获取更新策略
@property(nonatomic,copy)UpdatePolicy (^updateBlock)();
@end
