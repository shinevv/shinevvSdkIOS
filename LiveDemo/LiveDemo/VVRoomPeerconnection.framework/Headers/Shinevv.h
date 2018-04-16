//
//  VVRoomClient.h
//  VVRoomPeerconnection
//
//  Created by wuhaiyang on 2017/12/7.
//  Copyright © 2017年 BeijingWireless. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <VVRoomPeerconnection/RTCAVFoundationVideoSource.h>
#import <VVRoomPeerconnection/RTCVideoTrack.h>
#import <VVRoomPeerconnection/RTCEAGLVideoView.h>

/**
 画板消息结构体
  drawBoardSize 画板大小
  color       颜色
  drawBoardId 画板ID
  pensize     画笔大小
  pen         画笔类型
  pointsArray 点坐标（Proint）集合
  NSNumber *  X
  NSNumber *  Y
  NSDictionary * Proint = @{@"x":X,@"y":Y};
 */
struct DrawBoardMes {
    CGRect drawBoardSize;
   __unsafe_unretained NSString  *color;
   __unsafe_unretained NSString  *drawBoardId;
   __unsafe_unretained NSNumber  *pensize;
   __unsafe_unretained NSNumber  *pen;
   __unsafe_unretained NSMutableArray  *pointsArray;

};

typedef struct DrawBoardMes DrawBoard;
/**
 网络消息结构体
   fps          每秒传输帧数
   bytes        视频包大小
   level        网络信号
   peerID
   packets
   peerName
   lossRate
   packetLoss
   currentDelayMs
 */

struct NetworkInfoMes {
    
    __unsafe_unretained NSString  *peerID;
    __unsafe_unretained NSString  *peerName;
    int level;
    int fps;
    int bytes;
    int currentDelayMs;
    int packetLoss;
    int lossRate;
    int packets;
};

typedef struct NetworkInfoMes NetworkInfo;

@protocol ShinevvDelegate<NSObject>
@end

#pragma VVConnectionDelegate
@protocol VVConnectionDelegate<ShinevvDelegate>

/**
 连接服务器成功回调
 */
- (void)onConnected;

/**
 连接失败或者连接断开回调
 */
- (void)onConnectFail;
@end

#pragma VVClassDelegate
@protocol VVClassDelegate<ShinevvDelegate>
/**
 开始上课回调
 timeDict 课堂已开始时间
 */
- (void)onClassStart:(NSDictionary *)timeDict;
/**
 结束上课回调
 */
- (void)onClassOver;

/**
 课堂同步数据
 
 @param classData 课堂信息
 drawBoardHistory 画板历史数据
 pptState PPT信息
 route    路由信息
 videoState 视频状态
 */
- (void)onClassData:(NSDictionary *)classData;

@end

#pragma VVMediaDelegate
@protocol VVMediaDelegate<ShinevvDelegate>
/**
 创建音视频会话失败
 打开本地音视频设备失败回调
 @param devError 失败信息
 */
@optional
- (void)onCreateSessionFail:(NSString *)devError;

/**
 返回本地音频创建状态
 @param bSuccess true, 成功; false, 失败
 */
@optional
- (void)OnCreateLocalAudio:(bool) status;

/**
 返回本地视频创建状态
 @param bSuccess true, 成功; false, 失败
 */
@optional
- (void)OnCreateLocalVideo:(bool) status;

/**
 本地视频流数据回调
 
 @param videoTrack 视频数据
 @param peerId 视频id
 @param role 用户角色
 @param displayName 显示名字
 */
- (void)onAddLocalVideoTrack:(RTCVideoTrack *)videoTrack
                  WithPeerId:(NSString *)peerId
                    WihtRole:(NSString *)role
             WithDisplayName:(NSString*)displayName;


/**
 本地禁言禁视回调
 @param kind 禁止类型 音频、视频
 @param status 状态 打开、关闭
 */
- (void)onReceiveTrackSilent:(NSString *)kind WithStatus:(bool)status;

/**
 远端视频流数据回调
 
 @param videoTrack 视频数据
 @param peerId 视频id
 @param role 户角色
 @param displayName 显示名字
 */
- (void)onAddRemoteVideoTrack:(RTCVideoTrack *)videoTrack
                   WithPeerId:(NSString *)peerId
                     WihtRole:(NSString *)role
              WithDisplayName:(NSString*)displayName;


/**
 删除远端视频数据回调
 
 @param videoTrack 视频数据
 @param peerId 视频id
 */
- (void)onRemoveRemoteVideoTrack:(RTCVideoTrack *)videoTrack WithPeerId:(NSString *)peerId;

@end

#pragma VVPeerDelegate

@protocol VVPeerDelegate<ShinevvDelegate>
/**
 已有成员回调
 
 @param peersDict 成员信息
 */
- (void)onPeers:(NSDictionary *)peersDict;

/**
 成员加入回调
 
 @param peersDict 成员信息
 */
- (void)onJoinPeer:(NSDictionary *)peersDict;

/**
 成员离开回调
 
 @param peersDict 成员信息
 */
- (void)onRemovePeer:(NSDictionary *)peersDict;

/**
 老师授权消息
 
 @param AuthorDict 授权信息
 */
- (void)onAuthorZation:(NSDictionary *)AuthorDict;

@end

#pragma VVRouterDelegate
@protocol VVRouterDelegate<ShinevvDelegate>
/**
 路由消息回调
 @param routerUrl 回调内容
 */
- (void)onRecRouteMessage:(NSString *) routerUrl;

/**
 删除课件消息回调
 @param fileId 文件ID
 */
- (void)onDeletFile:(NSString *)fileId;
@end

@protocol VVChatDelegate<ShinevvDelegate>
/**
 IM消息发送失败回调
 @param mes 错误消息
 */
- (void)onSendChatMessageFail:(NSString *)mes;
/**
 收到IM消息
 @param mes 消息内容
 */
- (void)onReceiveImMes:(NSString *)mes;
@end

@protocol VVDrawBoardDelegate<ShinevvDelegate>
/**
 发送白板消息失败回调
 @param mes 错误信息
 */
- (void)onSendDrawBoardMessageFail:(NSString *)mes;
/**
 收到白板消息
 @param mes 画板消息
 */
- (void)onReceiveDrawBoarderMes:(NSString *)mes;
@end

@protocol VVPPTDelegate<ShinevvDelegate>

/**
 课件翻页
 @param page 跳转第几页
 */
- (void)onRecPPTMessage:(NSInteger) page;
@end

@protocol VVVideoDelegate<ShinevvDelegate>
/**
 停止播放视频回调
 */
- (void)stopPlay;
/**
 开始播放视频回调
 */
- (void)startPaly;
@end


@protocol VVStatsDelegate<ShinevvDelegate>
/**
 网络质量回调
 
 @param netWorkState 网络信息
 */
- (void)onRecTransportStats:(NetworkInfo)netWorkState;


@end

@interface Shinevv : NSObject

/**
 单例
 @return 管理类
 */
+ (instancetype)shareManager;
/**
 连接服务器，进入房间
 
 @param domain 服务器地址
 @param port 端口
 @param token 用户令牌
 @param displayName 本地视频显示名
 @param roomId 房间号
 @param role 身份
 */
- (void)joinRoom:(NSString*)domain
        WithPort:(NSInteger)port
       WithToken:(NSString *)token
 WithDisplayName:(NSString *)displayName
      WithRoomId:(NSString *)roomId
        WithRole:(NSString*) role;

/**
 重新连接
 */
- (void)reConnectSever;
/**
 离开房间
 */
- (void)leaveRoom;

/**
 接收视频数据流
 
 @param peerId 视频id
 @param pause 接收、拒收
 */
- (void)setPeerVideoPause:(NSString *)peerId Pause:(BOOL)pause;
/**
 发送IM消息
 
 @param mes 消息内容
 */
- (void)sendChatMessage:(NSString *)mes;

/**
 发送举手消息
 
 @param boolmes 举手、取消举手
 */
- (void)sendRaiseHandsMessage:(bool)boolmes;

/**
  当前用户是否举手状态
 */
- (bool)getRaisehandsState;

/**
 发送画板消息
 
 @param mes 消息内容
 */
- (void)sendDrawBoardMessage:(DrawBoard)mes;

/**
 清空画板
 */
- (void)clearDrawBoardID:(NSString *)boradID;

/**
 获取画板历史数据
 
 @param boardID 画板id
 */
- (NSMutableArray *)getDrawBoardData:(NSString *)boardID;

/**
 打开/关闭本地视频
 @param open true，打开；false，关闭
 */
- (void)modifyVideoStatus:(bool)open;

/**
 切换后置摄像头
 */
- (void)switchPostCamera;

/**
 切换前置摄像头
 */
- (void)swithcFrontCamera;

/**
 打开/关闭本地音频
 */
- (void)modifyAudioStatus:(bool)open;

/**
 关闭用户角色音视频
 @param role 用户角色
 */
- (void)closeRolesForAudioVideo:(NSString *)role;

/**
 获取用户信息
 peerid 用户id
 displayName 用户名字
 */
- (NSDictionary *)getUserInfo;

/**
 用户是否有控制权限
 */
- (bool)getUserAnth;

/**
 添加ShinevvDelegate
 */
-(void)addShinevvDelegate:(id<ShinevvDelegate>)delegate;

/**
 删除ShinevvDelegate
 */
-(void)removeShinevvDelegate:(id<ShinevvDelegate>)delegate;

/**
 获取画板数据
 */
-(NSMutableArray*)getDrawBoardHistory:(NSString*)drawBoardId;

@end

