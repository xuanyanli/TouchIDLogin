//
//  TouchIDLoginHandle.h
//  TouchIDLogin
//
//  Created by lixuanyan on 2017/12/4.
//  Copyright © 2017年 lixuanyan. All rights reserved.
//  指纹登录助手

#import <Foundation/Foundation.h>

@interface TouchIDLoginHandle : NSObject

+(TouchIDLoginHandle *)shareInstance;


/**
 指纹登录
 */
- (void)touchIDLogin;

@end
