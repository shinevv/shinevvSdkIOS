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
@property (nonatomic,strong)UILabel* disNameLib;


- (void)connectWithVideoTarck:(RTCVideoTrack *)videoTrack disName:(NSString*)name;
- (void)dispose;
@end
