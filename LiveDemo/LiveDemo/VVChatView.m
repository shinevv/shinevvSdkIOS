//
//  VVChartView.m
//  VVRoom
//
//  Created by Apple on 2017/11/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "VVChatView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <VVRoomPeerconnection/Shinevv.h>
#define COLOR(R, G, B, A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)]

#define XHIGHT [UIScreen mainScreen].bounds.size.height/568
#define XWIDTH [UIScreen mainScreen].bounds.size.width/320
#define HIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width
@interface VVChatView ()<VVMediaDelegate>
@end
@implementation VVChatView
{
    UIButton * carmearBtn;
    UIButton * microPhoneBtn;
    UIButton * handsBtn;
    CGSize charsize;

}



- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    UIView * chatTopBar = [[UIView alloc]init];
    chatTopBar.backgroundColor = COLOR(26, 27, 28, 1);
    chatTopBar.frame = self.bounds;
    [self addSubview:chatTopBar];

    //carmear
    carmearBtn = [[UIButton alloc]init];
    [carmearBtn setImage:[UIImage imageNamed:@"carmea"] forState:UIControlStateNormal];
    carmearBtn.frame = CGRectMake(WIDTH/2 + 5*XWIDTH, 14*XHIGHT, 30*XWIDTH, 30*XHIGHT);

    [carmearBtn addTarget:self action:@selector(carmearBtn:) forControlEvents:UIControlEventTouchUpInside];
    [chatTopBar addSubview:carmearBtn];
    carmearBtn.selected = YES;
    
    //microPhone
    microPhoneBtn = [[UIButton alloc]init];
    [microPhoneBtn setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
    microPhoneBtn.frame = CGRectMake(WIDTH/2 + 45*XWIDTH, 14*XHIGHT, 30*XWIDTH, 30*XHIGHT);

    [microPhoneBtn addTarget:self action:@selector(microPhone:) forControlEvents:UIControlEventTouchUpInside];
    [chatTopBar addSubview:microPhoneBtn];
    microPhoneBtn.selected = YES;
    UIButton * switchCarmear = [[UIButton alloc]init];
    [switchCarmear setImage:[UIImage imageNamed:@"switchCamear"] forState:UIControlStateNormal];
    switchCarmear.frame = CGRectMake(WIDTH/2 + 85*XWIDTH, 14*XHIGHT, 30*XWIDTH, 30*XHIGHT);
    [switchCarmear addTarget:self action:@selector(switchCarmear:) forControlEvents:UIControlEventTouchUpInside];
    [chatTopBar addSubview:switchCarmear];

    UIButton * speakerBtn = [[UIButton alloc]init];
    [speakerBtn setImage:[UIImage imageNamed:@"ic_mic_disable"] forState:UIControlStateNormal];
    speakerBtn.frame = CGRectMake(WIDTH/2 + 125*XWIDTH, 14*XHIGHT, 30*XWIDTH, 30*XHIGHT);
    [speakerBtn addTarget:self action:@selector(speakerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [chatTopBar addSubview:speakerBtn];

    [[Shinevv shareManager]addShinevvDelegate:(id)self];
    
    return self;
}

//////open Or close LocaAudio and Video
- (void)OnCreateLocalAudio:(bool) status{
    if (status) {
        [microPhoneBtn setImage:[UIImage imageNamed:@"microphone_n"] forState:UIControlStateNormal];
        microPhoneBtn.selected = NO;
    }else{
        [microPhoneBtn setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
        microPhoneBtn.selected = YES;
    }
}

- (void)OnCreateLocalVideo:(bool) status WithReject:(bool)fromSever{
    
    if (status) {
       
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CamerState" object:@(1)];
        [carmearBtn setImage:[UIImage imageNamed:@"carmea_n"] forState:UIControlStateNormal];
        carmearBtn.selected = NO;
    }else{
      
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CamerState" object:@(0)];
        [carmearBtn setImage:[UIImage imageNamed:@"carmea"] forState:UIControlStateNormal];
        carmearBtn.selected = YES;
    }
}

//hands
//- (void)raiseHands:(UIButton *)raiseHandsBtn{
//
//    raiseHandsBtn.selected = !raiseHandsBtn.selected;
//    if (handsState == YES) {
//        raiseHandsBtn.selected = YES;
//        handsState = NO;
//    }
//    if (raiseHandsBtn.selected) {
//        [raiseHandsBtn setImage:[UIImage imageNamed:@"handsY"] forState:UIControlStateSelected];
//        [[Shinevv shareManager]sendRaiseHandsMessage:YES];
//    }else{
//        [raiseHandsBtn setImage:[UIImage imageNamed:@"handsN"] forState:UIControlStateSelected];
//        [[Shinevv shareManager]sendRaiseHandsMessage:NO];
//    }
//
//}

//switchCamear
- (void)switchCarmear:(UIButton *)switchBtn{
    
//    BOOL classSte = [[NSUserDefaults standardUserDefaults]boolForKey:@"classState"];
//    if (classSte == YES) {
    switchBtn.selected = !switchBtn.selected;
    
    if (switchBtn.selected) {
        [[Shinevv shareManager]switchPostCamera];
    }else{
        [[Shinevv shareManager]swithcFrontCamera];
    }
//    }
}

- (void)reset{
    //if(!carmearBtn.selected){
        carmearBtn.selected = YES;
        [carmearBtn setImage:[UIImage imageNamed:@"carmea"] forState:UIControlStateNormal];
    //}
    //if(!microPhoneBtn.selected){
        [microPhoneBtn setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
        microPhoneBtn.selected = YES;
    //}
}

//- (void)setCamearAndAudioSteatus:(NSString *)type WithSteatus:(bool)steatus{
//
//    if ([type isEqualToString:@"closevideo"]) {
//        [carmearBtn setImage:[UIImage imageNamed:@"carmea"] forState:UIControlStateNormal];
//        carmearBtn.userInteractionEnabled = NO;
//
//    }else if ([type isEqualToString:@"openvideo"]){
//        [carmearBtn setImage:[UIImage imageNamed:@"carmea_n"] forState:UIControlStateNormal];
//        carmearBtn.userInteractionEnabled = YES;
//    }
//
//    if ([type isEqualToString:@"closeaudio"]) {
//        [microPhoneBtn setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
//        microPhoneBtn.userInteractionEnabled = NO;
//    }else if ([type isEqualToString:@"openaudio"]) {
//        [microPhoneBtn setImage:[UIImage imageNamed:@"microphone_n"] forState:UIControlStateNormal];
//        microPhoneBtn.userInteractionEnabled = YES;
//    }
//}

//switchSpeaker
- (void)speakerBtn:(UIButton *)speakerBt{

    speakerBt.selected = !speakerBt.selected;
    
    if (speakerBt.selected) {
        [speakerBt setImage:[UIImage imageNamed:@"ic_mic_enable"] forState:UIControlStateNormal];
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }else{
        [speakerBt setImage:[UIImage imageNamed:@"ic_mic_disable"] forState:UIControlStateNormal];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
}

//openMicrophone
- (void)microPhone:(UIButton *)micBtn{
    micBtn.selected = !micBtn.selected;
    [[Shinevv shareManager]modifyAudioStatus: !micBtn.selected ];

    if (micBtn.selected) {
        [micBtn setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
    }else{
        [micBtn setImage:[UIImage imageNamed:@"microphone_n"] forState:UIControlStateNormal];
    }
}

//openCarmear
- (void)carmearBtn:(UIButton *)carmearBtn{

    carmearBtn.selected = !carmearBtn.selected;
    [[Shinevv shareManager]modifyVideoStatus:!carmearBtn.selected];

    if (carmearBtn.selected) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"CamerState" object:@(0)];
        [carmearBtn setImage:[UIImage imageNamed:@"carmea"] forState:UIControlStateNormal];
        
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CamerState" object:@(1)];
        [carmearBtn setImage:[UIImage imageNamed:@"carmea_n"] forState:UIControlStateNormal];
    }
}

@end
