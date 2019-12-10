//
//  LZViewController.m
//  LZToastHelper
//
//  Created by lilei_hapy@163.com on 06/19/2019.
//  Copyright (c) 2019 lilei_hapy@163.com. All rights reserved.
//

#import "LZViewController.h"
#import <LZToastHelper/LZToastHelper.h>

@interface LZViewController ()

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // 成功图标
    UIImage *completeImg = [UIImage imageNamed:@"hub_warning_icon"];
    UIImageView *completeImgView = [[UIImageView alloc] initWithImage:completeImg];
    [LZToast setIcon:completeImgView forState:LZToastStateOperateSuccess];
    [LZToast setIcon:completeImgView forState:LZToastStateSubmitComplete];
    [LZToast setIcon:completeImgView forState:LZToastStateUpdateComplete];
    [LZToast setIcon:completeImgView forState:LZToastStateLoadComplete];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    for (int i = 0; i < 10; i++) {
        
        [self testInteractive];
        [self testLongTitle];
        [self testChangeState];
        [self testToast];
        [self testCustomImage];
    }
}

- (void)testLongTitle {
    
    [LZToast showMessage:@"测试你有没有苗lafl苏里加厚lfsjlijfldsafasj虹口区蝇蟬kjkl就影响力；影响力中坚力量"
                  toView:nil];
    [LZToast hideMessageAfterDelay:1.0];
}

- (void)testChangeState {
    
    [LZToast showMessageForState:LZToastStateSubmitting
                          toView:nil];
    [LZToast changeState:LZToastStateSubmitComplete];
    [LZToast hideMessageAfterDelay:2];
}

- (void)testToast {
    
    [LZToast showSuccess:@"哈哈哈哈" toView:nil];
}

- (void)testCustomImage {
    
    UIImage *completeImg = [UIImage imageNamed:@"hub_warning_icon"];
    UIImageView *completeImgView = [[UIImageView alloc] initWithImage:completeImg];
    [LZToast showMessage:@"标题"
                  detail:@"哈哈哈"
          customIconView:completeImgView
                  toView:nil
              completion:^{
        NSLog(@"Toast 消失了");
    }];
    [LZToast hideMessageAfterDelay:2.0];
}

- (void)testInteractive {
    
    UIImage *completeImg = [UIImage imageNamed:@"hub_warning_icon"];
    UIImageView *completeImgView = [[UIImageView alloc] initWithImage:completeImg];
    [LZToast showMessage:@"标题"
                  detail:@"哈哈哈"
          customIconView:completeImgView
                  toView:nil
       interactionEnable:YES
             buttonTitle:@"Cancle"
              completion:^{
        NSLog(@"Toast 消失了");
    }];
}
@end
