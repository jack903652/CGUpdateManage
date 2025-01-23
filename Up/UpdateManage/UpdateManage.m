//
//  UpdateManage.m
//  Up
//
//  Created by bamq on 16/7/19.
//  Copyright © 2016年 bamq. All rights reserved.
//

#import "UpdateManage.h"
#define UPDATE_TAG 0xFF
@interface UpdateManage()
@property(nonatomic,strong)UIAlertController *alertView;
@property(nonatomic,assign)BOOL optionalHintDidHint;
@end
@implementation UpdateManage

+(instancetype)sharedManage{
    static UpdateManage *m;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[UpdateManage alloc] init];
    });
    return m;
}
-(instancetype)init{
    self =[super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAction:) name:UIApplicationDidBecomeActiveNotification object:nil];
        self.requiedHint = @"发现新的版本，请更新！";
        self.optionalHint =@"发现新的版本，是否更新？";
        self.requiredExit = YES;
        self.optionalHintOnce = YES;
    }
    return self;
}
-(void)updateAction:(UIApplication *)application{
    if (self.alertView) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UpdatePolicy update = self.updateBlock();
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (update) {
                case UpdatePolicyRequired:
                {
                    self.alertView = [UIAlertController alertControllerWithTitle:@"更新提示" message:self.requiedHint preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:self.url options:@{} completionHandler:nil];
                        if (self.requiredExit) {
                            exit(0);
                        }
                    }];
                    [self.alertView addAction:confirm];
                    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
                    [window.rootViewController presentViewController:self.alertView animated:YES completion:nil];
                }
                    break;
                case UpdatePolicyOptional:
                {
                    if (self.optionalHintOnce && self.optionalHintDidHint) {
                        return;
                    }
                    self.alertView = [UIAlertController alertControllerWithTitle:@"更新提示" message:self.optionalHint preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"更新" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:self.url options:@{} completionHandler:nil];
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
                    [self.alertView addAction:confirm];
                    [self.alertView addAction:cancel];
                    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
                    [window.rootViewController presentViewController:self.alertView animated:YES completion:nil];
                    self.optionalHintDidHint = YES;
                }
                    break;
                case UpdatePolicyNone:
                    break;
                default:
                    break;
            }
        });
    });
}
@end
