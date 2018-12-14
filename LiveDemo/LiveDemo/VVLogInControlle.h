//
//  VVLogInControlle.h
//  VVRoom
//
//  Created by Apple on 2017/11/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVLogInControlle : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *accountNameLab;
@property (weak, nonatomic) IBOutlet UILabel *passwordLav;
@property (weak, nonatomic) IBOutlet UITextField *accountTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *nikeTestFiled;
@property (weak, nonatomic) IBOutlet UILabel *nikeNameLab;
@property (weak, nonatomic) IBOutlet UILabel *serverHost;
@property (weak, nonatomic) IBOutlet UILabel *serverPort;
@property (weak, nonatomic) IBOutlet UITextField *hostFiled;
@property (weak, nonatomic) IBOutlet UITextField *portFiled;
@property (nonatomic,strong)UIView * LoginAnimView;
@property (nonatomic,strong)CAShapeLayer * shapeLayer;


@end
