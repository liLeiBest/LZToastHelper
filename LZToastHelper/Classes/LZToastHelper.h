//
//  LZToastHelper.h
//  Pods
//
//  Created by Dear.Q on 16/8/25.
//
//

#import <Foundation/Foundation.h>

#define LZToast [LZToastHelper sharedToastHelper]

/** 正在加载中 */
UIKIT_EXTERN NSString * const LZToastMessageForLoading;
/** 加载完成 */
UIKIT_EXTERN NSString * const LZToastMessageForLoadComplete;
/** 正在更新中 */
UIKIT_EXTERN NSString * const LZToastMessageForUpdating;
/** 更新完成 */
UIKIT_EXTERN NSString * const LZToastMessageForUpdateComplete;
/** 正在提交中 */
UIKIT_EXTERN NSString * const LZToastMessageForSubmitting;
/** 提交完成 */
UIKIT_EXTERN NSString * const LZToastMessageForSubmitComplete;
/** 操作成功  */
UIKIT_EXTERN NSString * const LZToastMessageForOperateSuccess;
/** 操作失败 */
UIKIT_EXTERN NSString * const LZToastMessageForOperateFailure;
/** 通用 */
UIKIT_EXTERN NSString * const LZToastMessageForCommon;
/** 其它 */
UIKIT_EXTERN NSString * const LZToastMessageForOther;

/**
 @author Lilei
 
 @brief 提示状态
 */
typedef NS_ENUM(NSUInteger, LZToastState) {
    /** 正在加载 */
    LZToastStateLoading = 1,
    /** 加载完成，自动隐藏 */
    LZToastStateLoadComplete,
    /** 正在更新 */
    LZToastStateUpdating,
    /** 更新完成，自动隐藏 */
    LZToastStateUpdateComplete,
    /** 正在提交 */
    LZToastStateSubmitting,
    /** 提交完成，自动隐藏 */
    LZToastStateSubmitComplete,
    /** 操作成功，自动隐藏 */
    LZToastStateOperateSuccess,
    /** 操作失败，自动隐藏 */
    LZToastStateOperateFailure,
    /** 普通 */
    LZToastStateCommon,
    /** 其它 */
    LZToastStateOther,
};

/**
 @author Lilei
 
 @brief 提示完成Block
 */
typedef void (^LZToastCompleteBlock)(void);


/**
 @author Lilei
 
 @brief 提示控件
 */
@interface LZToastHelper : NSObject

/** 自动隐藏显示时间，默认 1.5 秒 */
@property (nonatomic, assign) NSTimeInterval showTime;
/** 提示框最小 size，默认 (120, 60) */
@property (nonatomic, assign) CGSize minSize;
/** MESSAGE字体属性，默认 15号 whiteColor */
@property (nonatomic, strong) NSDictionary *messageAttributed;
/** DETAIL字体属性，默认 13号 whiteColor */
@property (nonatomic, strong) NSDictionary *detailAttributed;
/** 所有文本颜色，默认 whiteColor */
@property (nonatomic, strong) UIColor *contentColor;
/** 背景色，默认 darkGrayColor */
@property (nonatomic, strong) UIColor *backgroundColor;


// MARK: - Init
/**
 实例

 @return LZToastHelper
 */
+ (instancetype)sharedToastHelper;

// MARK: - Config
/**
 @author Lilei
 
 @brief 设置不同状态的提示语
 
 @param message 提示语
 @param state   LZToastState
 */
- (void)setMessage:(NSString *)message
          forState:(LZToastState)state;

/**
 @author Lilei
 
 @brief 设置不同状态的图标
 
 @param icon  图标
 @param state LZToastState
 */
- (void)setIcon:(UIImageView *)icon
       forState:(LZToastState)state;

// MARK: - Show
/**
 @author Lilei
 
 @brief 显示不同状态的提示
 
 @param state LZToastState
 @param view  视图
 */
- (void)showMessageForState:(LZToastState)state
                     toView:(UIView *)view;

/**
 @author Lilei
 
 @brief 显示不同状态的提示，可以添加提示消失后的动作
 
 @param state         LZToastState
 @param view          视图
 @param completeBlock LZToastCompleteBlock
 */
- (void)showMessageForState:(LZToastState)state
                     toView:(UIView *)view
                 completion:(LZToastCompleteBlock)completeBlock;

/**
 @author Lilei
 
 @brief 显示成功提示
 
 @param view 视图
 */
- (void)showSuccessToView:(UIView *)view;

/**
 @author Lilei
 
 @brief 显示指定的成功提示语
 
 @param success 成功提示
 @param view    视图
 */
- (void)showSuccess:(NSString *)success
             toView:(UIView *)view;

/**
 @author Lilei
 
 @brief 显示指定的成功提示语及详情
 
 @param success 成功提示
 @param detail  成功描述
 @param view    视图
 */
- (void)showSuccess:(NSString *)success
             detail:(NSString *)detail
             toView:(UIView *)view;

/**
 @author Lilei
 
 @brief 显示失败提示
 
 @param view 视图
 */
- (void)showErrorToView:(UIView *)view;

/**
 @author Lilei
 
 @brief 显示指定的失败提示语
 
 @param error 错误提示
 @param view  视图
 */
- (void)showError:(NSString *)error
           toView:(UIView *)view;

/**
 @author Lilei
 
 @brief 显示指定的失败提示语及详情
 
 @param error 错误提示
 @param detail  错误描述
 @param view  视图
 */
- (void)showError:(NSString *)error
           detail:(NSString *)detail
           toView:(UIView *)view;

/**
 @author Lilei
 
 @brief 显示指定的提示
 
 @param message 消息提示
 @param view    视图
 */
- (void)showMessage:(NSString *)message
             toView:(UIView *)view;

/**
 @author Lilei
 
 @brief 显示指定的提示语，可以添加提示消失后的动作
 
 @param message       消息提示
 @param view          视图
 @param completeBlock LZToastCompleteBlock
 */
- (void)showMessage:(NSString *)message
             toView:(UIView *)view
         completion:(LZToastCompleteBlock)completeBlock;

/**
 @author Lilei
 
 @brief 显示特定提示语，特定图标
 
 @param message  消息提示
 @param iconView 图标
 @param view     视图
 */
- (void)showMessage:(NSString *)message
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view;

/**
 @author Lilei
 
 @brief 显示特定提示语，特定图标，可以添加提示消失后的动作
 
 @param message         消息提示
 @param iconView        图标
 @param view            视图
 @param completeBlock   LZToastCompleteBlock
 */
- (void)showMessage:(NSString *)message
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
         completion:(LZToastCompleteBlock)completeBlock;

/**
 @author Lilei
 
 @brief 显示包含 message 和 detail 的提示
 
 @param message 消息提示
 @param detail  消息描述
 @param view    视图
 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
             toView:(UIView *)view;

/**
 @author Lilei
 
 @brief 显示包含 message 和 detail 的提示，可以添加提示消失后的动作
 
 @param message       消息提示
 @param detail        消息描述
 @param view          视图
 @param completeBlock LZToastCompleteBlock
 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
             toView:(UIView *)view
         completion:(LZToastCompleteBlock)completeBlock;

/**
 @author Lilei
 
 @brief 显示只包含 message 的提示
 
 @param message 消息提示
 @param view    视图
 */
- (void)showMessageWithoutIcon:(NSString *)message
                        toView:(UIView *)view;

/**
 @author Lilei
 
 @brief 显示只包含 message 的提示，可以添加提示消失后的动作
 
 @param message       消息提示
 @param view          视图
 @param completeBlock LZToastCompleteBlock
 */
- (void)showMessageWithoutIcon:(NSString *)message
                        toView:(UIView *)view
                    completion:(LZToastCompleteBlock)completeBlock;

/**
 @author Lilei
 
 @brief 显示只包含 message、detail 的提示
 
 @param message       消息提示
 @param detail          消息描述
 @param view          视图
 */
- (void)showMessageWithoutIcon:(NSString *)message
                        detail:(NSString *)detail
                        toView:(UIView *)view;

/**
 @author Lilei
 
 @brief 显示只包含 message、detail 的提示，可以添加提示消失后的动作
 
 @param message       消息提示
 @param detail          消息描述
 @param view          视图
 @param completeBlock LZToastCompleteBlock
 */
- (void)showMessageWithoutIcon:(NSString *)message
                        detail:(NSString *)detail
                        toView:(UIView *)view
                    completion:(LZToastCompleteBlock)completeBlock;

/**
 @author Lilei
 
 @brief 显示只包含 message、detai、detail 对齐方式的提示
 
 @param message       消息提示
 @param detail          消息描述
 @param align            对齐方式
 @param view          视图
 */
- (void)showMessageWithoutIcon:(NSString *)message
                        detail:(NSString *)detail
                   detailAlign:(NSTextAlignment)align
                        toView:(UIView *)view;

/**
 @author Lilei
 
 @brief 显示只包含 message、detai、detail 对齐方式的提示，可以添加提示消失后的动作
 
 @param message       消息提示
 @param detail          消息描述
 @param align            对齐方式
 @param view          视图
 @param completeBlock LZToastCompleteBlock
 */
- (void)showMessageWithoutIcon:(NSString *)message
                        detail:(NSString *)detail
                   detailAlign:(NSTextAlignment)align
                        toView:(UIView *)view
                    completion:(LZToastCompleteBlock)completeBlock;

/**
 @author Lilei
 
 @brief 显示包含 message、detail 及 icon 的提示，可以添加提示消失后的动作
 
 @param message         消息提示
 @param detail          消息描述
 @param iconView        图标
 @param view            视图
 @param completeBlock   LZToastCompleteBlock
 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
         completion:(LZToastCompleteBlock)completeBlock;

/**
 @author Lilei
 
 @brief 显示包含 message、detai、detail 对齐方式及 icon 的提示，可以添加提示消失后的动作
 
 @param message         消息提示
 @param detail          消息描述
 @param align            对齐方式
 @param iconView        图标
 @param view            视图
 @param completeBlock   LZToastCompleteBlock
 */
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
        detailAlign:(NSTextAlignment)align
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
         completion:(LZToastCompleteBlock)completeBlock;

/**
@author Lilei

@brief 显示包含 message、detail 及 icon 的提示，可以添加提示消失后的动作，可以交互主动取消

@param message           消息提示
@param detail            消息描述
@param iconView          图标
@param view              视图
@param interactionEnable 是否允许交互
@param buttonTitle       操作标题
@param completeBlock     LZToastCompleteBlock
*/
- (void)showMessage:(NSString *)message
             detail:(NSString *)detail
     customIconView:(UIImageView *)iconView
             toView:(UIView *)view
  interactionEnable:(BOOL)interactionEnable
        buttonTitle:(NSString *)buttonTitle
         completion:(LZToastCompleteBlock)completeBlock;

// MARK: - Hide
/**
 @author Lilei
 
 @brief 隐藏提示
 */
- (void)hideMessage;

/**
 @author Lilei
 
 @brief 隐藏提示，可以添加提示消失后的动作
 
 @param completeBlock LZToastCompleteBlock
 */
- (void)hideMessageCompletion:(LZToastCompleteBlock)completeBlock;

/**
 @author Lilei
 
 @brief 延迟 delay 秒隐藏提示
 
 @param delay delay
 */
- (void)hideMessageAfterDelay:(NSTimeInterval)delay;

/**
 @author Lilei
 
 @brief 延迟 delay 秒隐藏提示，可以添加提示消失后的动作
 
 @param delay         delay
 @param completeBlock LZToastCompleteBlock
 */
- (void)hideMessageAfterDelay:(NSTimeInterval)delay
                   completion:(LZToastCompleteBlock)completeBlock;

// MARK: - Other
/**
 @author Lilei
 
 @brief 改变提示状态
 
 @param state LZToastState
 */
- (void)changeState:(LZToastState)state;

@end
