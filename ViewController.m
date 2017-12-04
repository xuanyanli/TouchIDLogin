//
//  ViewController.m
//  TouchIDLogin
//
//  Created by lixuanyan on 2017/12/4.
//  Copyright © 2017年 lixuanyan. All rights reserved.
//

#import "ViewController.h"

#import "TouchIDLoginHandle.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //指纹登录
    [self createTouchIDLogin];
}

#pragma mark- 指纹登录
- (void)createTouchIDLogin
{
    UIButton *touchIDLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touchIDLoginBtn.frame = CGRectMake(100, 100, 100, 100);
    [touchIDLoginBtn setTitle:@"指纹登录" forState:UIControlStateNormal];
    touchIDLoginBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:touchIDLoginBtn];
    
    [touchIDLoginBtn addTarget:self action:@selector(touchIDLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark- 触发指纹登录
- (void)touchIDLoginBtnClick
{
    [[TouchIDLoginHandle shareInstance]touchIDLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
