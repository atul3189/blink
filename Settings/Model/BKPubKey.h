////////////////////////////////////////////////////////////////////////////////
//
// B L I N K
//
// Copyright (C) 2016 Blink Mobile Shell Project
//
// This file is part of Blink.
//
// Blink is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Blink is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Blink. If not, see <http://www.gnu.org/licenses/>.
//
// In addition, Blink is also subject to certain additional terms under
// GNU GPL version 3 section 7.
//
// You should have received a copy of these additional terms immediately
// following the terms and conditions of the GNU General Public License
// which accompanied the Blink Source Code. If not, see
// <http://www.github.com/blinksh/blink>.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
@import CloudKit;

@interface SshRsa : NSObject

- (SshRsa *)initWithLength:(int)bits;
- (SshRsa *)initFromPrivateKey:(NSString *)privateKey passphrase:(NSString *)passphrase;
- (NSString *)privateKey;
- (NSString *)privateKeyWithPassphrase:(NSString *)passphrase;
- (NSString *)publicKeyWithComment:(NSString*)comment;

@end

@interface BKPubKey : NSObject <NSCoding>

@property NSString *ID;
@property (readonly) NSString *privateKey;
@property (readonly) NSString *publicKey;

@property (nonatomic, strong) CKRecordID *iCloudRecordId;
@property (nonatomic, strong) NSDate *lastModifiedTime;
@property (nonatomic, strong) NSNumber *iCloudConflictDetected;
@property (nonatomic, strong) BKPubKey *iCloudConflictCopy;

+ (void)initialize;
+ (instancetype)withID:(NSString *)ID;
+ (BOOL)saveIDS;
+ (id)saveCard:(NSString *)ID privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey;
+ (void)updateCard:(NSString*)ID withiCloudId:(CKRecordID*)iCloudId andLastModifiedTime:(NSDate*)lastModifiedTime;
+ (void)markCard:(NSString*)ID forRecord:(CKRecord*)record withConflict:(BOOL)hasConflict;
+ (NSMutableArray *)all;
+ (NSInteger)count;
+ (CKRecord*)recordFromHost:(BKPubKey*)host;
+ (BKPubKey*)hostFromRecord:(CKRecord*)hostRecord;
+ (instancetype)withiCloudId:(CKRecordID *)record;

- (NSString *)publicKey;
- (NSString *)privateKey;
- (BOOL)isEncrypted;

@end

// Responsible of the lifecycle of the IDCards within the system.
// Offers a directory to the rest, in the same way that you wouldn't offer everything in a file interface.
// Class methods can give us this, then we can connect the TableViewController for rendering, extending them with
// a Decorator (or in this case maybe a custom View that represents the Cell)
