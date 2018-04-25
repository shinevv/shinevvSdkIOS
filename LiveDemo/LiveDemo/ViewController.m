//
//  ViewController.m
//  LiveDemo
//
//  Created by Apple on 2018/2/1.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import <VVRoomPeerconnection/RTCCameraPreviewView.h>
#import <VVRoomPeerconnection/RTCEAGLVideoView.h>
#import <VVRoomPeerconnection/Shinevv.h>
#import "CollectionViewCell.h"
#define XHIGHT [UIScreen mainScreen].bounds.size.height/568
#define XWIDTH [UIScreen mainScreen].bounds.size.width/320
#define HIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<VVConnectionDelegate,VVClassDelegate,VVMediaDelegate,VVPeerDelegate,VVClassDelegate>{
    NSMutableArray * liveArray;
    NSString * locaStr;
    NSString * remotStr;
    NSDictionary * locavideoTrackDict;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    view.backgroundColor = [UIColor grayColor];
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-55,25 , 110, 30)];
    lab.text = @"ShinevvDemo";
    lab.textColor = [UIColor whiteColor];
    [view addSubview:lab];
    [self.view addSubview:view];
    
    liveArray = [NSMutableArray new];
    [[Shinevv shareManager] addShinevvDelegate:(id)self];
    NSInteger Port = 3443;

    [[Shinevv shareManager]joinRoom:@"192.168.1.226"
                           WithPort:Port
                          WithToken:@"06175684da8706a0da7e0a6fb2aa8d02"
                    WithDisplayName:@"DemoName"
                         WithRoomId:@"7"
                           WithRole:@"student"
                         WithPeerID:nil];
    
    [self initView];
}
#pragma VVConnectionDelegate
- (void)onConnected{
    NSLog(@"服务器连接成功");
}

- (void)onConnectFail{
    NSLog(@"连接失败");

}
#pragma VVRoomMediaDelegate
// 本地视频创建成功回调
- (void)onAddLocalVideoTrack:(RTCVideoTrack *)videoTrack WithPeerId:(NSString *)peerId WihtRole:(NSString *)role WithDisplayName:(NSString*)displayName{

    
    NSDictionary * trackDict = @{@"peerId":peerId,
                                 @"track":videoTrack};
    
    [liveArray addObject:trackDict];
    [_collectionView reloadData];
    locaStr = peerId;
    
    
}

// 远端视频创建成功回调
- (void)onAddRemoteVideoTrack:(RTCVideoTrack *)videoTrack WithPeerId:(NSString *)peerId WihtRole:(NSString *)role WithDisplayName:(NSString *)displayName WithMediaShar:(NSString *)mediaShar{
    
    NSDictionary * trackDict = @{@"peerId":peerId,
                                 @"track":videoTrack};
    
    [liveArray addObject:trackDict];
    [_collectionView reloadData];
    remotStr = peerId;
}

- (void)initView{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 1;
    
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    [self.view addSubview:_collectionView];
    UINib *cellNib=[UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CollectionViewCell"];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];

    [cell dispose];
    long index = indexPath.row;
    if (liveArray.count > index) {
        NSDictionary  * trackdict = [liveArray objectAtIndex:index];
        RTCVideoTrack * track = [trackdict objectForKey:@"track"];
        NSString * peerid = [trackdict objectForKey:@"peerId"];
       
        [[Shinevv shareManager]setPeerVideoPause:peerid Pause:false];
        [cell connectWithVideoTarck:track];
        cell.VideoView.hidden = NO;
    }
   
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width/2-1, (self.view.bounds.size.height-64)/4-1.2);
}

// 远端视频删除
- (void)onRemoveRemoteVideoTrack:(RTCVideoTrack *)videoTrack WithPeerId:(NSString *)peerId WithSource:(NSString *)sourceStr{
    
    if (peerId.length != 0) {
        
        if (videoTrack != nil) {
            NSDictionary * videoDict = @{@"track":videoTrack,@"peerId":peerId};
            
            NSMutableArray * tempArray = [NSMutableArray arrayWithArray:liveArray];
            
            for (videoDict in tempArray) {
                NSString * peer =  [videoDict objectForKey:@"peerId"];
                if ([peer isEqualToString:peerId]) {
                    [liveArray removeObject:videoDict];
                }
            }
            [_collectionView reloadData];
        }
    }
}

#pragma VVMediaDelegate
- (void)onReceiveTrackSilent:(NSString *)type WithStatus:(bool)status{
    
    NSMutableArray * videoArray = [NSMutableArray arrayWithArray:liveArray];
    for (locavideoTrackDict in videoArray) {
        NSString * peer =  [locavideoTrackDict objectForKey:@"peerID"];
        if ([peer isEqualToString:locaStr]) {
            [liveArray removeObject:locavideoTrackDict];
        }
    }
    [_collectionView reloadData];
}
#pragma VVClassDelegate
- (void)onClassOver{
    [liveArray removeAllObjects];
    [_collectionView reloadData];
}
//开始上课
- (void)onClassStart:(NSDictionary *)timeDict{
    
}

#pragma VVPeerDelegate
//在线成员
- (void)onPeers:(NSDictionary *)peersDict{
    
}
//成员加入
- (void)onJoinPeer:(NSDictionary *)peersDict{
    
}
//成员离开
- (void)onRemovePeer:(NSDictionary *)peersDict{
    
}

/**
 离开房间调用
 - (void)leaveRoom
*/

@end
