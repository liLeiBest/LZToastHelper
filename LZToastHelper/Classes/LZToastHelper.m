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

#pragma mark - -> LazyLoading
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

#pragma mark - -> initialization
- (instancetype)init {
	
    if (self = [super init]) {
		
        [self setupDefaultValue];
        [self prepareMessageForState];
        [self prepareIconForState];
    }
    
    return self;
}

#pragma mark - -> Public
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

#pragma mark Show
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
    
    [self showToastMessage:self.stateMessages[@(state)]
                     detail:nil
                   iconView:self.stateIcons[@(state)]
              toContentView:view
                 ignoreIcon:NO
                   autoHide:autoHide];
}

/** 显示不同状态的提示，可以添加提示消失后的动作 */
- (void)showMessageForState:(LZToastState)state
                     toView:(UIView *)view
                 completion:(ToastCompleteBlock)completeBlock {
	
    [self showMessageForState:state toView:view];
    self.myHud.completionBlock = completeBlock;
}

/** 显示成功提示 */
- (void)showSuccessToView:(UIView *)view {
    [self showMessageForState:LZToastStateOperateSuccess toView:view];
}

/** 显示指定的成功提示语 */
- (void)showSuccess:(NSString *)success
             toView:(UIView *)view {
    [self showToastMessage:success
                     detail:nil
                   iconView:self.stateIcons[@(LZToastStateOperateSuccess)]
              toContentView:view
                 ignoreIcon:NO
                   autoHide:YES];
}

/** 显示失败提示 */
- (void)showErrorToView:(UIView *)view {
    [self showMessageForState:LZToastStateOperateFailure toView:view];
}

/** 显示指定的失败提示语 */
- (void)showError:(NSString *)error
           toView:(UIView *)view {
    [self showToastMessage:error
                     detail:nil
                   iconView:self.stateIcons[@(LZToastStateOperateFailure)]
              toContentView:view
                 ignoreIcon:NO
                   autoHide:YES];
}

/** 显示指定的提示 */
- (void)showMessage:(NSString *)message
             toView:(UIView *)view {
    [self showToastMessage:message
                     detail:nil
                   iconView:nil
              toContentView:view
                 ignoreIcon:NO
                   autoHide:NO];
}

/** 显示指定的提示语，可以添加提示消失后的动作 */
- (void)showMessage:(NSString *)message
             toView:(UIView *)view
         completion:(ToastCompleteBlock)completeBlock {
	
    [self showMessage:message toView:view];
    self.myHud.completionBlock = completeBlock;
}

/** 显示特定提示语，特定图标 */
- (void)showMessage:(NSString *)message
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view {
    [self showToastMessage:message
                     detail:nil
                   iconView:iconView
              toContentView:view
                 ignoreIcon:NO
                   autoHide:NO];
}

/** 显示特定提示语，特定图标，可以添加提示消失后的动作 */
- (void)showMessage:(NSString *)message
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
         completion:(ToastCompleteBlock)completeBlock {
	
    [self showMessage:message customIconView:iconView toView:view];
    self.myHud.completionBlock = completeBlock;
}

/** 显示包含 message 和 detail 的提示 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
             toView:(UIView *)view {
    [self showToastMessage:message
                     detail:detail
                   iconView:nil
              toContentView:view
                 ignoreIcon:YES
                   autoHide:NO];
}

/** 显示包含 message 和 detail 的提示，可以添加提示消失后的动作 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
             toView:(UIView *)view
         completion:(ToastCompleteBlock)completeBlock {
	
    [self showMessage:message detail:detail toView:view];
    self.myHud.completionBlock = completeBlock;
}

/** 显示只包含 message 的提示 */
- (void)showMessageWithoutIcon:(NSString *)message
                        toView:(UIView *)view {
    [self showMessage:message detail:nil toView:view];
}

/** 显示只包含 message 的提示，可以添加提示消失后的动作 */
- (void)showMessageWithoutIcon:(NSString *)message
                        toView:(UIView *)view
                    completion:(ToastCompleteBlock)completeBlock {
	
    [self showMessage:message toView:view];
    self.myHud.completionBlock = completeBlock;
}

/** 显示包含 message、detail 及 icon 的提示，可以添加提示消失后的动作 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
         completion:(ToastCompleteBlock)completeBlock {
	
    BOOL ignore = nil == iconView ? YES : NO;
    [self showToastMessage:message
                     detail:detail
                   iconView:iconView
              toContentView:view
                 ignoreIcon:ignore
                   autoHide:NO];
	self.myHud.completionBlock = completeBlock;
}

#pragma mark Hide
/** 隐藏提示 */
- (void)hideMessage {
    [self.myHud hideAnimated:YES];
}

/** 隐藏提示，可以添加提示消失后的动作 */
- (void)hideMessageCompletion:(ToastCompleteBlock)completeBlock {
	
    [self hideMessage];
    self.myHud.completionBlock = completeBlock;
}

/** 延迟 delay 秒隐藏提示 */
- (void)hideMessageAfterDelay:(NSTimeInterval)delay {
    [self.myHud hideAnimated:YES afterDelay:delay];
}

/** 延迟 delay 秒隐藏提示，可以添加提示消失后的动作 */
- (void)hideMessageAfterDelay:(NSTimeInterval)delay
                   completion:(ToastCompleteBlock)completeBlock {
	
    [self hideMessageAfterDelay:delay];
    self.myHud.completionBlock = completeBlock;
}

#pragma mark - -> Other

/** 改变提示状态 */
- (void)changeState:(LZToastState)state {
	
    // 保存提示框文字属性
    NSAttributedString *messageAttributedString = nil;
    if (self.myHud.label.attributedText) {
        messageAttributedString =
		[[NSAttributedString alloc] initWithAttributedString:self.myHud.label.attributedText];
    }
    NSAttributedString *detailAttributedString = nil;
    if (self.myHud.detailsLabel.attributedText) {
        detailAttributedString =
		[[NSAttributedString alloc] initWithAttributedString:self.myHud.detailsLabel.attributedText];
    }
    
    // 改变提示框图标
	UIImageView *iconImgView = self.stateIcons[@(state)];
    if (nil != iconImgView) {
		
        [self.myHud setCustomView:iconImgView];
        self.myHud.mode = MBProgressHUDModeCustomView;
    }
	
	// 改变提示文字
	NSString *message = self.stateMessages[@(state)];
	if (nil != message && message.length) {
		messageAttributedString =
		[[NSAttributedString alloc] initWithString:message
										attributes:self.messageAttributed];
	}
	
    // 设置提示框文字属性
    self.myHud.label.attributedText = messageAttributedString;
    self.myHud.detailsLabel.attributedText = detailAttributedString;
}

#pragma mark - -> Private
/**
 @author Lilei
 
 @brief 初始所有状态提示语
 */
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

/**
 @author Lilei
 
 @brief 初始所有状态图标
 */
- (void)prepareIconForState {
	
    // 成功图标
    UIImage *completeImg = [self imageWithResourceName:@"success.png"];
    UIImageView *completeImgView = [[UIImageView alloc] initWithImage:completeImg];
    
    // 失败图标
    UIImage *failureImg = [self imageWithResourceName:@"failure.png"];
    UIImageView *failureImgView = [[UIImageView alloc] initWithImage:failureImg];
    
    [self setIcon:nil forState:LZToastStateLoading];
    [self setIcon:completeImgView forState:LZToastStateLoadComplete];
    [self setIcon:nil forState:LZToastStateUpdating];
    [self setIcon:completeImgView forState:LZToastStateUpdateComplete];
    [self setIcon:nil forState:LZToastStateSubmitting];
    [self setIcon:completeImgView forState:LZToastStateSubmitComplete];
    [self setIcon:completeImgView forState:LZToastStateOperateSuccess];
    [self setIcon:failureImgView forState:LZToastStateOperateFailure];
    [self setIcon:nil forState:LZToastStateCommon];
    [self setIcon:nil forState:LZToastStateOther];
}

/**
 @author Lilei
 
 @brief 初始默认值
 */
- (void)setupDefaultValue {
	
    self.showTime = 1.0f;
    self.minSize = CGSizeMake(200, 80);
    self.messageAttributed = @{
                               NSFontAttributeName : [UIFont systemFontOfSize:15.0f],
                               NSForegroundColorAttributeName : [UIColor whiteColor],
                               };
    self.detailAttributed = @{
                              NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
                              NSForegroundColorAttributeName : [UIColor whiteColor],
                              };
    self.backgroundColor = [UIColor blackColor];
    self.contentColor = [UIColor whiteColor];
}

/**
 @author Lilei
 
 @brief 设置提示框内容
 
 @param message 标题
 @param detail 描述
 @param iconView 图标
 @param view 视图
 @param ignore 是否忽略图标
 @param hide 是否自动隐藏
 */
- (void)showToastMessage:(NSString *)message
                   detail:(NSString *)detail
                 iconView:(UIImageView *)iconView
            toContentView:(UIView *)view
               ignoreIcon:(BOOL)ignore
                 autoHide:(BOOL)hide {
	
    if (nil != self.myHud) {
        [self.myHud hideAnimated:NO];
	}
	
	[self showToast:message
			  detail:detail
			iconView:iconView
	   toContentView:view
		  ignoreIcon:ignore
			autoHide:hide];
}

/**
 @author Lilei
 
 @brief 设置提示框内容
 
 @param message 标题
 @param detail 描述
 @param iconView 图标
 @param view 视图
 @param ignore 是否忽略图标
 @param hide 是否自动隐藏
 */
- (void)showToast:(NSString *)message
			detail:(NSString *)detail
		  iconView:(UIImageView *)iconView
	 toContentView:(UIView *)view
		ignoreIcon:(BOOL)ignore
		  autoHide:(BOOL)hide {
	
	// 实例
	if (nil == view) {
		view = [UIApplication sharedApplication].keyWindow;
	}
	[view endEditing:YES];
	MBProgressHUD *hud = [self toastToView:view];
	self.myHud = hud;
	
	// mode
	if (nil != iconView) {
		
		iconView.contentMode = UIViewContentModeScaleAspectFit;
		UIImage *fitImg = [self scaledImage:iconView.image];
		iconView.image = fitImg;
		
		hud.customView = iconView;
		hud.mode = MBProgressHUDModeCustomView;
	} else if (YES == ignore) {
		hud.mode = MBProgressHUDModeText;
	}
	
	// 设置提示语
	hud.label.attributedText =
	[[NSAttributedString alloc] initWithString:message attributes:self.messageAttributed];
	if (nil == detail) {
		detail = @"";
	}
	hud.detailsLabel.attributedText =
	[[NSAttributedString alloc] initWithString:detail attributes:self.detailAttributed];
	
	if (YES == hide) {
		[self hideMessageAfterDelay:self.showTime];
	}
}

/**
 @author Lilei
 
 @brief 创建提示框到 View 视图上
 
 @param view 视图
 
 @return MBProgressHUD
 */
- (MBProgressHUD *)toastToView:(UIView *)view {
	
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.minSize = self.minSize;
    hud.graceTime = 0.25f;
    hud.minShowTime = self.showTime;
    hud.margin = 5.0f;
	hud.defaultMotionEffectsEnabled = YES;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = self.backgroundColor;
    hud.contentColor = self.contentColor;
    hud.removeFromSuperViewOnHide = YES;
	
    return hud;
}

/**
 @author Lilei
 
 @brief 根据size缩放图片
 */
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

/**
 @author Lilei
 
 @brief 实例资源目录下的图片
 
 @param name 图片名
 
 @return UIImage
 */
- (UIImage *)imageWithResourceName:(NSString *)name {
	
    NSBundle *toastBundle =
	[NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]]
							  pathForResource:@"LZToastResource.bundle" ofType:nil]];
    NSString *imgPath = [toastBundle pathForResource:name ofType:nil];
    
    return [UIImage imageWithContentsOfFile:imgPath];
}

@end
