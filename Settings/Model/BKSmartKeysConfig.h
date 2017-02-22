//
//  BKSmartKeysConfig.h
//  Blink
//
//  Created by Atul M on 21/02/17.
//  Copyright © 2017 Carlos Cabañero Projects SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKSmartKeysConfig : NSObject <NSCoding>

@property(nonatomic, strong) NSString *configName;
@property(nonatomic, strong) NSMutableArray *keyList;

+ (void)initialize;
+ (instancetype)withConfigName:(NSString *)configName;
+ (BOOL)saveConfig;
+ (instancetype)saveConfig:(NSString*)configName withKeyList:(NSMutableArray*)keyList;
+ (NSMutableArray *)all;
+ (NSInteger)count;

@end
