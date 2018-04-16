//
//  CollectionViewCell.m
//  VVRoomDemo
//
//  Created by Apple on 2018/2/5.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "CollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>

@implementation CollectionViewCell{
    RTCVideoTrack* SvideoTrack;
    CGSize _remoteVideoSize;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    _cellView.frame = CGRectMake(0, 0, self.bounds.size.width/2-1, (self.bounds.size.height-64)/4-1);

    _VideoView = [[RTCEAGLVideoView alloc] init];
    _VideoView.frame = CGRectMake(0, 0,self.bounds.size.width+30, self.bounds.size.height+20);
    _VideoView.backgroundColor = [UIColor clearColor];
    _VideoView.delegate = (id)self;
    [self addSubview:_VideoView];
    
}
- (void)connectWithVideoTarck:(RTCVideoTrack *)videoTrack{
    SvideoTrack = videoTrack;
    [videoTrack addRenderer:_VideoView];

}

- (void)dispose{
    if(SvideoTrack){
        [SvideoTrack removeRenderer:_VideoView];
        SvideoTrack = nil;
    }
    _VideoView.hidden = YES;
}
- (void)videoView:(RTCEAGLVideoView *)videoView didChangeVideoSize:(CGSize)size{
    if (videoView == _VideoView) {
        _remoteVideoSize = size;
        [self setNeedsLayout];
        NSLog(@"video size, widht: %f, height: %f",size.width, size.height);
    }
}


- (void)layoutSubviews {
    _VideoView.clipsToBounds = YES;
    
    CGRect bounds = _VideoView.bounds;
    bounds.origin = _VideoView.frame.origin;
    NSLog(@"bounds size, widht: %f, height: %f",bounds.size.width, bounds.size.height);
    if (_remoteVideoSize.width > 0 && _remoteVideoSize.height > 0) {
        // Aspect fill remote video into bounds.
        CGRect remoteVideoFrame = AVMakeRectWithAspectRatioInsideRect(_remoteVideoSize, bounds);
        CGFloat scale = 1;
        if (remoteVideoFrame.size.width > remoteVideoFrame.size.height) {
            // Scale by height.
            scale = bounds.size.height / remoteVideoFrame.size.height;
        } else {
            // Scale by width.
            scale = bounds.size.width / remoteVideoFrame.size.width;
        }
        remoteVideoFrame.size.height *= scale;
        remoteVideoFrame.size.width *= scale;
        _VideoView.frame = remoteVideoFrame;
        _VideoView.center =
        CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
        
    }
}



@end