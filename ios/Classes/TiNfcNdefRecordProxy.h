/**
 * Ti.NFC
 * Copyright (c) 2009-2018 by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#if IS_IOS_11

#import "TiBlob.h"
#import "TiProxy.h"
#import <CoreNFC/CoreNFC.h>

@interface TiNfcNdefRecordProxy : TiProxy {
  NFCNDEFPayload *_record;
}

#pragma mark Public API's

- (id)_initWithPageContext:(id<TiEvaluator>)context andRecord:(NFCNDEFPayload *)record;

- (NSString *)id;

- (TiBlob *)payload;

- (NSString *)text;

- (NSString *)type;

- (NSNumber *)tnf;

@end

#endif
