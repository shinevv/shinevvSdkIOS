//
//  VideoView.m
//  LiveDemo
//
//  Created by 无线视通 on 2018/9/14.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "VideoView.h"

@interface VideoView()<RTCEAGLVideoViewDelegate>
@end
@implementation VideoView
{
    RTCVideoTrack * lVideoTrack;
    RTCVideoTrack * oVideoTrack;
//    CGSize _remoteVideoSize;
    
    UIButton* startBut;
    UIButton* endBut;
    
    UILabel* lab;
    UILabel* peerLab;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor whiteColor];
        _localVideoView = [[RTCEAGLVideoView alloc] init];
        _localVideoView.frame = CGRectMake(0, 0,self.frame.size.width, self.frame.size.height);
        _localVideoView.backgroundColor = [UIColor clearColor];
        //_videoView.delegate = (id)self;
        _localVideoView.hidden = YES;
        [self addSubview:_localVideoView];
        
        
        _otherVideoView = [[RTCEAGLVideoView alloc] init];
        _otherVideoView.frame = CGRectMake(self.frame.size.width*0.75, 0,self.frame.size.width*0.25, self.frame.size.height*0.25);
        _otherVideoView.backgroundColor = [UIColor clearColor];
        _otherVideoView.delegate = (id)self;
        _otherVideoView.hidden = YES;
        [self addSubview:_otherVideoView];
        
        
        UIButton* transBut = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*0.75, 0,self.frame.size.width*0.25, self.frame.size.height*0.25)];
        transBut.backgroundColor = [UIColor clearColor];
//        [self addSubview:transBut];
        [transBut addTarget:self action:@selector(changeTrack:) forControlEvents:UIControlEventTouchUpInside];
        
        startBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
//        startBut.backgroundColor = [UIColor greenColor];
        [startBut setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateNormal];
        [startBut addTarget:self action:@selector(sendResult:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: startBut];
        startBut.center  = CGPointMake(self.frame.size.width*0.25, self.frame.size.height - 100);
        startBut.tag = 1;
        
        endBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
//        endBut.backgroundColor = [UIColor redColor];
        [endBut setImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
        [endBut addTarget:self action:@selector(sendResult:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:endBut];
        endBut.center  = CGPointMake(self.frame.size.width*0.75, self.frame.size.height - 100);
        endBut.tag = 0;
        
        
        lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        lab.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.3);
        [self addSubview:lab];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor greenColor];
        lab.text = @"正在语音通话";
        lab.hidden = YES;
        
        peerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        peerLab.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
        [self addSubview:peerLab];
        peerLab.textAlignment = NSTextAlignmentCenter;
        peerLab.textColor = [UIColor blueColor];
        peerLab.font = [UIFont systemFontOfSize:30];
        peerLab.text = @"";
        peerLab.hidden = YES;
        
    }
    return self;
}

- (void)changeTrack:(UIButton*)but{
    but.selected = !but.selected;
    if (but.selected) {
        [lVideoTrack removeRenderer:_localVideoView];
        [lVideoTrack addRenderer:_otherVideoView];
        [oVideoTrack removeRenderer:_otherVideoView];
        [oVideoTrack addRenderer:_localVideoView];
        
    }else{
        [lVideoTrack removeRenderer:_otherVideoView];
        [lVideoTrack addRenderer:_localVideoView];
        [oVideoTrack removeRenderer:_localVideoView];
        [oVideoTrack addRenderer:_otherVideoView];
    }
}

- (void)sendResult:(UIButton*)but{
    if (but.tag == 1) {
//        [self setSrc:YES];
        startBut.hidden = YES;
        endBut.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height-100);
    }
    if (_block) {
        _block(but.tag);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (void)connectWithVideoTarck:(RTCVideoTrack *)videoTrack{
//    SvideoTrack = videoTrack;
//    [videoTrack addRenderer:_localVideoView];
//
//}

- (void)videoView:(RTCEAGLVideoView *)videoView didChangeVideoSize:(CGSize)size{
    if (videoView == _otherVideoView) {
    
        CGFloat sc = size.width / size.height;
        CGFloat h = _otherVideoView.frame.size.height;
        CGFloat w = h * sc;
        _otherVideoView.frame = CGRectMake(0, 0, w, h);
        _otherVideoView.center = CGPointMake(self.frame.size.width-w*0.5, h*0.5);
        
    }
}
- (void)dispose{
    if(oVideoTrack){
        [oVideoTrack removeRenderer:_otherVideoView];
        oVideoTrack = nil;
    }
    _otherVideoView.hidden = YES;
    
    if(lVideoTrack){
        [lVideoTrack removeRenderer:_localVideoView];
        _localVideoView = nil;
    }
    _localVideoView.hidden = YES;
}

- (void)setLocalTarck:(RTCVideoTrack *)videoTrack
{
    lVideoTrack = videoTrack;
    _localVideoView.hidden = NO;
    [lVideoTrack addRenderer:_localVideoView];
}
- (void)setOtherTarck:(RTCVideoTrack *)videoTrack
{
    oVideoTrack = videoTrack;
    _otherVideoView.hidden = NO;
    [oVideoTrack addRenderer:_otherVideoView];
}

- (void)setSrc:(BOOL)bSrc type:(NSString*)type name:(NSString*)targetName
{
    if (bSrc) {
        startBut.hidden = YES;
        endBut.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height-100);
    }
    if ([type isEqualToString:@"audio"]) {
        lab.hidden = NO;
        peerLab.hidden = NO;
        peerLab.text = targetName;
    }
    
}

//- (void)layoutSubviews {

//    _localVideoView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //_otherVideoView.frame = CGRectMake(self.frame.size.width*0.75, 0,self.frame.size.width*0.25, self.frame.size.height*0.25);
//    _otherVideoView.center = self.center;
//}

@end
