/**
 * Ti.NFC
 * Copyright (c) 2009-2018 by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#if IS_IOS_11

#import "TiProxy.h"
#import <CoreNFC/CoreNFC.h>

@interface TiNfcNfcAdapterProxy : TiProxy <NFCNDEFReaderSessionDelegate, NFCTagReaderSessionDelegate> {
  NFCNDEFReaderSession *_nfcSession;
  NFCTagReaderSession *_nfcTagReadersession;
  KrollCallback *_ndefDiscoveredCallback;
  KrollCallback *_nNdefInvalidated;
}

#pragma mark Public API's

- (NSNumber *)isEnabled:(id)unused;

- (void)begin:(id)unused;

- (void)invalidate:(id)unused;

- (void)setOnNdefDiscovered:(KrollCallback *)callback;

- (void)setOnNdefInvalidated:(KrollCallback *)callback;

@end

#endif
