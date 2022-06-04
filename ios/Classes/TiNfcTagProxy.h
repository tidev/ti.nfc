/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <CoreNFC/CoreNFC.h>
#import <TitaniumKit/TitaniumKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TiNfcTagProxy : TiProxy {
  id<NFCTag> _tag;
}
- (id<NFCMiFareTag>)asNFCMiFareTag;

- (id<NFCISO15693Tag>)asNFCISO15693Tag;

- (id<NFCFeliCaTag>)asNFCFeliCaTag;

- (id<NFCISO7816Tag>)asNFCISO7816Tag;

- (id)_initWithPageContext:(id<TiEvaluator>)context andTag:(id<NFCTag>)tag;

#pragma mark Public API's

- (id<NFCTag>)tag;

- (NSNumber *)available;

- (NSNumber *)nfcTagType;
@end

NS_ASSUME_NONNULL_END
