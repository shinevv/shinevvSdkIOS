//
//  VVLogInControlle.m
//  VVRoom
//
//  Created by Apple on 2017/11/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "VVLogInControlle.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "SHAlertView.h"
//#import "MMDrawerController.h"
@interface VVLogInControlle ()
{
    ViewController * rootVc;
    //MMDrawerController * drawerController;
    __weak IBOutlet UIButton *videoBtn;
    __weak IBOutlet UIButton *audioBtn;
    __weak IBOutlet UIButton *lisenBtn;
    
}
@end

@implementation VVLogInControlle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    _accountNameLab.layer.cornerRadius = 23;
    _accountNameLab.layer.masksToBounds = YES;
    _passwordLav.layer.cornerRadius = 23;
    _passwordLav.layer.masksToBounds = YES;
    [_accountTextFiled setTextColor:[UIColor whiteColor]];
    [_passwordTextFiled setTextColor:[UIColor whiteColor]];
    
    _nikeNameLab.layer.cornerRadius = 23;
    _nikeNameLab.layer.masksToBounds = YES;
    [_nikeTestFiled setTextColor:[UIColor whiteColor]];
    
    _serverHost.layer.cornerRadius = 23;
    _serverHost.layer.masksToBounds = YES;
    [_serverHost setTextColor:[UIColor whiteColor]];
    
    _serverPort.layer.cornerRadius = 23;
    _serverPort.layer.masksToBounds = YES;
    [_serverPort setTextColor:[UIColor whiteColor]];
    videoBtn.selected = YES;
    
    _accountTextFiled.text = @"50430";
    _passwordTextFiled.text = @"babe1e131acd6cd6f93a631a39754c4b";
    _nikeTestFiled.text = @"ios*";
    _hostFiled.text = @"sl.xat.shinevv.com";
    _portFiled.text = @"3443";

}
//login
- (IBAction)loginClick:(id)sender {

//    [self initView];
    if ([self accountAndPassword:_accountTextFiled.text] == YES &&
        [self accountAndPassword:_passwordTextFiled.text] == YES &&
        [self accountAndPassword:_hostFiled.text] &&
        [self accountAndPassword:_portFiled.text] &&_nikeTestFiled.text.length > 0){
        
        if ([_accountTextFiled.text containsString:@" "]) {
            [SHAlertView showAlertWithMessage:NSLocalizedString(@"spaceClass", nil) autoDisappearAfterDelay:1];
        }else{
            if (rootVc == nil) {
                rootVc = [[ViewController alloc] init];
            }
            NSString* mode = @"video";
            if (audioBtn.selected) {
                mode = @"audio";
            }
            rootVc.roomInfo = @{@"roomid":_accountTextFiled.text,
                                @"token":_passwordTextFiled.text,
                                @"nike":_nikeTestFiled.text,
                                @"host":_hostFiled.text,
                                @"port":_portFiled.text,
                                @"mode":mode
                                };
            [self.navigationController pushViewController:rootVc animated:YES];
        }
    }else{
        
        if ( _nikeTestFiled.text.length <= 0) {
            [SHAlertView showAlertWithMessage:@"昵称不能为空" autoDisappearAfterDelay:1];
            return;
        }
        if ( _passwordTextFiled.text.length <= 0) {
            [SHAlertView showAlertWithMessage:@"token不能为空" autoDisappearAfterDelay:1];
            return;
        }
        if ( _accountTextFiled.text.length <= 0) {
            [SHAlertView showAlertWithMessage:@"房间号不能为空" autoDisappearAfterDelay:1];
            return;
        }
        if ( _hostFiled.text.length <= 0) {
            [SHAlertView showAlertWithMessage:@"服务器地址不能为空" autoDisappearAfterDelay:1];
            return;
        }
        
        if ( _portFiled.text.length <= 0) {
            [SHAlertView showAlertWithMessage:@"服务器端口不能为空" autoDisappearAfterDelay:1];
            return;
        }

    }
}





- (BOOL)accountAndPassword:(NSString *)str{
    
    if ([str isKindOfClass:[NSNull class]] || [str isEqualToString:@""] || str == nil) {
        return NO;
    }else{
        return YES;
    }
}

- (void)initView{
    self.LoginAnimView = [[UIView alloc] initWithFrame:self.loginBtn.frame];
    self.LoginAnimView.layer.cornerRadius = 10;
    self.LoginAnimView.layer.masksToBounds = YES;
    self.LoginAnimView.frame = self.loginBtn.frame;
    self.LoginAnimView.backgroundColor = self.loginBtn.backgroundColor;
    [self.view addSubview:self.LoginAnimView];
    self.loginBtn.hidden = YES;
    //把view从宽的样子变圆
    CGPoint centerPoint = self.LoginAnimView.center;
    CGFloat radius = MIN(self.loginBtn.frame.size.width, self.loginBtn.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.LoginAnimView.frame = CGRectMake(0, 0, radius, radius);
        self.LoginAnimView.center = centerPoint;
        self.LoginAnimView.layer.cornerRadius = radius/2;
        self.LoginAnimView.layer.masksToBounds = YES;
        
    }completion:^(BOOL finished) {
        
        //给圆加一条不封闭的白色曲线
        UIBezierPath* path = [[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(radius/2, radius/2) radius:(radius/2 - 5) startAngle:0 endAngle:M_PI_2 * 2 clockwise:YES];
        self.shapeLayer = [[CAShapeLayer alloc] init];
        self.shapeLayer.lineWidth = 1.5;
        self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.shapeLayer.fillColor = self.loginBtn.backgroundColor.CGColor;
        self.shapeLayer.frame = CGRectMake(0, 0, radius, radius);
        self.shapeLayer.path = path.CGPath;
        [self.LoginAnimView.layer addSublayer:self.shapeLayer];
        
        //让圆转圈，实现"加载中"的效果
        CABasicAnimation* baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        baseAnimation.duration = 0.4;
        baseAnimation.fromValue = @(0);
        baseAnimation.toValue = @(2 * M_PI);
        baseAnimation.repeatCount = MAXFLOAT;
        [self.LoginAnimView.layer addAnimation:baseAnimation forKey:nil];
    }];
}
- (IBAction)videobtn:(id)sender {
    videoBtn.selected = YES;
    audioBtn.selected = NO;
}
- (IBAction)audiobtn:(id)sender {
    videoBtn.selected = NO;
    audioBtn.selected = YES;
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    _accountTextFiled.text = @"";
//    _nikeTestFiled.text = @"";
//}
@end
