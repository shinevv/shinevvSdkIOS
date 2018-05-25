//
//  ShinevvNSString.h
//  VVRoomPeerconnection
//
//  Created by Apple on 2018/2/28.
//  Copyright © 2018年 BeijingWireless. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ShinevvNSString : NSObject

+ (instancetype)shareNSString;

- (NSString *)clearHDbardWith:(NSString *)drawBoardID;

- (NSString *)sendMessageHDbard:(NSMutableArray *)proint
                     WihtcColor:(NSString *)color
                    WithPenSize:(NSNumber*)pensize
                    WihtPentype:(NSNumber *)pen
                   WithbordType:(NSString *)bordType
               WithSentBordSize:(CGRect)bordSize;

- (NSString *)setPenArray:(NSMutableArray *)array
                WithColor:(NSString *)color
              WithPenSize:(NSNumber *)pensize
              WithPenType:(NSNumber *)pen
             WithbordType:(NSString *)bordType
            WithSentBordSize:(CGRect)bordSize;

-(NSString *)convertToJsonData:(NSDictionary *)dict;


@end
