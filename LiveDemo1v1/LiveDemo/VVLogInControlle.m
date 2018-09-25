//
//  VVLogInControlle.m
//  VVRoom
//
//  Created by Apple on 2017/11/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "VVLogInControlle.h"
#import "AppDelegate.h"
#import "SocketClient.h"
//#import "MMDrawerController.h"
@interface VVLogInControlle ()<SocketClientDelegate>
{

}
@end

@implementation VVLogInControlle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [SocketClient client].loginDelegate = self;
    _nikeNameLab.layer.cornerRadius = 23;
    _nikeNameLab.layer.masksToBounds = YES;
    [_nikeTestFiled setTextColor:[UIColor whiteColor]];
    

}
//login
- (IBAction)loginClick:(id)sender {

    if (_nikeTestFiled.text.length > 0) {
        
        [[SocketClient client] loginWithName:_nikeTestFiled.text];
        
    }
    
}


- (void)onLogin:(NSArray*)data
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setRootVC:_nikeTestFiled.text andData:(NSArray*)data];

}


@end
