//
//  VideoView.h
//  LiveDemo
//
//  Created by 无线视通 on 2018/9/14.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VVRoomPeerconnection/RTCEAGLVideoView.h>
#import <VVRoomPeerconnection/RTCVideoTrack.h>

typedef void (^ClickBlock)(NSInteger butIndex);
@interface VideoView : UIView
@property (nonatomic,strong)RTCEAGLVideoView * localVideoView;
@property (nonatomic,strong)RTCEAGLVideoView * otherVideoView;
@property (nonatomic, copy)ClickBlock block;

- (void)setLocalTarck:(RTCVideoTrack *)videoTrack;
- (void)setOtherTarck:(RTCVideoTrack *)videoTrack;
- (void)setSrc:(BOOL)bSrc type:(NSString*)type name:(NSString*)targetName;
//- (void)connectWithVideoTarck:(RTCVideoTrack *)videoTrack;
- (void)dispose;
@end
