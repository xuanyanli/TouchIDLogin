//
//  TouchIDLoginHandle.m
//  TouchIDLogin
//
//  Created by lixuanyan on 2017/12/4.
//  Copyright © 2017年 lixuanyan. All rights reserved.
//  指纹登录助手

#import "TouchIDLoginHandle.h"

#import <LocalAuthentication/LocalAuthentication.h>

@implementation TouchIDLoginHandle

+(TouchIDLoginHandle *)shareInstance
{
    static TouchIDLoginHandle *touchIDLoginHandle = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        touchIDLoginHandle = [[TouchIDLoginHandle alloc]init];
    });
    
    return touchIDLoginHandle;
}

#pragma mark-  指纹登录
- (void)touchIDLogin
{
    //指纹登录授权验证
    [self touchIDLoginAuth];
}

#pragma mark- 指纹登录授权验证
- (void)touchIDLoginAuth
{
    LAContext *authContext = [[LAContext alloc]init];
    authContext.localizedFallbackTitle = @"忘记密码";
    
    NSError *authError = nil;
    NSString *localizedReasonStr = @"请按住Home键完成验证";
    //判断设备是否支持指纹识别
    if ([authContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
        [authContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReasonStr reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success)
            {
                NSLog(@"指纹认证成功");
            }else
            {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                    {
                        NSLog(@"授权失败");
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"用户取消验证Touch ID");
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理"); // -3 在TouchID对话框中点击了输入密码按钮
                        }];
                        
                        break;
                    }
                    case LAErrorSystemCancel:
                    {
                         NSLog(@"取消授权，如其他应用切入，用户自主");
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        NSLog(@"设备系统未设置密码");
                        break;
                    }
                    case LAErrorBiometryNotAvailable:
                    {
                        NSLog(@"设备未设置Touch ID"); // -6
                        break;
                    }
                    case LAErrorBiometryNotEnrolled: // Authentication could not start, because Touch ID has no enrolled fingers
                    {
                        NSLog(@"用户未录入指纹"); // -7
                    }
                        break;
                        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
                    case LAErrorBiometryLockout: //Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite 用户连续多次进行Touch ID验证失败，Touch ID被锁，需要用户输入密码解锁，先Touch ID验证密码
                    {
                        NSLog(@"Touch ID被锁，需要用户输入密码解锁"); // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                    }
                        break;
                    case LAErrorAppCancel: // Authentication was canceled by application (e.g. invalidate was called while authentication was in progress) 如突然来了电话，电话应用进入前台，APP被挂起啦");
                    {
                        NSLog(@"用户不能控制情况下APP被挂起"); // -9
                    }
                        break;
                    case LAErrorInvalidContext: // LAContext passed to this call has been previously invalidated.
                    {
                        NSLog(@"LAContext传递给这个调用之前已经失效"); // -10
                    }
                        break;
#else
#endif
                    default:
                        break;
                }
            }
        }];
    }else
    {
        NSLog(@"设备不支持指纹");
        NSLog(@"%ld", (long)authError.code);
        
        switch (authError.code)
        {
            case LAErrorBiometryNotEnrolled:
            {
                NSLog(@"Authentication could not start, because Touch ID has no enrolled fingers");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"Authentication could not start, because passcode is not set on the device");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
    }
}

@end
