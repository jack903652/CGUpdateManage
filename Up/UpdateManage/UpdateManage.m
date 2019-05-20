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
@property(nonatomic,strong)UIAlertView *alertView;
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
    }
    return self;
}
-(void)updateAction:(UIApplication *)application{
    if ([self.alertView isVisible]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UpdatePolicy update = self.updateBlock();
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (update) {
                case UpdatePolicyRequired:
                {
                    self.alertView =[[UIAlertView alloc] initWithTitle:@"更新提示" message:self.requiedHint delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    self.alertView.tag = UPDATE_TAG+1;
                    self.alertView.delegate =self;
                    [self.alertView show];
                    
                }
                    break;
                case UpdatePolicyOptional:
                {
                    self.optionalHintDidHint = YES;
                    self.alertView =[[UIAlertView alloc] initWithTitle:@"更新提示" message:self.optionalHint delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil];
                    self.alertView.tag = UPDATE_TAG;
                    self.alertView.delegate =self;
                    [self.alertView show];
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == UPDATE_TAG) {
        if (buttonIndex ==0) {
            [[UIApplication sharedApplication] openURL:self.url];
        }
    }else if (alertView.tag == UPDATE_TAG +1){
        if (buttonIndex ==0) {
            [[UIApplication sharedApplication] openURL:self.url];
            if (self.requiredExit) {
                exit(0);
            }
        }
    }
}

@end
