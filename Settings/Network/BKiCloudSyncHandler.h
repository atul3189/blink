//
//  BKiCloudSyncHandler.h
//  Blink
//
//  Created by Atul M on 10/11/16.
//  Copyright © 2016 Carlos Cabañero Projects SL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BKHosts;
@class CKRecordID;

typedef enum{
  BKiCloudRecordTypeHosts,
  BKiCloudRecordTypeKeys
}BKiCloudRecordType;

extern NSString const *BKiCloudSyncDeletedHosts;
extern NSString const *BKiCloudSyncUpdatedHosts;
extern NSString const *BKiCloudContainerIdentifier;
extern NSString const *BKiCloudZoneName;

@interface BKiCloudSyncHandler : NSObject

@property (nonatomic, copy) void (^mergeHostCompletionBlock) (void);
@property (nonatomic, copy) void (^mergeKeysCompletionBlock) (void);

+ (id)sharedHandler;
- (void)checkForReachabilityAndSync:(NSNotification*)notification;
- (void)syncFromiCloud;
- (void)deleteRecord:(CKRecordID*)recordId ofType:(BKiCloudRecordType)recordType;
- (void)createNewHost:(BKHosts*)host;

@end
