//
//  BKUserConfigurationManager.m
//  Blink
//
//  Created by Atul M on 12/12/16.
//  Copyright © 2016 Carlos Cabañero Projects SL. All rights reserved.
//

#import "BKUserConfigurationManager.h"

@implementation BKUserConfigurationManager

+ (void)setUserSettingsValue:(BOOL)value forKey:(NSString*)key{
  NSMutableDictionary *userSettings = [NSMutableDictionary dictionaryWithDictionary:  [[NSUserDefaults standardUserDefaults]objectForKey:@"userSettings"]];
  if(userSettings == nil){
    userSettings = [NSMutableDictionary dictionary];
  }
  [userSettings setObject:[NSNumber numberWithBool:value] forKey:key];
  [[NSUserDefaults standardUserDefaults]setObject:userSettings forKey:@"userSettings"];
}

+ (BOOL)userSettingsValueForKey:(NSString*)key{
  NSDictionary *userSettings = [[NSUserDefaults standardUserDefaults]objectForKey:@"userSettings"];
  if(userSettings != nil){
    if([userSettings objectForKey:key]){
      NSNumber *value = [userSettings objectForKey:key];
      return value.boolValue;
    }else{
      return NO;
    }
  }else{
    return NO;
  }
  return NO;
}

@end
