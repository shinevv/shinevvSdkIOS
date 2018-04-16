//
//  CollectionViewCell.h
//  VVRoomDemo
//
//  Created by Apple on 2018/2/5.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VVRoomPeerconnection/RTCEAGLVideoView.h>
#import <VVRoomPeerconnection/RTCVideoTrack.h>

@interface CollectionViewCell : UICollectionViewCell<RTCEAGLVideoViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (nonatomic,strong)RTCEAGLVideoView * VideoView;


- (void)connectWithVideoTarck:(RTCVideoTrack *)videoTrack;
- (void)dispose;
@end
