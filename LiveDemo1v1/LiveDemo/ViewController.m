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
#import "NSStringAPI.h"
#import "VideoView.h"
#import "SocketClient.h"

#define XHIGHT [UIScreen mainScreen].bounds.size.height/568
#define XWIDTH [UIScreen mainScreen].bounds.size.width/320
#define HIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<
VVConnectionDelegate,
//VVClassDelegate,
VVMediaDelegate,
//VVPeerDelegate,
//VVChatDelegate,
SocketClientDelegate>
{
//    NSMutableArray * liveArray;
//    NSString * locaStr;
//    NSString * remotStr;
//    NSDictionary * locavideoTrackDict;
    
    NSString* myPeerId;  //自己的id
    NSString* strType;//保存通话类型
    NSString* toName;  //通话目标对象
    long connectRoomId;  //通话房间id
    BOOL bAutoConnect;    //是否自动接受通话请求
    
    
}

@property (nonatomic, strong) VideoView* vView;
@property (nonatomic, copy) NSArray* users;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    view.backgroundColor = [UIColor grayColor];
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-55,25 , 110, 30)];
    lab.text = @"人员列表";
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    [self.view addSubview:view];
    
//    liveArray = [NSMutableArray new];
    [[Shinevv shareManager] addShinevvDelegate:(id)self];
    myPeerId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    strType = nil;
    toName = nil;
    connectRoomId = 0;
    bAutoConnect = NO;
    [self initView];
    //[self joinroom];
    
    [SocketClient client].dataDelegate = self;
}

- (void)setDatas:(NSArray *)data
{
    
    NSDictionary* dic = data[0];
    
    self.users = dic[@"userList"];
    
    [self.collectionView reloadData];
}


- (void)joinroom
{
    //连接服务器
    [[Shinevv shareManager]joinRoom:@"vvroom.shinevv.cn"
                           WithPort:3443
                          WithToken:@"06175684da8706a0da7e0a6fb2aa8d02"
                    WithDisplayName:_nickName
                         WithRoomId:[NSString stringWithFormat:@"%ld", connectRoomId]
                           WithRole:@"student"
                         WithPeerID:myPeerId
                      WithMediaType:nil];

}

- (void)leaveRoom{
    [[Shinevv shareManager] leaveRoom];
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
- (void)onAddLocalVideoTrack:(RTCVideoTrack *)videoTrack
                  WithPeerId:(NSString *)peerId
                    WihtRole:(NSString *)role
             WithDisplayName:(NSString*)displayName{


        if ([strType isEqualToString:@"video"]) {
            [self.vView setLocalTarck:videoTrack];
        }else{
            [[Shinevv shareManager] modifyVideoStatus:NO];
        }
}

// 远端视频创建成功回调
- (void)onAddRemoteVideoTrack:(RTCVideoTrack *)videoTrack
                   WithPeerId:(NSString *)peerId
                     WihtRole:(NSString *)role
              WithDisplayName:(NSString *)displayName
                WithMediaShar:(NSString *)mediaShar{
    
    
    if ([strType isEqualToString:@"audio"]) {
        [[Shinevv shareManager]setPeerVideoPause:peerId Pause:YES];
    }else if([strType isEqualToString:@"video"]){
        [self.vView setOtherTarck:videoTrack];
        [[Shinevv shareManager]setPeerVideoPause:peerId Pause:NO];
    }
    
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
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    return _users.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];

    long index = indexPath.row;
    if (_users.count > index) {
        
        cell.disNameLab.text = [_users objectAtIndex:index];
        if ([[_users objectAtIndex:index] isEqualToString:_nickName]) {
            cell.disNameLab.textColor = [UIColor redColor];
            cell.videoBut.hidden = YES;
            cell.audioBut.hidden = YES;
        }else{
            cell.disNameLab.textColor = [UIColor blackColor];
            cell.videoBut.hidden = NO;
            cell.audioBut.hidden = NO;
        }
        cell.peerIndex = index;
        if (cell.block == nil) {
            __weak ViewController* ws = self;
            cell.block = ^(int butIndex, NSInteger peerIndex) {
                [ws connectWithType:butIndex toPeer:peerIndex];
            };
        }
    }
   
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout 
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.bounds.size.width-2, (self.view.bounds.size.height-64)/10 -2);
}

//申请通话
- (void)connectWithType:(int)type toPeer:(NSInteger)peerIndex{
    //1v1通话模式
    strType = type?@"audio":@"video";
    //1v1通话目标对象
    toName = [_users objectAtIndex:peerIndex];
    //1v1通话房间id
    connectRoomId = 1000000 + arc4random()%8000000;
    
    //发送请求
    [[SocketClient client] callFormName:_nickName toName:toName type:type room:connectRoomId];
    //显示等待界面
    [self showWaitView:YES];
    
    if (bAutoConnect) {
        [self joinroom];
    }
    
}

//回复申请
- (void)replyConnectResult:(NSInteger)result{

    SocketClient * sk = [SocketClient client];
    if (result == 0) {
        [sk callEndWithRoom:connectRoomId];
        [self leaveRoom];
        [self hideWaitView];
        
    }else
    {
        [sk callAgreeWithRoom:connectRoomId];
        [self joinroom];
    }
   
    
}


- (void)showWaitView:(BOOL)bSrc{
    self.vView = [[VideoView alloc] initWithFrame: self.view.frame];
    [self.vView setSrc:bSrc type:strType name:toName];
    [self.view addSubview:self.vView];
    __weak ViewController* ws = self;
    self.vView.block = ^(NSInteger butIndex) {
        [ws replyConnectResult:butIndex];
    };
}

- (void)hideWaitView{
    [self.vView dispose];
    [self.vView removeFromSuperview];
    self.vView = nil;
    connectRoomId = 0;
    toName = nil;
    strType = nil;
}



// 远端视频删除
- (void)onRemoveRemoteVideoTrack:(RTCVideoTrack *)videoTrack
                      WithPeerId:(NSString *)peerId
                      WithSource:(NSString *)sourceStr{
    

}


#pragma SocketClientDelegate
//用户进入
- (void)onUserJoined:(NSArray*)data
{
    [self setDatas:data];
}
//用户离开
- (void)onUserLeft:(NSArray*)data
{
    NSDictionary* dic = data[0];
    if([dic[@"username"] isEqualToString:toName])
    {
        [self leaveRoom];
        [self hideWaitView];
    }
    [self setDatas:data];
}
//收到通话请求
- (void)onCalling:(NSArray*)data
{
    NSDictionary* infoDic = data[0];
    NSString* name = infoDic[@"called"];
    if (![name isEqualToString:_nickName]) {
        return;
    }
    toName = infoDic[@"calling"];
    connectRoomId = [infoDic[@"room"] longValue];
    strType = [infoDic[@"method"]intValue] ?@"audio":@"video";
    [self showWaitView:NO];
}
//收到同意通话消息
- (void)onCallAgree:(NSArray*)data
{
    NSDictionary* infodic = data[0];
    long roomid =[infodic[@"room"] longValue];
    if (roomid == connectRoomId) {
        [self joinroom];
    }
    
}
//收到拒接或挂断消息
- (void)onCallEnd:(NSArray*)data
{
    
    NSDictionary* infodic = data[0];
            
    long roomid =[infodic[@"room"] longLongValue];
    if (roomid ==connectRoomId) {
        [self leaveRoom];
        [self hideWaitView];
    }
    
}





@end
