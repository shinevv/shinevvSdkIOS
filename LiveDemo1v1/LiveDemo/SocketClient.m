//
//  SocketClient.m
//  LiveDemo
//
//  Created by 无线视通 on 2018/9/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "SocketClient.h"
#import <SocketIO/SocketIO-Swift.h>
#import "AppDelegate.h"
@interface SocketClient()
{
    //SocketIO* socketIO;
}
@property (nonatomic, strong)SocketIOClient* socket;
@property (nonatomic, strong)SocketManager* manager;
@end
static SocketClient* _client = nil;
@implementation SocketClient


+ (SocketClient*)client
{
    if (!_client) {
        _client = [[SocketClient alloc]init];
    }
    return _client;
}

+ (void)openSocket{
    NSURL* url  = [[NSURL alloc] initWithString:@"https://58.87.67.88:3001"];

    //SocketIOClientOption.Cookies([currCookie])])
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [SocketClient client].manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log":@YES, @"compress":@YES, @"forcePolling": @YES, @"selfSigned": @YES, @"sessionDelegate":appDelegate}];
    SocketIOClient* socket = [SocketClient client].manager.defaultSocket;

    [socket on:@"connect" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"socket connected");
    }];

    [SocketClient client].socket = socket;
    [[SocketClient client].socket connect];
    [[SocketClient client] setUpEvents];
    
    
}

- (void)setUpEvents{

    __weak SocketClient * ws = self;
    [_socket on:@"login" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"login");
        if ([ws.loginDelegate respondsToSelector:@selector(onLogin:)]) {
            [ws.loginDelegate onLogin:data];
        }
    }];
    
    [_socket on:@"user joined" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"user joined");
        if ([ws.dataDelegate respondsToSelector:@selector(onUserJoined:)]) {
            [ws.dataDelegate onUserJoined:data];
        }
    }];
    
    [_socket on:@"user left" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"user left");
        if ([ws.dataDelegate respondsToSelector:@selector(onUserLeft:)]) {
            [ws.dataDelegate onUserLeft:data];
        }
    }];
    [_socket on:@"calling" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"calling");
        NSLog(@"data type: %@" , NSStringFromClass(data.class));
        if ([ws.dataDelegate respondsToSelector:@selector(onCalling:)]) {
            [ws.dataDelegate onCalling:data];
        }
    }];
    [_socket on:@"call agree" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"call agree");
        if ([ws.dataDelegate respondsToSelector:@selector(onCallAgree:)]) {
            [ws.dataDelegate onCallAgree:data];
        }
    }];
    [_socket on:@"call end" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"call end");
        if ([ws.dataDelegate respondsToSelector:@selector(onCallEnd:)]) {
            [ws.dataDelegate onCallEnd:data];
        }
    }];
}

- (void)loginWithName:(NSString*)name;
{
    
    [_socket emit:@"add user" with:@[name]];
    
}

- (void)callFormName:(NSString*)nama toName:(NSString*)toName type:(int)type room:(long)roomid {
    [_socket emit:@"call" with:@[toName,@(type),@(roomid)]];
}


- (void)callAgreeWithRoom:(long)roomId{
    [_socket emit:@"call agree" with:@[@(roomId)]];
}

- (void)callEndWithRoom:(long)roomId{
    [_socket emit:@"call end" with:@[@(roomId)]];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
    
}

@end
