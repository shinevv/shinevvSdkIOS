//
//  AppDelegate.m
//  LiveDemo
//
//  Created by Apple on 2018/2/1.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "AppDelegate.h"
#import "VVLogInControlle.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self registerCustomKeyboard];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [self setRootVClogin];
    VVLogInControlle* logVC = [[VVLogInControlle alloc] init];
    logVC.title = @"SDK-Demo";
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:logVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

//注册第三方的键盘，用于控制文本编辑和键盘的高度
- (void)registerCustomKeyboard
{
    IQKeyboardManager *kbManager =  [IQKeyboardManager sharedManager];
    kbManager.enableAutoToolbar = NO;
    kbManager.shouldResignOnTouchOutside = YES;
    kbManager.enable = YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
