//
//  CollectionViewCell.h
//  VVRoomDemo
//
//  Created by Apple on 2018/2/5.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <VVRoomPeerconnection/RTCEAGLVideoView.h>
//#import <VVRoomPeerconnection/RTCVideoTrack.h>
typedef void (^SelectBlock)(int butIndex, NSInteger peerIndex);
@interface CollectionViewCell : UICollectionViewCell
//<RTCEAGLVideoViewDelegate>
//@property (weak, nonatomic) IBOutlet UIView *cellView;
//@property (nonatomic,strong)RTCEAGLVideoView * VideoView;


//- (void)connectWithVideoTarck:(RTCVideoTrack *)videoTrack;
//- (void)dispose;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *disNameLab;
@property (weak, nonatomic) IBOutlet UIButton *videoBut;
@property (weak, nonatomic) IBOutlet UIButton *audioBut;

@property (nonatomic, copy) SelectBlock block;
@property (assign, nonatomic) NSInteger peerIndex;
@end
