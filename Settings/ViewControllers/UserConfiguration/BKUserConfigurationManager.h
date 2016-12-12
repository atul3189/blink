//
//  BKUserConfigurationManager.h
//  Blink
//
//  Created by Atul M on 12/12/16.
//  Copyright © 2016 Carlos Cabañero Projects SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKUserConfigurationManager : NSObject
+ (void)setUserSettingsValue:(BOOL)value forKey:(NSString*)key;
+ (BOOL)userSettingsValueForKey:(NSString*)key;
@end
