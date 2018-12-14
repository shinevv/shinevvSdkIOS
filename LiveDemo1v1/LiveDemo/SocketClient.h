//
//  SocketClient.h
//  LiveDemo
//
//  Created by 无线视通 on 2018/9/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocketClientDelegate <NSObject>
@optional
- (void)onLogin:(NSArray*)data;
- (void)onUserJoined:(NSArray*)data;
- (void)onUserLeft:(NSArray*)data;
- (void)onCalling:(NSArray*)data;
- (void)onCallAgree:(NSArray*)data;
- (void)onCallEnd:(NSArray*)data;
- (void)onRoom:(NSDictionary*)data;
@end

@interface SocketClient : NSObject
@property (nonatomic, weak)id<SocketClientDelegate> loginDelegate;
@property (nonatomic, weak)id<SocketClientDelegate> dataDelegate;
+ (SocketClient*)client;
+ (void)openSocket;
- (void)loginWithName:(NSString*)name;
- (void)callFormName:(NSString*)nama toName:(NSString*)toName type:(int)type room:(long)roomid token:(NSString*)token;
- (void)callAgreeWithRoom:(long)roomId;
- (void)callEndWithRoom:(long)roomId;
- (void)getRoom;
@end
