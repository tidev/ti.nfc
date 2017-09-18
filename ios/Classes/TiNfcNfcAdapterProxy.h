/**
 * Ti.NFC
 * Copyright (c) 2009-2017 by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#if IS_IOS_11

#import "TiProxy.h"
#import <CoreNFC/CoreNFC.h>

@interface TiNfcNfcAdapterProxy : TiProxy <NFCNDEFReaderSessionDelegate> {
  NFCNDEFReaderSession *_nfcSession;
  KrollCallback *_ndefDiscoveredCallback;
}

#pragma mark Public API's

- (void)begin:(id)unused;

- (void)invalidate:(id)unused;

@end

#endif
