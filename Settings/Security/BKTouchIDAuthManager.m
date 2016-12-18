//
//  BKTouchIDAuthManager.m
//  Blink
//
//  Created by Atul M on 05/12/16.
//  Copyright © 2016 Carlos Cabañero Projects SL. All rights reserved.
//

#import "BKTouchIDAuthManager.h"
#import "BKUserConfigurationManager.h"
#import "Blink-swift.h"

@import LocalAuthentication;

static BKTouchIDAuthManager *sharedManager = nil;
static BOOL authRequired = NO;

@interface BKTouchIDAuthManager ()

@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) PasscodeLockViewController *lockViewController;

@end

@implementation BKTouchIDAuthManager

+ (id)sharedManager{
  if([BKUserConfigurationManager userSettingsValueForKey:BKUserConfigAutoLock]){
    if(sharedManager == nil){
      sharedManager = [[self alloc] init];
    }
    return sharedManager;
  }else{
    //If user settings is turned off, return nil, so that all messages are ignored
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    return nil;
  }
}

- (instancetype)init{
  self = [super init];
  if(self){
    authRequired = YES;
  }
  return self;
}
-(void)registerforDeviceLockNotif
{
  //Screen lock notifications
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                  NULL, // observer
                                  displayStatusChanged, // callback
                                  CFSTR("com.apple.springboard.lockcomplete"), // event name
                                  NULL, // object
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                  NULL, // observer
                                  displayStatusChanged, // callback
                                  CFSTR("com.apple.springboard.lockstate"), // event name
                                  NULL, // object
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)didBecomeActive:(NSNotification*)notification{
  if([BKTouchIDAuthManager requiresTouchAuth]){
    [self authenticateUser];
  }
}

//call back
static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
  // the "com.apple.springboard.lockcomplete" notification will always come after the "com.apple.springboard.lockstate" notification
  authRequired = YES;
}

+ (BOOL)requiresTouchAuth{
  return authRequired && [BKUserConfigurationManager userSettingsValueForKey:BKUserConfigAutoLock];
}

- (void)authenticateUser{
  if(_lockViewController == nil){
    _lockViewController = [[PasscodeLockViewController alloc]initWithStateString:@"EnterPassCode"];
    __weak BKTouchIDAuthManager *weakSelf = self;
    _lockViewController.dismissCompletionCallback = ^{
      authRequired = NO;
      [[[UIApplication sharedApplication]keyWindow]setRootViewController:weakSelf.rootViewController];
      weakSelf.lockViewController = nil;
    };
    _rootViewController = [[[UIApplication sharedApplication]keyWindow]rootViewController];
    [[[UIApplication sharedApplication]keyWindow]setRootViewController:_lockViewController];
  }
}


@end
