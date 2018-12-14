
#import <Foundation/Foundation.h>

@interface SHAlertView : NSObject

/**
 *  @brief show alertView when net error.
 *

 */
+ (void)showAlertForNetError;

/**
 *  @brief show alertView when Parameter error.
 *
 */
+ (void)showAlertForParameterError;

/**
 *  @brief only sureButton.
 *
 *  @param message the message for alertView.
 *
 *  @param surekey the block for sure button in alertview.
 */
+ (void)showAlertWithMessage:(NSString *)message
                     sureKey:(void(^) (void))surekey;

/**
 *  @brief only sureButton.
 *
 *  @param title the title for alertView.
 *
 *  @param message the message for alertView.
 *
 *  @param surekey the block for sure button in alertview, when clicked, it will be executed.
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   sureKey:(void(^) (void))surekey;

/**
 *  @brief sureButton and cancel button.
 *
 *  @param message the message for alertView.
 *
 *  @param surekey the block for sure button in alertview, when clicked, it will be executed.
 *
 *  @param cancelKey the block for cancel button in alertview, when clicked, it will be executed.
 *
 */
+ (void)showAlertWithMessage:(NSString *)message
                     sureKey:(void(^) (void))surekey
                   cancelKey:(void(^) (void))cancelKey;

/**
 *  @brief sureButton and cancel button.
 *
 *  @param title the title for alertView.
 *
 *  @param message the message for alertView.
 *
 *  @param surekey the block for sure button in alertview, when clicked, it will be executed.
 *
 *  @param cancelKey the block for cancel button in alertview, when clicked, it will be executed.
 *
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   sureKey:(void(^) (void))surekey
                 cancelKey:(void(^) (void))cancelKey;

/**
 *  @brief DIY cancelKeyTitle(left) rightKeyTitle(right).
 *
 *  @param title the title for alertView.
 *
 *  @param message the message for alertView.
 *
 *  @param cancelKeyTitle the title for left button in alertView.
 *
 *  @param rightKeyTitle the title for right button in alertView.
 *
 *
 *
 */
+ (void)showAlertWithTitle:(NSString*)title
                   message:(NSString *)message
            cancelKeyTitle:(NSString *)cancelKeyTitle
             rightKeyTitle:(NSString *)rightKeyTitle
                  rightKey:(void(^) (void))rightKey
                 cancelKey:(void(^) (void))cancelkey;

/**
 *  @brief auto dismiss.
 *
 *  @param message the message for alertview.
 *
 *  @param delay the time for the alertView to disappear.
 *
 */
+ (void)showAlertWithMessage:(NSString *)message
     autoDisappearAfterDelay:(NSTimeInterval)delay;

/**
 *  @brief auto dismiss.
 *
 *  @param title the title for alertview.
 *
 *  @param message the message for alertview.
 *
 *  @param delay the time for the alertView to disappear.
 *
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
   autoDisappearAfterDelay:(NSTimeInterval)delay;

/**
 *  @brief 清除网络请求失败的status; 网络请求失败的弹出时保存在status, 点击确认时清除; 此status存在时, 网络请求失败的弹窗alert不显示.
 *
 */
+ (void)removeNetErrorStatus;

@end
