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
#import "VVChatView.h"
#import "SHAlertView.h"
#define XHIGHT [UIScreen mainScreen].bounds.size.height/568
#define XWIDTH [UIScreen mainScreen].bounds.size.width/320
#define HIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<
VVConnectionDelegate,
VVClassDelegate,
VVMediaDelegate,
VVPeerDelegate,
VVClassDelegate>
{
    NSMutableArray * liveArray;
    NSString * locaStr;
    NSString * remotStr;
    NSDictionary * locavideoTrackDict;
    VVChatView* toolBar;
    BOOL bConnected;
    
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(camerNotif:) name:@"CamerState" object:nil];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    view.backgroundColor = [UIColor grayColor];
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-55,25 , 110, 30)];
    lab.text = @"ShinevvDemo";
    lab.textColor = [UIColor whiteColor];
    [view addSubview:lab];
    [self.view addSubview:view];
    toolBar = [[VVChatView alloc]initWithFrame:CGRectMake(0, HIGHT-55*XHIGHT, WIDTH, 55*XHIGHT)];
    [self.view addSubview:toolBar];
    
    
    liveArray = [NSMutableArray new];
    [[Shinevv shareManager] addShinevvDelegate:(id)self];
    
    [self initView];
    
    bConnected = NO;
    
}
#pragma VVConnectionDelegate
- (void)onConnected{
    NSLog(@"服务器连接成功");
    bConnected = YES;
    [SHAlertView showAlertWithMessage:@"connected" autoDisappearAfterDelay:1];
    
    locaStr = [[Shinevv shareManager] getPeerId];
    
    [self addPeer:@{@"peerId":locaStr,
                    @"disName":self.roomInfo[@"nike"]
                    }];
}

- (void)onConnectFail{
    NSLog(@"连接失败");
    [SHAlertView showAlertWithMessage:@"connect fail" autoDisappearAfterDelay:1];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma VVRoomMediaDelegate
// 本地视频创建成功回调
- (void)onAddLocalVideoTrack:(RTCVideoTrack *)videoTrack
                  WithPeerId:(NSString *)peerId
                    WihtRole:(NSString *)role
             WithDisplayName:(NSString*)displayName{

    NSLog(@"本地视频创建成功");
//    localVideoStatus = YES;
    [self replacdPeer:@{@"peerId":peerId,
                    @"track":videoTrack,
                    @"disName":displayName
                    }];
}

- (void)camerNotif:(NSNotification*)notif{
    if(![[notif object] boolValue]){
        //[_collectionView reloadData];
        [self replacdPeer:@{@"peerId":locaStr,
                            @"disName":_roomInfo[@"nike"]
                            }];
    }
}

// 远端视频创建成功回调
- (void)onAddRemoteVideoTrack:(RTCVideoTrack *)videoTrack
                   WithPeerId:(NSString *)peerId
                     WihtRole:(NSString *)role
              WithDisplayName:(NSString *)displayName
                WithMediaShar:(NSString *)mediaShar{
    NSLog(@"远端视频创建成功");
    
    [self replacdPeer:@{@"peerId":peerId,
                    @"track":videoTrack,
                    @"disName":displayName
                    }];
    remotStr = peerId;
}

- (void)initView{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    
    layout.minimumLineSpacing = 1;
    
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-120) collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    [self.view addSubview:_collectionView];
    UINib *cellNib=[UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CollectionViewCell"];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    return 8;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];

    [cell dispose];
    long index = indexPath.row;
    if (liveArray.count > index) {
        NSDictionary  * trackdict = [liveArray objectAtIndex:index];
        RTCVideoTrack * track = [trackdict objectForKey:@"track"];
        NSString * peerid = [trackdict objectForKey:@"peerId"];
        NSString * disName = [trackdict objectForKey:@"disName"];
       
        
        [cell connectWithVideoTarck:track disName:disName];
        if (track) {
            [[Shinevv shareManager]setPeerVideoPause:peerid Pause:false];
            cell.VideoView.hidden = NO;
        }
        
    }
   
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout 
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.bounds.size.width/2-1, (self.view.bounds.size.height-64)/4-1.2);
}

// 远端视频删除
- (void)onRemoveRemoteVideoTrack:(RTCVideoTrack *)videoTrack
                      WithPeerId:(NSString *)peerId
                      WithSource:(NSString *)sourceStr{
    
    if (peerId) {
        
        NSMutableArray * tempArray = [NSMutableArray arrayWithArray:liveArray];
        NSString* name = @"temp";
        for (NSDictionary* dic in tempArray) {
            if ([dic[@"peerId"]isEqualToString:peerId]) {
                name = dic[@"disName"];
                break;
            }
        }
        [self replacdPeer:@{@"peerId":peerId,
                            @"disName":name
                            }];
//        if (videoTrack != nil) {
//            NSDictionary * videoDict = @{@"track":videoTrack,@"peerId":peerId};
//
//            NSMutableArray * tempArray = [NSMutableArray arrayWithArray:liveArray];
//
//            for (videoDict in tempArray) {
//                NSString * peer =  [videoDict objectForKey:@"peerId"];
//                if ([peer isEqualToString:peerId]) {
//                    [liveArray removeObject:videoDict];
//                }
//            }
//            [_collectionView reloadData];
//        }
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
    NSLog(@"======%@", NSStringFromClass([peersDict class]));
    for (NSDictionary* pDic in peersDict) {
        [self onJoinPeer:pDic];
    }
}
//成员加入
- (void)onJoinPeer:(NSDictionary *)peersDict{
    NSLog(@"++++");
    [self addPeer:@{@"peerId":peersDict[@"peerName"],
                    @"disName":peersDict[@"displayName"]}];
}
//成员离开
- (void)onRemovePeer:(NSDictionary *)peersDict{
    NSLog(@"----");
    [self removePeer:peersDict[@"peerName"]];
}
/**
 离开房间调用
 - (void)leaveRoom
 */

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (bConnected) {
        return;
    }
    NSLog(@"join Room!");
    [[Shinevv shareManager]joinRoom:_roomInfo[@"host"]
                           WithPort:[_roomInfo[@"port"] integerValue]
                          WithToken:_roomInfo[@"token"]
                    WithDisplayName:_roomInfo[@"nike"]
                         WithRoomId:_roomInfo[@"roomid"]
                           WithRole:@"student"
                         WithPeerID:nil
                      WithMediaType:_roomInfo[@"mode"]];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"leave room");
    
    [[Shinevv shareManager] leaveRoom];
    [liveArray removeAllObjects];
    [_collectionView reloadData];
    
    [toolBar reset];
    bConnected = NO;
}


- (void)replacdPeer:(NSDictionary*)peerDic{
    NSArray* arr = [NSArray arrayWithArray:liveArray];
    for (int i=0; i<arr.count; i++) {
        NSDictionary* pdic = [arr objectAtIndex:i];
        if ([pdic[@"peerId"] isEqualToString:peerDic[@"peerId"]]) {
            [liveArray removeObjectAtIndex:i];
            [liveArray insertObject:peerDic atIndex:i];
            [_collectionView reloadData];
            return;
        }
    }
}

- (void)addPeer:(NSDictionary*)peerDic{

    [liveArray addObject:peerDic];
    [_collectionView reloadData];
}

- (void)removePeer:(NSString*)peerid{
    NSArray* arr = [NSArray arrayWithArray:liveArray];
    for (int i=0; i<arr.count; i++) {
        NSDictionary* pdic = [arr objectAtIndex:i];
        if ([pdic[@"peerId"] isEqualToString:peerid]) {
            [liveArray removeObjectAtIndex:i];
            [_collectionView reloadData];
            return;
        }
    }
}

@end
