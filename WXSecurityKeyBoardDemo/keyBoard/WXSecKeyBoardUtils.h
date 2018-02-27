//
//  WXSecKeyBoardUtils.h
//  WXSecurityKeyBoardDemo
//
//  Created by WuXian on 16/9/6.
//  Copyright © 2016年 WuXian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXSecKeyBoardUtils : NSObject

+ (int)initializePrivate:(NSString *)key;

+ (int)initializPublicKey:(NSString *)pubKey;

+ (NSString *)getPrivateKey;

+ (NSString *)encryptRSA:(NSString *)content;

+ (NSString *)decryptRSA:(NSString *)encrypt;

+ (void)removeHomeKeyPath;

@end
