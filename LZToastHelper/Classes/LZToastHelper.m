//
//  LZToastHelper.m
//  Pods
//
//  Created by Dear.Q on 16/8/25.
//
//

#import "LZToastHelper.h"
#import <MBProgressHUD/MBProgressHUD.h>

NSString * const LZToastMessageForLoading = @"正在加载……";
NSString * const LZToastMessageForLoadComplete = @"加载完成！";
NSString * const LZToastMessageForUpdating = @"正在更新……";
NSString * const LZToastMessageForUpdateComplete = @"更新完成！";
NSString * const LZToastMessageForSubmitting = @"正在提交……";
NSString * const LZToastMessageForSubmitComplete = @"提交完成！";
NSString * const LZToastMessageForOperateSuccess = @"操作成功！";
NSString * const LZToastMessageForOperateFailure = @"操作失败！";
NSString * const LZToastMessageForCommon = @"";
NSString * const LZToastMessageForOther = @"";

@interface LZToastHelper()

/** 所有状态对应的提示语 */
@property (nonatomic, strong) NSMutableDictionary *stateMessages;
/** 所有状态对应的图标 */
@property (nonatomic, strong) NSMutableDictionary *stateIcons;

/** 保存当前的提示框 */
@property (nonatomic, weak) MBProgressHUD *myHud;

@end

@implementation LZToastHelper

// MARK: - Lazy Loading
- (NSMutableDictionary *)stateMessages {
    if (nil == _stateMessages) {
        _stateMessages = [NSMutableDictionary dictionary];
    }
    return _stateMessages;
}

- (NSMutableDictionary *)stateIcons {
    if (nil == _stateIcons) {
        _stateIcons = [NSMutableDictionary dictionary];
    }
    return _stateIcons;
}

// MARK: - initialization
- (instancetype)init {
    if (self = [super init]) {
		
        [self setupDefaultValue];
        [self prepareMessageForState];
        [self prepareIconForState];
    }
    return self;
}

// MARK: - Public
/** 实例 */
+ (instancetype)sharedToastHelper {
	
	static LZToastHelper *_instace = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instace = [[LZToastHelper alloc] init];
	});
	return _instace;
}

/** 改变不同状态下的提示语 */
- (void)setMessage:(NSString *)message
          forState:(LZToastState)state {
    if (nil == message || 0 == message.length) return;
    self.stateMessages[@(state)] = message;
}

/** 设置不同状态的图标 */
- (void)setIcon:(UIImageView *)icon
       forState:(LZToastState)state {
    if (nil == icon) return;
    UIImage *fitImage = [self scaledImage:icon.image];
    icon.image = fitImage;
    self.stateIcons[@(state)] = icon;
}

// MARK: <Show>
/** 显示不同状态的提示 */
- (void)showMessageForState:(LZToastState)state
                     toView:(UIView *)view {
	
    BOOL autoHide = NO;
    switch (state) {
        case LZToastStateLoading:
        case LZToastStateUpdating:
        case LZToastStateSubmitting:
        case LZToastStateCommon:
        case LZToastStateOther: {
            autoHide = NO;
            break;
        }
        case LZToastStateLoadComplete:
        case LZToastStateUpdateComplete:
        case LZToastStateSubmitComplete:
        case LZToastStateOperateSuccess:
        case LZToastStateOperateFailure: {
            autoHide = YES;
            break;
        }
    }
    UIImageView *iconView = self.stateIcons[@(state)];
    BOOL ignore = nil == iconView ? YES : NO;
    [self showToastWithMessage:self.stateMessages[@(state)]
                        detail:nil
                      iconView:iconView
                 containerView:view
                    ignoreIcon:ignore
                      autoHide:autoHide];
}

/** 显示不同状态的提示，可以添加提示消失后的动作 */
- (void)showMessageForState:(LZToastState)state
                     toView:(UIView *)view
                 completion:(LZToastCompleteBlock)completeBlock {
	
    [self showMessageForState:state toView:view];
    [self hideCompleteCallback:completeBlock];
}

/** 显示成功提示 */
- (void)showSuccessToView:(UIView *)view {
    [self showMessageForState:LZToastStateOperateSuccess toView:view];
}

/** 显示指定的成功提示语 */
- (void)showSuccess:(NSString *)success
             toView:(UIView *)view {
    
    UIImageView *iconView = self.stateIcons[@(LZToastStateOperateSuccess)];
    BOOL ignore = nil == iconView ? YES : NO;
    [self showToastWithMessage:success
                        detail:nil
                      iconView:iconView
                 containerView:view
                    ignoreIcon:ignore
                      autoHide:YES];
}

/** 显示失败提示 */
- (void)showErrorToView:(UIView *)view {
    [self showMessageForState:LZToastStateOperateFailure toView:view];
}

/** 显示指定的失败提示语 */
- (void)showError:(NSString *)error
           toView:(UIView *)view {
    
    UIImageView *iconView = self.stateIcons[@(LZToastStateOperateFailure)];
    BOOL ignore = nil == iconView ? YES : NO;
    [self showToastWithMessage:error
                        detail:nil
                      iconView:iconView
                 containerView:view
                    ignoreIcon:ignore
                      autoHide:YES];
}

/** 显示指定的提示 */
- (void)showMessage:(NSString *)message
             toView:(UIView *)view {
    [self showToastWithMessage:message
                        detail:nil
                      iconView:nil
                 containerView:view
                    ignoreIcon:NO
                      autoHide:NO];
}

/** 显示指定的提示语，可以添加提示消失后的动作 */
- (void)showMessage:(NSString *)message
             toView:(UIView *)view
         completion:(LZToastCompleteBlock)completeBlock {
	
    [self showMessage:message toView:view];
    [self hideCompleteCallback:completeBlock];
}

/** 显示特定提示语，特定图标 */
- (void)showMessage:(NSString *)message
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view {
    [self showToastWithMessage:message
                        detail:nil
                      iconView:iconView
                 containerView:view
                    ignoreIcon:NO
                      autoHide:NO];
}

/** 显示特定提示语，特定图标，可以添加提示消失后的动作 */
- (void)showMessage:(NSString *)message
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
         completion:(LZToastCompleteBlock)completeBlock {
	
    [self showMessage:message customIconView:iconView toView:view];
    [self hideCompleteCallback:completeBlock];
}

/** 显示包含 message 和 detail 的提示 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
             toView:(UIView *)view {
    [self showToastWithMessage:message
                        detail:detail
                      iconView:nil
                 containerView:view
                    ignoreIcon:NO
                      autoHide:NO];
}

/** 显示包含 message 和 detail 的提示，可以添加提示消失后的动作 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
             toView:(UIView *)view
         completion:(LZToastCompleteBlock)completeBlock {
	
    [self showMessage:message detail:detail toView:view];
    [self hideCompleteCallback:completeBlock];
}

/** 显示只包含 message 的提示 */
- (void)showMessageWithoutIcon:(NSString *)message
                        toView:(UIView *)view {
    [self showToastWithMessage:message
                        detail:nil
                      iconView:nil
                 containerView:view
                    ignoreIcon:YES
                      autoHide:NO];
}

/** 显示只包含 message 的提示，可以添加提示消失后的动作 */
- (void)showMessageWithoutIcon:(NSString *)message
                        toView:(UIView *)view
                    completion:(LZToastCompleteBlock)completeBlock {
	
    [self showMessageWithoutIcon:message toView:view];
    [self hideCompleteCallback:completeBlock];
}

/** 显示包含 message、detail 及 icon 的提示，可以添加提示消失后的动作 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
         completion:(LZToastCompleteBlock)completeBlock {
	
    BOOL ignore = nil == iconView ? YES : NO;
    [self showToastWithMessage:message
                        detail:detail
                      iconView:iconView
                 containerView:view
                    ignoreIcon:ignore
                      autoHide:NO];
	[self hideCompleteCallback:completeBlock];
}

/** 显示包含 message、detail 及 icon 的提示，可以添加提示消失后的动作，可以交互主动取消 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
  interactionEnable:(BOOL)interactionEnable
        buttonTitle:(NSString *)buttonTitle
         completion:(LZToastCompleteBlock)completeBlock {
    
    [self showMessage:message
               detail:detail
       customIconView:iconView
               toView:view
           completion:completeBlock];
    if (interactionEnable &&
        buttonTitle &&
        [buttonTitle isKindOfClass:[NSString class]] &&
        buttonTitle.length) {
        if (nil == iconView) {
            self.myHud.mode = MBProgressHUDModeIndeterminate;
        }
        [self.myHud.button setTitle:buttonTitle
                           forState:UIControlStateNormal];
        [self.myHud.button addTarget:self
                              action:@selector(hideMessage)
                    forControlEvents:UIControlEventTouchDown];
    }
}

// MARK: <Hide>
/** 隐藏提示 */
- (void)hideMessage {
    [self hideMessageAfterDelay:0.0 completion:nil];
}

/** 隐藏提示，可以添加提示消失后的动作 */
- (void)hideMessageCompletion:(LZToastCompleteBlock)completeBlock {
	[self hideMessageAfterDelay:0.0 completion:completeBlock];
}

/** 延迟 delay 秒隐藏提示 */
- (void)hideMessageAfterDelay:(NSTimeInterval)delay {
    [self hideMessageAfterDelay:delay completion:nil];
}

/** 延迟 delay 秒隐藏提示，可以添加提示消失后的动作 */
- (void)hideMessageAfterDelay:(NSTimeInterval)delay
                   completion:(LZToastCompleteBlock)completeBlock {
	
    [self hideAnimated:YES afterDelay:delay];
    if (completeBlock) {    
        [self hideCompleteCallback:completeBlock];
    }
}

// MARK: <Other>
/** 改变提示状态 */
- (void)changeState:(LZToastState)state {
    // 改变提示框图标
	UIImageView *iconImgView = self.stateIcons[@(state)];
    if (nil != iconImgView) {
		
        [self.myHud setCustomView:iconImgView];
        self.myHud.mode = MBProgressHUDModeCustomView;
    } else {
        self.myHud.mode = MBProgressHUDModeText;
    }
	// 改变提示文字
    NSString *message = self.myHud.label.attributedText.string;
    NSString *detail = self.myHud.detailsLabel.attributedText.string;
    if (nil == message || 0 == message.length) {
        detail = self.stateMessages[@(state)];
    } else {
        message = self.stateMessages[@(state)];
    }
    [self updateToastMessage:message detail:detail];
}

// MARK: - Private
/// 初始所有状态提示语
- (void)prepareMessageForState {
	
    self.stateMessages[@(LZToastStateLoading)] = LZToastMessageForLoading;
    self.stateMessages[@(LZToastStateLoadComplete)] = LZToastMessageForLoadComplete;
    self.stateMessages[@(LZToastStateUpdating)] = LZToastMessageForUpdating;
    self.stateMessages[@(LZToastStateUpdateComplete)] = LZToastMessageForUpdateComplete;
    self.stateMessages[@(LZToastStateSubmitting)] = LZToastMessageForSubmitting;
    self.stateMessages[@(LZToastStateSubmitComplete)] = LZToastMessageForSubmitComplete;
    self.stateMessages[@(LZToastStateOperateSuccess)] = LZToastMessageForOperateSuccess;
    self.stateMessages[@(LZToastStateOperateFailure)] = LZToastMessageForOperateFailure;
    self.stateMessages[@(LZToastStateCommon)] = LZToastMessageForCommon;
    self.stateMessages[@(LZToastStateOther)] = LZToastMessageForOther;
}

/// 初始所有状态图标
- (void)prepareIconForState {
	
    [self setIcon:nil forState:LZToastStateLoading];
    [self setIcon:nil forState:LZToastStateLoadComplete];
    [self setIcon:nil forState:LZToastStateUpdating];
    [self setIcon:nil forState:LZToastStateUpdateComplete];
    [self setIcon:nil forState:LZToastStateSubmitting];
    [self setIcon:nil forState:LZToastStateSubmitComplete];
    [self setIcon:nil forState:LZToastStateOperateSuccess];
    [self setIcon:nil forState:LZToastStateOperateFailure];
    [self setIcon:nil forState:LZToastStateCommon];
    [self setIcon:nil forState:LZToastStateOther];
}

/// 初始默认值
- (void)setupDefaultValue {
	
    self.showTime = 1.0f;
    self.minSize = CGSizeMake(120, 60);
    self.messageAttributed = @{
                               NSFontAttributeName : [UIFont systemFontOfSize:15.0f],
                               NSForegroundColorAttributeName : [UIColor whiteColor],
                               };
    self.detailAttributed = @{
                              NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
                              NSForegroundColorAttributeName : [UIColor whiteColor],
                              };
    self.backgroundColor = [UIColor darkGrayColor];
    self.contentColor = [UIColor whiteColor];
}

/// 设置提示框内容
/// @param message 标题
/// @param detail 内容
/// @param iconView 图标
/// @param containerView 展示视图
/// @param ignore 是否忽略图标
/// @param hide 是否自动隐藏
- (void)showToastWithMessage:(NSString *)message
                      detail:(NSString *)detail
                    iconView:(UIImageView *)iconView
               containerView:(UIView *)containerView
                  ignoreIcon:(BOOL)ignore
                    autoHide:(BOOL)hide {
    // 隐藏已经存在的弹框
    if (nil != self.myHud) {
        
        self.myHud.minShowTime = 0;
        [self hideAnimated:NO afterDelay:0.0];
        self.myHud = nil;
    }
    // 异常：如果标题和内容均为空，则不显示
    if ((nil == message || NO == [message isKindOfClass:[NSString class]] || 0 == message.length)
        && (nil == detail || NO == [detail isKindOfClass:[NSString class]] || 0 == detail.length)) {
        return;
    }
    // 异常：非主线程调用，则不显示
    if (NO == [NSThread mainThread]) {
        NSAssert([NSThread isMainThread], @"只在主线程提示");
        return;
    }
    // 实例弹框
    if (nil == containerView) {
        containerView = [UIApplication sharedApplication].keyWindow;
    }
    [containerView endEditing:YES];
    MBProgressHUD *hud = [self toastToView:containerView];
    self.myHud = hud;
    if (YES == ignore) {
        hud.mode = MBProgressHUDModeText;
    } else {
        if (nil != iconView) {
            
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            UIImage *fitImg = [self scaledImage:iconView.image];
            iconView.image = fitImg;
            hud.customView = iconView;
            hud.mode = MBProgressHUDModeCustomView;
        } else {
            hud.mode = MBProgressHUDModeIndeterminate;
        }
    }
    // 设置提示语
    [self updateToastMessage:message detail:detail];
    // 是否自动隐藏
    if (YES == hide) {
        [self hideAnimated:YES afterDelay:self.showTime];
    }
}

/// 创建提示框到 View 视图上
/// @param view 展示视图
- (MBProgressHUD *)toastToView:(UIView *)view {
	
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.minSize = self.minSize;
    hud.graceTime = 0.25f;
    hud.minShowTime = self.showTime;
    hud.margin = 8;
	hud.defaultMotionEffectsEnabled = NO;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = self.backgroundColor;
    hud.contentColor = self.contentColor;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

/// 缩放图片
/// @param image 图片
- (UIImage *)scaledImage:(UIImage *)image {
	
    CGSize fitSize = CGSizeMake(37, 37);
    if (!CGSizeEqualToSize(image.size, fitSize)) {
		
        UIGraphicsBeginImageContext(fitSize);
        [image drawInRect:CGRectMake(0, 0, fitSize.width, fitSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }  else {
        return image;
    }
}

/// 更新标题和内容文字
/// @param message 标题
/// @param detail 内容
- (void)updateToastMessage:(NSString *)message
                    detail:(NSString *)detail {
    if (![message isKindOfClass:[NSString class]] || nil == message) {
        message = @"";
    }
    if (![detail isKindOfClass:[NSString class]] || nil == detail) {
        detail = @"";
    }
    if (message.length && 0 == detail.length) {
        
        detail = message;
        message = @"";
    }
    self.myHud.label.attributedText =
    [[NSAttributedString alloc] initWithString:message attributes:self.messageAttributed];
    self.myHud.detailsLabel.attributedText =
    [[NSAttributedString alloc] initWithString:detail attributes:self.detailAttributed];
}

/// 隐藏提示框
/// @param animated 是否显示动画
/// @param delay 延迟 delay 秒
- (void)hideAnimated:(BOOL)animated
          afterDelay:(NSTimeInterval)delay {
    if ([NSThread isMainThread]) {
        [self.myHud hideAnimated:animated afterDelay:delay];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myHud hideAnimated:animated afterDelay:delay];
        });
    }
}

/// 隐藏完成回调
/// @param complete 完成回调
- (void)hideCompleteCallback:(LZToastCompleteBlock)complete {
    self.myHud.completionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete();
            }
        });
    };
}

@end
