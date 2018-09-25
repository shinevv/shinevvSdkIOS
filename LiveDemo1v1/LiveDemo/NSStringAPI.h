//
//  NSStringAPI.h
//  VVRoom
//
//  Created by Apple on 2017/11/30.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringAPI : NSObject


+ (NSString *)convertToJsonData:(NSDictionary *)dict;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


@end
