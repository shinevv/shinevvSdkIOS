
#import "SHAlertView.h"
#import <UIKit/UIKit.h>
@interface SHAlertView ()<UIAlertViewDelegate>

/// the block of sure key.
@property (nonatomic, copy) void (^sureKey)(void);

/// the block of cancel key.
@property (nonatomic, copy) void (^cancelKey)(void);

@end

typedef NS_ENUM(NSInteger, MPAlertViewType)
{
    MPAlertViewTypeError                    = 0,    //!< 0. net error.
    MPAlertViewTypeSureKey,                         //!< 1. sureButton.
    MPAlertViewTypeTitleAndSureKey,                 //!< 2. sureButton and title.
    MPAlertViewTypeSureAndCancelKey,                //!< 3. sureButton and cancelButton.
    MPAlertViewTypeTitleAndSureKeyCancelKey,        //!< 4. sureButton and cancelButton and title.
    MPAlertViewTypeDIY,                             //!< 5. DIY.
    MPAlertViewTypeAutoDisAppearMessage,            //!< 6. auto dismiss.
    MPAlertViewTypeAutoDisAppearTitleAndMessage,
    MPAlertViewTypeParameterError                   //!< 7. param error,nil.
};

typedef NS_ENUM(NSInteger, MPAlertViewTag)
{
    MPAlertViewTagError                     = 110,  //!< 110. net error.
    MPAlertViewTagSureKey,                          //!< 111. sureButton.
    MPAlertViewTagTitleAndSureKey,                  //!< 112. sureButton and title.
    MPAlertViewTagSureAndCancelKey,                 //!< 113. sureButton and cancelButton.
    MPAlertViewTagTitleAndSureAndCancelKey,         //!< 114. sureButton and cancelButton and title.
    MPAlertViewTagDIY,                              //!< 115. DIY.
    MPAlertViewTagAutoDisAppearMessage,             //!< 116. auto dismiss.
    MPAlertViewTagAutoDisAppearTitleAndMessage,
    MPAlertViewTagParameterError                    //!< 117. param error,nil.
};

@implementation SHAlertView

+ (SHAlertView *)shareManager
{
    
    return [[self alloc] init];
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    
    static SHAlertView * manager;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [super allocWithZone:zone];
    });
    
    return manager;
}



+ (void)showAlertForParameterError
{
    
    [[self shareManager] showAlertViewWithMessage:NSLocalizedString(@"just_tip_tishi_Parameter_error", nil)
                                              tag:MPAlertViewTagParameterError
                                             type:MPAlertViewTypeParameterError
                                              DIY:nil];
}

+ (void)showAlertWithMessage:(NSString *)message
                     sureKey:(void(^) ())surekey
{
    
    [[self shareManager] showAlertViewWithMessage:message
                                              tag:MPAlertViewTagSureKey
                                             type:MPAlertViewTypeSureKey
                                              DIY:nil];
    [self shareManager].sureKey = surekey;
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   sureKey:(void(^) ())surekey
{    
    if (title == nil)
    {
        title = @"";
    }
    
    [[self shareManager] showAlertViewWithMessage:message
                                              tag:MPAlertViewTagTitleAndSureKey
                                             type:MPAlertViewTypeTitleAndSureKey
                                              DIY:@{@"title":title}];
    [self shareManager].sureKey = surekey;
}

+ (void)showAlertWithMessage:(NSString *)message
                     sureKey:(void(^) ())surekey
                   cancelKey:(void(^) ())cancelKey
{
    
    [[self shareManager] showAlertViewWithMessage:message
                                              tag:MPAlertViewTagSureAndCancelKey
                                             type:MPAlertViewTypeSureAndCancelKey
                                              DIY:nil];
    [self shareManager].sureKey   = surekey;
    [self shareManager].cancelKey = cancelKey;
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   sureKey:(void(^) ())surekey
                 cancelKey:(void(^) ())cancelKey
{
    
    if (title == nil)
    {
        title = @"";
    }
    [[self shareManager] showAlertViewWithMessage:message
                                              tag:MPAlertViewTagTitleAndSureAndCancelKey
                                             type:MPAlertViewTypeTitleAndSureKeyCancelKey
                                              DIY:@{@"title":title}];
    [self shareManager].sureKey   = surekey;
    [self shareManager].cancelKey = cancelKey;
}

+ (void)showAlertWithTitle:(NSString*)title
                   message:(NSString *)message
            cancelKeyTitle:(NSString *)cancelKeyTitle
             rightKeyTitle:(NSString *)rightKeyTitle
                  rightKey:(void(^) ())rightKey
                 cancelKey:(void(^) ())cancelkey
{
    
    if (title          == nil) title          = @"";
    if (cancelKeyTitle == nil) cancelKeyTitle = @"";
    if (rightKeyTitle  == nil) rightKeyTitle  = @"";
    
    NSDictionary *parameter = @{@"cancelKey" : cancelKeyTitle,
                                @"rightKey"  : rightKeyTitle,
                                @"title"     : title};
    
    [[self shareManager] showAlertViewWithMessage:message
                                              tag:MPAlertViewTagDIY
                                             type:MPAlertViewTypeDIY
                                              DIY:parameter];
    [self shareManager].sureKey   = rightKey;
    [self shareManager].cancelKey = cancelkey;
}

+ (void)showAlertWithMessage:(NSString *)message
     autoDisappearAfterDelay:(NSTimeInterval)delay
{
    
    [[self shareManager] showAlertViewWithMessage:message
                                              tag:MPAlertViewTagAutoDisAppearMessage
                                             type:MPAlertViewTypeAutoDisAppearMessage
                                              DIY:@{@"delay":@(delay)}];
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
   autoDisappearAfterDelay:(NSTimeInterval)delay
{
    if (title == nil)
    {
        title = @"";
    }
    [[self shareManager] showAlertViewWithMessage:message
                                              tag:MPAlertViewTagAutoDisAppearTitleAndMessage
                                             type:MPAlertViewTypeAutoDisAppearTitleAndMessage
                                              DIY:@{@"delay":@(delay),@"title":title}];
}

- (void)showAlertViewWithMessage:(NSString *)message
                             tag:(MPAlertViewTag)tag
                            type:(MPAlertViewType)type
                             DIY:(NSDictionary *)parameter
{
    
    NSString *cancelTitle = nil;
    NSString *sureTitle   = nil;
    NSString *title       = nil;
    
    switch (tag)
    {
        case MPAlertViewTagSureKey:
        {
            sureTitle   = NSLocalizedString(@"确认", nil);
            title       = NSLocalizedString(@"提示", nil);
            break;
        }
            
        case MPAlertViewTagSureAndCancelKey:
        {
            sureTitle   = NSLocalizedString(@"确认", nil);
            cancelTitle = NSLocalizedString(@"取消", nil);
            title       = NSLocalizedString(@"提示", nil);
            break;
        }
            
        case MPAlertViewTagDIY:
        {
            sureTitle   = parameter[@"rightKey"];
            cancelTitle = parameter[@"cancelKey"];
            title       = parameter[@"title"];
            
            if (sureTitle.length   == 0) sureTitle   = nil;
            if (cancelTitle.length == 0) cancelTitle = nil;
            if (title.length       == 0) title       = nil;
            break;
        }
            
        case MPAlertViewTagAutoDisAppearMessage:
        {
            break;
        }
            
        case MPAlertViewTagAutoDisAppearTitleAndMessage:
        {
            title = parameter[@"title"];
            
            if (title.length == 0) title = nil;
            break;
        }
            
        case MPAlertViewTagTitleAndSureKey:
        {
            sureTitle  = NSLocalizedString(@"OK_Key", nil);
            title      = parameter[@"title"];
            
            if (title.length == 0) title = nil;
            break;
        }
            
        case MPAlertViewTagTitleAndSureAndCancelKey:
        {
            title       = parameter[@"title"];
            sureTitle   = NSLocalizedString(@"OK_Key", nil);
            cancelTitle = NSLocalizedString(@"cancel_Key", nil);
            if (title.length == 0) title = nil;
            break;
        }
            
        case MPAlertViewTagError:
        {
            sureTitle   = NSLocalizedString(@"OK_Key", nil);
            break;
        }
        
        case MPAlertViewTagParameterError:
        {
            sureTitle   = NSLocalizedString(@"OK_Key", nil);
            break;
        }
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle : title
                                message : message
                               delegate : self
                      cancelButtonTitle : cancelTitle
                      otherButtonTitles : sureTitle,nil];
    alert.tag = tag;
    [alert show];
    
    if (alert.tag == MPAlertViewTagAutoDisAppearMessage ||
        alert.tag == MPAlertViewTagAutoDisAppearTitleAndMessage)
    {
        [self performSelector:@selector(alertAutoDisappear:)
                   withObject:alert
                   afterDelay:[parameter[@"delay"] doubleValue]];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == MPAlertViewTagSureKey                          ||
        alertView.tag == MPAlertViewTagTitleAndSureKey
        )
    {
        if (self.sureKey) self.sureKey();
    }
    
    else if (alertView.tag == MPAlertViewTagSureAndCancelKey            ||
             alertView.tag == MPAlertViewTagDIY                         ||
             alertView.tag == MPAlertViewTagTitleAndSureAndCancelKey
             )
    {
        if (buttonIndex == 0) {
            if (self.cancelKey) self.cancelKey();
        } else {
            if (self.sureKey) self.sureKey();
        }
    }
}

#pragma mark - alertAutoDisappear
- (void)alertAutoDisappear:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Net Error Status Methods
+ (void)saveNetErrorStatus
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"error"
                     forKey:@"alert_net_error"];
    [userDefaults synchronize];
}

+ (BOOL)checkForShowNetError
{
    NSString *str = [[NSUserDefaults standardUserDefaults]
                     objectForKey:@"alert_net_error"];
    if (str                                  &&
        [str isKindOfClass:[NSString class]] &&
        [str isEqualToString:@"error"])
        return NO;
    
    return YES;
}

+ (void)removeNetErrorStatus
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"alert_net_error"];
    [userDefaults synchronize];
}

@end
