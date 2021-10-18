//
//  LZViewController.m
//  LZToastHelper
//
//  Created by lilei_hapy@163.com on 06/19/2019.
//  Copyright (c) 2019 lilei_hapy@163.com. All rights reserved.
//

#import "LZViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LZViewController ()

@end

@implementation LZViewController

// MARK: - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
	
    // 成功图标
    UIImage *completeImg = [UIImage imageNamed:@"hub_warning_icon"];
    UIImageView *completeImgView = [[UIImageView alloc] initWithImage:completeImg];
    [LZToast setIcon:completeImgView forState:LZToastStateOperateSuccess];
    [LZToast setIcon:completeImgView forState:LZToastStateSubmitComplete];
    [LZToast setIcon:completeImgView forState:LZToastStateUpdateComplete];
    [LZToast setIcon:completeImgView forState:LZToastStateLoadComplete];
}

// MARK: - UI Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
    
    UIImage *img = [UIImage imageNamed:@"hub_warning_icon"];
    UIImageView *customView = [[UIImageView alloc] initWithImage:img];
    for (NSUInteger i = 0; i < 2; i++) {
        
        MBProgressHUD *hud = [self toastToView:self.view];
        hud.mode = MBProgressHUDModeCustomView;
        [hud setCustomView:customView];
        hud.label.text = @"Title";
        hud.detailsLabel.text = @"Content";
        [hud hideAnimated:YES afterDelay:2];
    }
}

// MARK: - Private

- (MBProgressHUD *)toastToView:(UIView *)view {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.minSize = CGSizeMake(100, 100);
    hud.graceTime = 0.25f;
    hud.minShowTime = 1.0;
    hud.margin = 8;
    hud.defaultMotionEffectsEnabled = NO;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor darkGrayColor];
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

- (void)testMuti {
    
    for (int i = 0; i < 10; i++) {
        
        [self testInteractive];
        [self testLongTitle];
        [self testChangeState];
        [self testToast];
        [self testCustomImage];
    }
    [self testAsync];
}

- (void)testAsync {
    
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self testLongTitle];
    });
}

- (void)testLongTitle {
    
    [LZToast showMessage:@"测试你有没有苗lafl苏里加厚lfsjlijfldsafasj虹口区蝇蟬kjkl就影响力；影响力中坚力量"
                  toView:nil];
    
    [LZToast showMessage:@"加载……" toView:nil];
    
    [LZToast showMessageWithoutIcon:@"哈哈" toView:nil];
    
    [LZToast hideMessageAfterDelay:1.0 completion:^{
        
    }];
}

- (void)testChangeState {
    
    [LZToast showMessageForState:LZToastStateSubmitting
                          toView:nil];
    [LZToast changeState:LZToastStateSubmitComplete];
    [LZToast hideMessageAfterDelay:2 completion:^{
    }];
}

- (void)testToast {
    
    [LZToast showSuccess:@"哈哈哈哈" toView:nil];
    [LZToast showError:@"哈哈哈哈" toView:nil];
    
    [LZToast showSuccess:@"哈哈哈哈" toView:nil];
    [LZToast showError:@"哈哈哈哈" toView:nil];
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
             buttonTitle:@"取消"
              completion:^{
        NSLog(@"Toast 消失了");
    }];
}

@end
