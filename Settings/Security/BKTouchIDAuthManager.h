//
//  BKTouchIDAuthManager.h
//  Blink
//
//  Created by Atul M on 05/12/16.
//  Copyright © 2016 Carlos Cabañero Projects SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BKTouchIDAuthManager : NSObject
+ (id)sharedManager;
+ (BOOL)requiresTouchAuth;
- (void)registerforDeviceLockNotif;
@end
