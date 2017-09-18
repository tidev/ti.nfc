/**
 * Ti.NFC
 * Copyright (c) 2009-2017 by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#if IS_IOS_11

#import <CoreNFC/CoreNFC.h>
#import <Foundation/Foundation.h>

@interface TiNfcUtilities : NSObject

+ (NSArray<NSDictionary<NSString *, id> *> *)arrayFromNDEFMessages:(NSArray<NFCNDEFMessage *> *)messages;

+ (NSArray<NSDictionary<NSString *, id> *> *)arrayFromNDEFPayloads:(NSArray<NFCNDEFPayload *> *)payloads;

@end

#endif
