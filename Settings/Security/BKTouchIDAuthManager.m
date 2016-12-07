//
//  BKTouchIDAuthManager.m
//  Blink
//
//  Created by Atul M on 05/12/16.
//  Copyright © 2016 Carlos Cabañero Projects SL. All rights reserved.
//

#import "BKTouchIDAuthManager.h"
#import "BKUserConfigurationViewController.h"
@import LocalAuthentication;

static BKTouchIDAuthManager *sharedManager = nil;
static BOOL authRequired = NO;

@interface BKTouchIDAuthManager ()

@end

@implementation BKTouchIDAuthManager

+ (id)sharedManager{
  if([BKUserConfigurationViewController userSettingsValueForKey:@"iCloudSync"]){
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
    [self registerforDeviceLockNotif];
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
    [self authenticateUserWithCallBack:nil];
  }
}

//call back
static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
  // the "com.apple.springboard.lockcomplete" notification will always come after the "com.apple.springboard.lockstate" notification
  
  NSString *lockState = (__bridge NSString*)name;
  NSLog(@"Darwin notification NAME = %@",name);
  
  if([lockState isEqualToString:@"com.apple.springboard.lockcomplete"])
  {
    NSLog(@"DEVICE LOCKED");
  }
  else
  {
    NSLog(@"LOCK STATUS CHANGED");
  }
  authRequired = YES;
}

+ (BOOL)requiresTouchAuth{
  return authRequired;
}

- (void)authenticateUserWithCallBack:(void (^) (BOOL)) completionBlock{
  LAContext *context = [[LAContext alloc] init];
  
  NSError *error = nil;
  if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
            localizedReason:@"Are you the device owner?"
                      reply:^(BOOL success, NSError *error) {
                        
                        if (error) {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                          message:@"There was a problem verifying your identity."
                                                                         delegate:nil
                                                                cancelButtonTitle:@"Ok"
                                                                otherButtonTitles:nil];
                          [alert show];
                          return;
                        }
                        
                        if (success) {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                          message:@"You are the device owner!"
                                                                         delegate:nil
                                                                cancelButtonTitle:@"Ok"
                                                                otherButtonTitles:nil];
                          [alert show];
                          authRequired = NO;
                          
                        } else {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                          message:@"You are not the device owner."
                                                                         delegate:nil
                                                                cancelButtonTitle:@"Ok"
                                                                otherButtonTitles:nil];
                          [alert show];
                        }
                        
                      }];
    
  } else {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Your device cannot authenticate using TouchID."
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
    
  }
}

@end
