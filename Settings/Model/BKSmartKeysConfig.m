//
//  BKSmartKeysConfig.m
//  Blink
//
//  Created by Atul M on 21/02/17.
//  Copyright © 2017 Carlos Cabañero Projects SL. All rights reserved.
//

#import "BKSmartKeysConfig.h"
#import "SmartKeysView.h"

NSMutableArray *SmartKeysConfigList;

static NSURL *DocumentsDirectory = nil;
static NSURL *ConfigURL = nil;

@implementation BKSmartKeysConfig

- (id)initWithCoder:(NSCoder *)coder
{
  _configName = [coder decodeObjectForKey:@"configName"];
  _keyList = [coder decodeObjectForKey:@"keyList"];
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:_configName forKey:@"configName"];
  [encoder encodeObject:_keyList forKey:@"keyList"];
}

- (id)initWithConfigName:(NSString*)configName keyList:(NSMutableArray*)keyList{
  self = [super init];
  if (self) {
    _configName = configName;
    _keyList = [NSMutableArray arrayWithArray:keyList];
  }
  return self;
}

+ (void)initialize
{
  [BKSmartKeysConfig loadConfigs];
}

+ (void)loadConfigs
{
  if (DocumentsDirectory == nil) {
    DocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    ConfigURL = [DocumentsDirectory URLByAppendingPathComponent:@"smartKeyConfig"];
  }
  
  // Load IDs from file
  if ((SmartKeysConfigList = [NSKeyedUnarchiver unarchiveObjectWithFile:ConfigURL.path]) == nil) {
    // Initialize the structure if it doesn't exist
    SmartKeysConfigList = [[NSMutableArray alloc] init];
    [BKSmartKeysConfig loadDefaultConfig];
  }
}

+(void)loadDefaultConfig{
  NSArray *keyList = @[
                 [[SmartKey alloc] initWithName:KbdTabKey
                                         symbol:@"\t"],
                 [[SmartKey alloc] initWithName:@"-"
                                         symbol:@"-"],
                 [[SmartKey alloc] initWithName:@"_"
                                         symbol:@"_"],
                 [[SmartKey alloc] initWithName:@"~"
                                         symbol:@"~"],
                 [[SmartKey alloc] initWithName:@"@"
                                         symbol:@"@"],
                 [[SmartKey alloc] initWithName:@"*"
                                         symbol:@"*"],
                 [[SmartKey alloc] initWithName:@"|"
                                         symbol:@"|"],
                 [[SmartKey alloc] initWithName:@"/"
                                         symbol:@"/"],
                 [[SmartKey alloc] initWithName:@"\\"
                                         symbol:@"\\"],
                 [[SmartKey alloc] initWithName:@"^"
                                         symbol:@"^"],
                 [[SmartKey alloc] initWithName:@"["
                                         symbol:@"["],
                 [[SmartKey alloc] initWithName:@"]"
                                         symbol:@"]"],
                 [[SmartKey alloc] initWithName:@"{"
                                         symbol:@"{"],
                 [[SmartKey alloc] initWithName:@"}"
                                         symbol:@"}"]
                 ];
  
  BKSmartKeysConfig *config = [[BKSmartKeysConfig alloc]initWithConfigName:@"Default" keyList:[NSMutableArray arrayWithArray:keyList]];
  [SmartKeysConfigList addObject:config];
  [BKSmartKeysConfig saveConfig];
}

+ (instancetype)withConfigName:(NSString *)configName
{
  for (BKSmartKeysConfig *config in SmartKeysConfigList) {
    if ([config->_configName isEqualToString:configName]) {
      return config;
    }
  }
  return nil;
}

+ (NSMutableArray *)all
{
  return SmartKeysConfigList;
}

+ (NSInteger)count
{
  return [SmartKeysConfigList count];
}

+ (BOOL)saveConfig
{
  // Save IDs to file
  return [NSKeyedArchiver archiveRootObject:SmartKeysConfigList toFile:ConfigURL.path];
}

+ (instancetype)saveConfig:(NSString*)configName withKeyList:(NSMutableArray*)keyList {
  BKSmartKeysConfig *bkconfig = [BKSmartKeysConfig withConfigName:configName];
  // Save password to keychain if it changed
  if (!bkconfig) {
    bkconfig = [[BKSmartKeysConfig alloc] initWithConfigName:configName keyList:keyList];
    [SmartKeysConfigList addObject:bkconfig];
  } else {
    bkconfig.configName = configName;
    bkconfig.keyList = keyList;
  }
  if([BKSmartKeysConfig saveConfig]){
    return bkconfig;
  }
  return nil;
}

@end
